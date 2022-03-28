import 'package:http/http.dart' as http;

import '../model/convert_model.dart';
import '../model/image_model.dart';

String url = 'https://jsonplaceholder.typicode.com/photos?_offset=0&_limit=';

Future<List<ImageModel>> getData(num skipCount) async {
  final response = await http.get(Uri.parse('$url + $skipCount'));
  return dataFromJson(response.body);
}