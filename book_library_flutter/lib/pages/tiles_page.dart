import 'package:book_library_flutter/constants.dart';
import 'package:flutter/material.dart';

class TilesPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isLast;
  const TilesPage({
    super.key,
    required this.data,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    String imgName = data['link'][1]['href'].toString();
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: SizedBox(
        width: isLast ? 180 : 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 140,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imgName),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    "By ${data['author']['name'].toString()}",
                    style: medTextItalic,
                    maxLines: 2,
                  ),
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                Text(
                  "Free",
                  style: font10Text,
                  maxLines: 1,
                ),
              ],
            ),
            if (isLast)
              const SizedBox(
                width: 20,
              ),
            if (isLast)
              Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade300,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
