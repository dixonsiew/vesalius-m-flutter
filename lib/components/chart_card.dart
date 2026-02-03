import 'package:flutter/material.dart';

class ChartCard extends StatelessWidget {
  
  final Widget child;

  const ChartCard({
    Key? key, 
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(236, 238, 255, 0.8),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}