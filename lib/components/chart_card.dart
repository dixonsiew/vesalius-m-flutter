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
      child: Material(
        elevation: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(133, 133, 133, 0.29),
                offset: Offset(3, 3),
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ]
          ),
          child: child,
        ),
      ),
    );
  }
}