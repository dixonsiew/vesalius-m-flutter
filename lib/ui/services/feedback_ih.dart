import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:mime_type/mime_type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/image_box.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/feedback_ih_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/main_layout.dart';

class FeedbackIH extends StatefulWidget {

  final String? visitType;
  final String? accountNo;

  const FeedbackIH({
    super.key, 
    this.visitType, 
    this.accountNo,
  });

  @override
  State<FeedbackIH> createState() => _FeedbackIHState();
}

class _FeedbackIHState extends State<FeedbackIH> {

  ScrollController scr = ScrollController();
  late final TextEditingController txtdesc;
  final ImagePicker picker = ImagePicker();

  final FeedbackIHCtrl ctrl = Get.put(FeedbackIHCtrl());

  @override
  void initState() {
    super.initState();
    txtdesc = TextEditingController();
    ctrl.init(
      Container(
        width: 80.0,
        height: 80.0,
        margin: const EdgeInsets.only(right: 8.0),
        child: Material(
          elevation: 5.0,
          shadowColor: kColor1.withValues(alpha:  0.5),
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          child: Obx(() =>
            InkWell(
              borderRadius: BorderRadius.circular(5.0),
              onTap: ctrl.filesCount < 4 ? onTakePhoto : null,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: kColor10),
                ),
                child: Center(
                  child: Image.asset(
                    'images/imgs/upload.png',
                    width: 24.0,
                    height: 24.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scr.dispose();
    txtdesc.dispose();
    super.dispose();
  }

  Widget get separator => Container(
    height: 0.5,
    color: const Color.fromRGBO(60, 60, 67, 0.36),
  );

  void showSuccess() {
    Get.dialog(PopScope(
      canPop: false,
      child: AlertDialog(
        scrollable: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'images/icon/tick.png',
                width: 40.0,
                height: 40.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Feedback Submitted',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                'We are happy to hear from you!\n.Thank you for your valuable feedback.',
                style: kTextStyle1.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              AppElevatedButton(
                text: 'Done',
                onPressed: () {
                  Get.back();
                  Get.until((route) => Get.currentRoute == MainLayout.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    ), barrierDismissible: false);
  }

  void onGallery() async {
    Get.back();

    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      final ls = res?.files;
      if (ls != null) {
        PlatformFile pf = ls.first;
        ImageData xd = ImageData(key: UniqueKey(), path: pf.path!, filename: pf.name);
        File fimageFile = File(pf.path ?? '');
        // if (pf.size > kMaxFileSize) {
        //   showCustomDialog('Invalid', 'Max image size is $kMaxFileSizeStr', 'Dismiss');
        //   return;
        // }

        ctrl.setImageFile(fimageFile);
        ctrl.ld.add(xd);
        ctrl.addWidget(
          ImageBox(
            key: xd.key,
            imageFile: fimageFile,
            onTap: (key) {
              ctrl.removeWidget(key);
            },
          )
        );
      }
    }

    on PlatformException catch (error) {
      showCustomDialog('Open Gallery Failed', error.message ?? error.toString(), 'Dismiss');
    }

    catch (error) {
      showCustomDialog('Open Gallery Failed', error.toString(), 'Dismiss');
    }
  }

  void onFiles() async {
    Get.back();

    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'tiff', 'pdf'],
        compressionQuality: 0,
      );
      final ls = res?.files;
      if (ls != null) {
        PlatformFile pf = ls.first;
        ImageData xd = ImageData(key: UniqueKey(), path: pf.path!, filename: pf.name);
        File fimageFile = File(pf.path ?? '');
        // if (pf.size > kMaxFileSize) {
        //   showCustomDialog('Invalid', 'Max image size is $kMaxFileSizeStr', 'Dismiss');
        //   return;
        // }

        ctrl.setImageFile(fimageFile);
        ctrl.ld.add(xd);
        ctrl.addWidget(
          ImageBox(
            key: xd.key,
            imageFile: fimageFile,
            onTap: (key) {
              ctrl.removeWidget(key);
            },
          ),
        );
      }
    }

    on PlatformException catch (error) {
      showCustomDialog('Open Files Failed', error.message ?? error.toString(), 'Dismiss');
    }

    catch (error) {
      showCustomDialog('Open Files Failed', error.toString(), 'Dismiss');
    }
  }

  void onCamera() async {
    Get.back();
    XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      ImageData xd = ImageData(key: UniqueKey(), path: photo.path, filename: photo.name);
      File fimageFile = File(photo.path);
      // int x = await photo.length();
      // if (x > kMaxFileSize) {
      //   showCustomDialog('Invalid', 'Max image size is $kMaxFileSizeStr', 'Dismiss');
      //   return;
      // }

      ctrl.setImageFile(fimageFile);
      ctrl.ld.add(xd);
      ctrl.addWidget(
        ImageBox(
          key: xd.key,
          imageFile: fimageFile,
          onTap: (key) {
            ctrl.removeWidget(key);
          },
        )
      );
    }
  }

  void onTakePhoto() {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.only(top: 19.0, bottom: 12.0),
      backgroundColor: kColor28.withValues(alpha:  1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 19.0),
            Text(
              'Choose from',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: kTextColor4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 19.0),
            separator,
            InkWell(
              onTap: onFiles,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.5, bottom: 14.0),
                child: Text(
                  'Files',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kColor16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            separator,
            InkWell(
              onTap: onGallery,
              child: Padding(
                padding: const EdgeInsets.only(top: 14.5, bottom: 15.0),
                child: Text(
                  'Photo Gallery',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kColor16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            separator,
            InkWell(
              onTap: onCamera,
              child: Padding(
                padding: const EdgeInsets.only(top: 14.5, bottom: 15.0),
                child: Text(
                  'Camera',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kColor16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            separator,
            InkWell(
              onTap: () => Get.back(),
              child: Padding(
                padding: const EdgeInsets.only(top: 14.5, bottom: 15.0),
                child: Text(
                  'Cancel',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kColor16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void onSubmit() async {
    try {
      ctrl.setIsLoading(true);
      List<dio.MultipartFile> ld = [];
      List<dynamic> lm = [];
      if (ctrl.ld.isNotEmpty) {
        for (var x in ctrl.ld) {
          ld.add(await dio.MultipartFile.fromFile(x.path, filename: x.filename));
          lm.add({
            'filename': x.filename,
            'mimeType': mime(x.filename) ?? 'application/octet-stream'
          });
        }
      }
      PatientDetails? x = await DataManager.instance.getPatientDetails();
      final o = {
        'patientPrn': x?.prn ?? '',
        'accountNo': widget.accountNo ?? '',
        'visitType': widget.visitType ?? '',
        'overallRating': ctrl.val,
        'hospitalServiceRating': ctrl.lxval[0],
        'staffServiceRating': ctrl.lxval[1],
        'apptSchedulingRating': ctrl.lxval[2],
        'foodBeveragesRating': ctrl.lxval[3],
        'paymentBillingRating': ctrl.lxval[4],
        'recommendUsRating': ctrl.valr,
        'feedbackDesc': txtdesc.text,
        'feedbackFiles': jsonEncode(lm),
        'files': ctrl.ld.isEmpty ? null : ld
      };
      await FeedbackService.postFeedback(o);
      ctrl.setIsLoading(false);
      showSuccess();
    }

    on dio.DioException catch (error) {
      ctrl.setIsLoading(false);
      handleSubmitError(error, error.toString(), onSubmit);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'dismiss'.tr);
    }
  }

  void setVal(double value) {
    ctrl.setVal(value);
  }

  void setValr(double value) {
    ctrl.setValr(value);
  }

  void setValx(int i, double value) {
    ctrl.setValx(i, value);
  }

  Widget buildMore() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(color: Color(0xFFADADAD)),
        ),

        RatingX(
          index: 0,
          label: 'Hospital Services',
          val: ctrl.lxval[0],
          setVal: setValx,
        ),
        RatingX(
          index: 1,
          label: 'Staff Services',
          val: ctrl.lxval[1],
          setVal: setValx,
        ),
        RatingX(
          index: 2,
          label: 'Appointment Scheduling',
          val: ctrl.lxval[2],
          setVal: setValx,
        ),
        RatingX(
          index: 3,
          label: 'Food & Beverages',
          val: ctrl.lxval[3],
          setVal: setValx,
        ),
        RatingX(
          index: 4,
          label: 'Payment & Billing',
          val: ctrl.lxval[4],
          setVal: setValx,
        ),
      ],
    );
  }

  Widget buildForm() {
    return Scrollbar(
      controller: scr,
      child: ListView(
        controller: scr,
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.only(top: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: kColor1.withValues(alpha:  0.45)),
              boxShadow: [
                BoxShadow(
                  color: kBgColor2.withValues(alpha:  0.4),
                  blurRadius: 7.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Overall Satisfaction with us',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '(On scale 1 - 10; 1 is unlikely, 10 is most likely)',
                    style: kTextStyle1.copyWith(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor1,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Rating(setVal: setVal),
                Obx(() =>
                  AnimatedOpacity(
                    opacity: ctrl.opacityLevel,
                    duration: const Duration(seconds: 1),
                    child: Visibility(
                      visible: ctrl.isViewMore,
                      child: buildMore(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        ctrl.setViewMore(!ctrl.isViewMore);
                        ctrl.setOpacityLevel(ctrl.opacityLevel == 0.0 ? 1.0 : 0.0);
                      },
                      style: TextButton.styleFrom(
                      foregroundColor: kPrimaryColor,
                    ),
                    child: Obx(() =>
                      Text(
                        ctrl.isViewMore ? 'View Less' : 'View More',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16.0),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: kColor1.withValues(alpha:  0.45)),
              boxShadow: [
                BoxShadow(
                  color: kBgColor2.withValues(alpha:  0.4),
                  blurRadius: 7.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: kBgColor2.withValues(alpha:  0.1),
                        offset: const Offset(0.0, 4.0),
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: txtdesc,
                    cursorColor: kTextColor1,
                    style: const TextStyle(
                      fontFamily: kBodyFont,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor1,
                    ),
                    maxLines: 3,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15.0),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Share with us more on your experience today',
                      hintStyle: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor5,
                      ),
                      enabledBorder: kEnabledBorder,
                      focusedBorder: kFocusedBorder,
                    ),
                    onChanged: (String s) {
                      
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Add Photo / File ',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                      TextSpan(
                        text: '(JPG/PDF)',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17.0),
                Obx(() =>
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: ctrl.lx,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16.0),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.only(top: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: kColor1.withValues(alpha:  0.45)),
              boxShadow: [
                BoxShadow(
                  color: kBgColor2.withValues(alpha:  0.4),
                  blurRadius: 7.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Would you recommend us to your family and friends?',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Rating(setVal: setValr),
              ],
            ),
          ),

          const SizedBox(height: 16.0),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppElevatedButton(
              text: 'Submit',
              onPressed: onSubmit,
            ),
          ),

          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Feedback',
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}

class Rating extends StatefulWidget {

  final void Function(double) setVal;

  const Rating({
    super.key,
    required this.setVal,
  });

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {

  double val = 10.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: SfSliderTheme(
        data: const SfSliderThemeData(
          labelOffset: Offset(0.0, -35.0),
          activeTrackHeight: 8.0,
          inactiveTrackHeight: 8.0,
        ),
        child: SfSlider(
          min: 1.0,
          max: 10.0,
          interval: 1.0,
          stepSize: 1.0,
          value: val,
          activeColor: kPrimaryColor,
          inactiveColor: kPrimaryColor.withValues(alpha:  0.2),
          showLabels: true,
          onChanged: (value) {
            setState(() {
              val = value;
            });
            widget.setVal(val);
          },
        ),
      ),
    );
  }
}

class RatingX extends StatefulWidget {

  final String label;
  final int index;
  final double val;
  final void Function(int, double) setVal;

  const RatingX({
    super.key,
    required this.label,
    required this.index,
    required this.val,
    required this.setVal,
  });

  @override
  State<RatingX> createState() => _RatingXState();
}

class _RatingXState extends State<RatingX> {

  double val = 1.0;

  @override
  void initState() {
    super.initState();
    val = widget.val;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.label,
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            flex: 2,
            child: SfSliderTheme(
              data: const SfSliderThemeData(
                labelOffset: Offset(0.0, -35.0),
                activeTrackHeight: 8.0,
                inactiveTrackHeight: 8.0,
              ),
              child: SfSlider(
                min: 1.0,
                max: 5.0,
                interval: 1.0,
                stepSize: 1.0,
                value: val,
                activeColor: kPrimaryColor,
                inactiveColor: kPrimaryColor.withValues(alpha:  0.2),
                showLabels: true,
                onChanged: (value) {
                  setState(() {
                    val = value;
                  });
                  widget.setVal(widget.index, value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}