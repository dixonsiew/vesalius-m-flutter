import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:vesalius_m_flutter/constants.dart';

class FrontLayer extends StatelessWidget {

  const FrontLayer({
    super.key, 
    required this.title,
    required this.content,
    required this.hospitalInformationId,
    required this.data,
    required this.isBookmarked,
    required this.onToggleBookmark,
  });

  final String title;
  final String content;
  final String hospitalInformationId;
  final Map data;
  final bool isBookmarked;
  final Future<void> Function(bool, String, Map) onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        gradient: LinearGradient(
          colors: [Color.fromRGBO(0, 0, 0, 0.3), Color.fromRGBO(0, 0, 0, 0.3)],
        ),
        color: Colors.grey,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 5.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Html(
          //   data: content,
          //   style: {
          //     'span': Style(
          //       color: Colors.white,
          //       fontSize: FontSize(16.0),
          //       fontWeight: FontWeight.bold,
          //     ),
          //     'p': Style(
          //       color: Colors.white,
          //       fontSize: FontSize(16.0),
          //       fontWeight: FontWeight.bold,
          //     ),
          //   },
          // ),
          HtmlWidget(
            content,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: IconButton(
                  onPressed: () {
                    onToggleBookmark(isBookmarked, hospitalInformationId, data);
                  },
                  icon: isBookmarked ? 
                  const Icon(
                    Icons.bookmark_sharp,
                    color: kPrimaryColor,
                  ) : 
                  const Icon(
                    Icons.bookmark_outline_sharp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundLayer extends StatelessWidget {

  const BackgroundLayer({
    super.key, 
    required this.title,
    required this.content,
    required this.isBookmarked,
    required this.image,
  });

  final String title;
  final String content;
  final bool isBookmarked;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        // gradient: LinearGradient(
        //   colors: [Color.fromRGBO(0, 0, 0, 0.3), Color.fromRGBO(0, 0, 0, 0.3)],
        // ),
        color: Colors.transparent,
        image: image == null ? null : DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(
            base64Decode(image!),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 5.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Html(
          //   data: content,
          //   style: {
          //     'span': Style(
          //       color: Colors.transparent,
          //       fontSize: FontSize(16.0),
          //       fontWeight: FontWeight.bold,
          //     ),
          //     'p': Style(
          //       color: Colors.transparent,
          //       fontSize: FontSize(16.0),
          //       fontWeight: FontWeight.bold,
          //     ),
          //   },
          // ),
          HtmlWidget(
            content,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
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
    );
  }
}