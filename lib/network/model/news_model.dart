import 'package:chat_app/utilities/enum/meida_type.dart';

import '../../utilities/utils.dart';

class NewsModel {
  final int? id;
  final String? title;
  final String? content;
  final String? mediaUrl;
  final MediaType? typeMedia;
  final int? createdId;
  final String? createdName;
  final String? createdImage;
  final DateTime? createdAt;

  NewsModel({
    this.id,
    this.title,
    this.content,
    this.mediaUrl,
    this.typeMedia,
    this.createdId,
    this.createdName,
    this.createdImage,
    this.createdAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      mediaUrl: json['mediaUrl'],
      typeMedia: getMediaType(json['typeMedia'] as int? ?? 1),
      createdId: json['createdId'] as int? ?? 0,
      createdName: json['createdName'] as String? ?? '',
      createdImage: json['createdFile'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String? ?? ''),
    );
  }

  @override
  String toString() {
    return 'NewsModel{id: $id, title: $title, content: $content, mediaUrl: $mediaUrl, typeMedia: $typeMedia, createdId: $createdId, createdName: $createdName, createdImage: $createdImage, createdAt: $createdAt}';
  }
}
