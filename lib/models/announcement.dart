class Announcement {
  final String id;
  final String announcementt;
  final List<ImageData> images;
  final DateTime pdate;

  Announcement( {
    required this.pdate,
    required this.id,
    required this.announcementt,
    required this.images,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] ?? '',
      pdate: DateTime.parse(json['pdate']),
      announcementt: json['announcement'] ?? '',
      images: (json['images'] as List<dynamic>).map((imageJson) {
        return ImageData.fromJson(imageJson);
      }).toList(),
    );
  }
}

class ImageData {
  final String data;
  final String contentType;

  ImageData({required this.data, required this.contentType});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      data: json['data'] ?? '',
      contentType: json['contentType'] ?? '',
    );
  }
}
