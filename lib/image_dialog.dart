import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  String imageUrl = "";

  ImageDialog(String url, {Key? key}) : super(key: key) {
    imageUrl = url;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
          image:
              DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.fill)),
    ));
  }
}
