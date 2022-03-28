import 'dart:convert';

import 'image_model.dart';

List<ImageModel> dataFromJson(String str) {
  var jsonData = jsonDecode(str) as List;
  List<ImageModel> modelObj = jsonData.map((imageJson) => ImageModel.fromJson(imageJson)).toList();
  return modelObj;
}