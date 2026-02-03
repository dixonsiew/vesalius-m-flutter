import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class FrontLayer extends StatelessWidget {

  const FrontLayer({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 18.0, bottom: 5.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
            child: Text(
              content,
              style: TextStyle(
                height: 1.5,
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        gradient: LinearGradient(
          colors: [Color.fromRGBO(0, 0, 0, 0.3), Color.fromRGBO(0, 0, 0, 0.3)],
        ),
        color: Colors.grey,
      ),
    );
  }
}

class BackgroundLayer extends StatelessWidget {

  const BackgroundLayer({
    required this.title,
    required this.content,
    required this.isBookmarked,
    required this.image,
  });

  final String title;
  final String content;
  final bool isBookmarked;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 18.0, bottom: 5.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Html(
            data: content,
            style: {
              'span': Style(
                color: Colors.transparent,
                fontSize: FontSize(16.0, units: 'pt'),
                fontWeight: FontWeight.bold,
              ),
              'p': Style(
                color: Colors.transparent,
                fontSize: FontSize(16.0, units: 'pt'),
                fontWeight: FontWeight.bold,
              ),
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        // gradient: LinearGradient(
        //   colors: [Color.fromRGBO(0, 0, 0, 0.3), Color.fromRGBO(0, 0, 0, 0.3)],
        // ),
        color: Colors.transparent,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(
            base64Decode(image),
          ),
        ),
      ),
    );
  }
}