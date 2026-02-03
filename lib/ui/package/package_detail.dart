import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/cart_model.dart';

import 'cart.dart';

class PackageDetail extends StatefulWidget {

  const PackageDetail({Key? key}) : super(key: key);

  @override
  State<PackageDetail> createState() => _PackageDetailState();
}

class _PackageDetailState extends State<PackageDetail> {

  bool isLoading = false;
  int itemCount = 0;

  Widget buildContent() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 17.0),
          Image.asset(
            'images/imgs/pckx1.png',
            width: 375.0,
            height: 375.0,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 12.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Post Covid-19 Screening Package',
              style: kTitleTextStyle,
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'RM 450.00',
              style: kTitleTextStyle.copyWith(
                fontSize: 20.0,
                color: kMainColor,
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Description',
              style: kLabelTextStyle.copyWith(
                fontSize: 16.0,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
            child: Text(
              '''This service is offered to Covid-19 patients who have since recovered but are worried about any long-term negative health impacts as well as those who are coping with post-COVID-19 syndrome or “long COVID”.
          
Book your Post COVID-19 Screening Package and get the affirmation you need on your current health.

COVID-19 post-recovery screening tests include:

• Full Blood Count
• Chest X-Ray
• Neutralising Antibody
• C-Reactive Protein (CRP)
• Ferritin
• Erythrocyte Sedimentation Rate (ESR)
• Electrocardiogram (ECG)
• CK-MB
• Consultation by a Physician

For more details or enquiries, please call +604 2383 388''',
              style: kMainTextStyle.copyWith(
                fontFamily: kBodyFont,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: const Color(0xFFF8F8F8),
        leading: const BackBtn(color: Color(0xFF002E50)),
        centerTitle: true,
        title: Text(
          'Package Details',
          style: kMainTextStyle.copyWith(
            fontSize: 16.0,
            color: const Color(0xFF002E50),
          ),
        ),
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 23.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: Image.asset(
                    'images/icon/cart.png',
                    width: 21.33,
                    height: 18.91,
                    fit: BoxFit.cover,
                  ),
                  onPressed: () {
                    Get.to(() => const Cart());
                  },
                ),
                Positioned(
                  top: 6.0,
                  right: 8.0,
                  child: Container(
                    width: 16.0,
                    height: 16.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6BE7F),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Center(
                      child: Text(
                        '${context.watch<CartModel>().cartItemCount}',
                        style: kBodyTextStyle.copyWith(
                          fontSize: 9.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(),
        child: SafeArea(
          child: isLoading ? Container() : Stack(
            children: [
              buildContent(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 16.0, bottom: 28.0),
                  color: const Color(0xFFF8F8F8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: itemCount < 1 ? null : () {
                          setState(() {
                            --itemCount;
                          });
                        },
                        icon: Image.asset(
                          'images/icon/minus1.png',
                          width: 32.0,
                          height: 32.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          '$itemCount',
                          style: kMainTextStyle.copyWith(
                            fontFamily: kBodyFont,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            ++itemCount;
                          });
                        },
                        icon: Image.asset(
                          'images/icon/plus1.png',
                          width: 32.0,
                          height: 32.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<CartModel>().addCartItem(itemCount);
                            setState(() {
                              itemCount = 0;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5.0,
                            backgroundColor: kMainColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                          ),
                          child: Text(
                            'Add To Cart',
                            style: kMainTextStyle.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}