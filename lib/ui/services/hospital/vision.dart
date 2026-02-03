import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';

class Vision extends StatefulWidget {

  const Vision({super.key});

  @override
  State<Vision> createState() => _VisionState();
}

class _VisionState extends State<Vision> {

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
          child: Scrollbar(
            controller: scr,
            child: ListView(
              controller: scr,
              shrinkWrap: true,
              children: [
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Image.asset(
                    'images/imgs/vision1.png',
                    width: 343.0,
                    height: 242.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Image.asset(
                    'images/imgs/vision2.png',
                    width: 343.0,
                    height: 242.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Image.asset(
                    'images/imgs/vision3.png',
                    width: 343.0,
                    height: 242.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppElevatedButton(
              text: 'Read More',
              onPressed: () {
                
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Vision, Mission & Values',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}