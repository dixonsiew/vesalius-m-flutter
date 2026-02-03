import 'package:flutter/material.dart';

class DetailContent extends StatelessWidget {

  final String text;

  DetailContent({
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, top: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5.0,
            height: 5.0,
            margin: EdgeInsets.only(right: 15.0, top: 8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF4B4B4B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}