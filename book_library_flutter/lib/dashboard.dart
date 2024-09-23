import 'dart:convert';

import 'package:book_library_flutter/constants.dart';
import 'package:book_library_flutter/pages/page_tile_books.dart';
import 'package:book_library_flutter/pages/tiles_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:developer';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

int activeIndex = 0;
var resp = {};
final dio = Dio();
List<dynamic> list = [];
List<dynamic> catList = [];

class _DashboardState extends State<Dashboard> {
  late Map<String, dynamic> listData;
  List colors = [
    Colors.lightGreen.shade100,
    Colors.red.shade100,
    Colors.grey.shade100,
  ];
  @override
  void initState() {
    log("init");
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      callService();
    });
    super.initState();
  }

  callService() async {
    log("callService");
    final response = await dio
        .get('https://catalog.feedbooks.com/publicdomain/browse/top.atom');
    final myTransformer = Xml2Json();
    // Parse a simple XML string
    myTransformer.parse(response.toString());
    var json = myTransformer.toOpenRally();
    // log(json);
    setState(() {
      log("in setSate");
      resp = jsonDecode(json);
      if (resp.isNotEmpty) {
        list = resp['feed']['entry'];
        List<dynamic> catListOrg = resp['feed']['link'];
        List<dynamic> loc = [];
        for (int i = 0; i < catListOrg.length; i++) {
          if (catListOrg[i]['href'].toString().contains('cat=FB')) {
            loc.add(catListOrg[i]);
          }
        }
        catList = loc;
        print(catListOrg);
      } else {
        log("no resp");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Feedboo",
              style: hdrText,
            ),
            Transform.flip(
              flipX: true,
              child: Text(
                "k",
                style: hdrText,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            if (list.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Stack(children: [
                      PageView.builder(
                        onPageChanged: (value) {
                          setState(() {
                            activeIndex = value;
                          });
                        },
                        scrollDirection: Axis.horizontal,
                        itemCount: (list.length < 3) ? list.length : 3,
                        itemBuilder: (context, index) {
                          log("in itembuilder -- $index");
                          if (list.isNotEmpty) {
                            return PageTileBooks(
                              data: list[index] as Map<String, dynamic>,
                              color: colors[index],
                            );
                          } else {
                            return const Text("Loading..");
                          }
                        },
                      ),
                      Positioned(
                        top: 190,
                        left: MediaQuery.of(context).size.width / 1.35,
                        child: AnimatedSmoothIndicator(
                          activeIndex: activeIndex,
                          count: 3,
                          effect: const ExpandingDotsEffect(
                            dotWidth: 8,
                            dotHeight: 8,
                            activeDotColor: Colors.black87,
                            dotColor: Colors.black26,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            //genres tile
            if (list.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 90,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: catList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black12,
                                  //image: DecorationImage(image: AssetImage(''))
                                ),
                                child:
                                    const Icon(Icons.bookmark_outline_rounded),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 80,
                                height: 40,
                                child: Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    catList[index]['title'].toString(),
                                    style: smText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            //most popular books
            if (list.isNotEmpty)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Most Popular Books",
                        style: medText,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      height: 240,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            (list.length - 3) < 10 ? list.length - 3 : 10,
                        itemBuilder: (context, index) {
                          if (list.isNotEmpty) {
                            return TilesPage(
                                data: list[index + 3] as Map<String, dynamic>,
                                isLast: (list.length - 3) < 10
                                    ? list.length - 3 == index - 1
                                        ? true
                                        : false
                                    : index == 9
                                        ? true
                                        : false);
                          } else {
                            return const Text("Loading..");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
