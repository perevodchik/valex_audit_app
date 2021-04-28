import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:valex_agro_audit_app/All.dart';

class ModalCarouselNetwork extends StatefulWidget {
  final List<String> photos;
  ModalCarouselNetwork(this.photos);

  @override
  _ModalCarouselState createState() => _ModalCarouselState();
}

class _ModalCarouselState extends State<ModalCarouselNetwork> {
  int currentSlide = 0;
  List<String>? photos;

  @override
  void initState() {
    super.initState();
    photos = widget.photos;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 10,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: photos?.length ?? 0,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal:5, vertical: currentSlide == index ? 0 : 2),
                              child: Container(
                                  height: currentSlide == index ? 10 : 6,
                                  width: currentSlide == index ? 10 : 6,
                                  decoration: BoxDecoration(
                                    color: currentSlide == index ? Colors.white : Color.fromRGBO(181, 181, 181, 1),
                                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                  )
                              )
                          );
                        }
                    )
                )
              ]
          ),

          SizedBox(height: 10),
          CarouselSlider(
              options: CarouselOptions(
                  height: screenHeight * 0.7,
                  viewportFraction: 0.9,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: (photos?.length ?? 0) > 1,
                  onPageChanged: (int index, CarouselPageChangedReason pageChangedReason) {
                    setState(() {
                      currentSlide = index;
                    });
                  }
              ),
              items: (photos ?? []).map((f) {
                return Builder(
                    builder: (BuildContext context) {
                      return Center(
                          child: Container(
                              padding: EdgeInsets.all(1),
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  child: CachedNetworkImage(
                                      imageUrl: f,
                                      placeholder: (context, url) => CircularProgressIndicator().center(),
                                      errorWidget: (context, url, error) => Icon(Icons.error)
                                  )
                                  // Image.network(f)
                              )
                          )
                      );
                    }
                );
              }).toList()
          ),
          Center(
              child: AppElevatedButton(
                Text("close"),
                onPressed: () => Navigator.pop(context)
              )
          )
        ]
    );
  }
}