import 'package:book_library_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class PageTileBooks extends StatelessWidget {
  final Map<String, dynamic> data;
  var color;
  PageTileBooks({
    super.key,
    required this.data,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    String imgName = data['link'][1]['href'].toString();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 220,
        width: MediaQuery.of(context).size.width / 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'].toString(),
                    style: medText,
                    maxLines: 2,
                  ),
                  Text(
                    "By ${data['author']['name'].toString()}",
                    style: medTextItalic,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${data['summary'].toString().substring(0, 100)}...",
                    style: smText,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            Container(
              width: 100,
              height: 180,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imgName),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
