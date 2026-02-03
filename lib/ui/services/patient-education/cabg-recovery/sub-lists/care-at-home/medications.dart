import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class Medications extends StatefulWidget {

  const Medications({super.key});

  @override
  State<Medications> createState() => _MedicationsState();
}

class _MedicationsState extends State<Medications> {

  ScrollController scr = ScrollController();

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }
  
  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: ListView(
            controller: scr,
            shrinkWrap: true,
            children: [
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0, 
                  vertical: 16.0,
                ),
                child: Text(
                  'Medications',
                  style: kTextStyle1.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0, 
                ),
                child: Text(
                  '''
Most people who have had bypass surgery are sent home with prescriptions for several medications, most of which are taken every day. Some of these drugs improve survival, decrease the risk of complications, and help to prevent or treat recurrent chest pain.

● Antiplatelet therapy – Aspirin is an antiplatelet medication that is given to help prevent the formation of blood clots that can block either your coronary arteries or coronary bypass graft. It is usually recommended indefinitely. (See "Patient education: Aspirin in the primary prevention of cardiovascular disease and cancer (Beyond the Basics)".)

● Beta blockers – Beta blockers slow the heart rate, lower blood pressure, and decrease the heart's demand for oxygen. They are given to some patients with high blood pressure, heart failure, some rhythm changes or a heart attack, and to some patients in whom bypass surgery is not expected to relieve all symptoms of angina. If a person cannot tolerate a beta blocker, a calcium channel blocker may be substituted.

● Nitrates – A nitrate, either as short-acting nitroglycerin, or as a long-acting preparation (isosorbide mononitrate or dinitrate). These drugs dilate coronary blood vessels, bringing more blood to the heart muscle. Nitrates also reduce the amount of blood returning to the heart, which decreases the heart's demand for oxygen. Nitrates are often given to treat or prevent further episodes of chest pain. Nitrates may be given to patients after bypass surgery if some of the coronary blood vessels could not be bypassed. (See "Patient education: Medications for angina (Beyond the Basics)".)

● ACE inhibitor – Angiotensin converting enzyme (ACE) inhibitors are often used to treat high blood pressure.

Examples of ACE inhibitors include captopril (brand name: Capoten), enalapril (brand name: Vasotec), lisinopril (sample brand names: Zestril or Prinivil), and ramipril (brand name: Altace).

Some patients who cannot tolerate an ACE inhibitor (often because of a chronic cough) may be prescribed an angiotensin II receptor blocker (ARB). These related drugs are satisfactory replacements.

Examples of ARBs include losartan (brand name: Cozaar), valsartan (brand name: Diovan), and irbesartan (brand name: Avapro).

● Lipid-lowering therapy – Almost all patients are given a medication to lower lipids after CABG. Cholesterol lowering can be beneficial both before and after CABG because it can reduce the progression of atherosclerosis in both native and graft vessels.

● Other medications – Other medications may be given on a short-term basis to prevent the development of an irregular heart, to manage discomfort associated with healing incisions, or to allow for regular bowel movements.

Lipid therapies are recommended even for patients who have values that are in the "normal" range. The goal level for "bad" cholesterol (called LDL or low density lipoprotein) is less than 70 mg/dL (1.8 mmol/L). (See "Patient education: High cholesterol and lipids (Beyond the Basics)".)

Statins are the most common medications used to lower cholesterol levels. Other drugs may be used as well (table 1).
                  ''',
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: '',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}
