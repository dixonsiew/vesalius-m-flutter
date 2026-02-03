import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';

class UnderpassView extends StatelessWidget {

  final String data;

  const UnderpassView({
    super.key,
    required this.data,
  });

  String getImage() {
    String s = 'macalister-underpass.jpg';
    if (data.contains("Peel")) {
      s = 'peel-underpass.jpg';
    }

    return s;
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: data,
      body: Center(
        child: Image.asset(
          'images/imgs/${getImage()}',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}