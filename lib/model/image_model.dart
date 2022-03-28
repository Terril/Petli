class ImageModel {
  int? albumId;
  int id = 0;
  String title = "";
  String url = "";
  String thumbnailUrl = "";

  ImageModel(
      {this.albumId,
      required this.id,
      required this.title,
      required this.url,
      required this.thumbnailUrl});

  ImageModel.fromJson(dynamic json) {
    albumId = json['albumId'] as int;
    id = json['id'] as int;
    title = json['title'] as String ?? "";
    url = json['url'] as String;
    thumbnailUrl = json['thumbnailUrl'] as String ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['albumId'] = albumId;
    data['id'] = id;
    data['title'] = title;
    data['url'] = url;
    data['thumbnailUrl'] = thumbnailUrl;
    return data;
  }
}
