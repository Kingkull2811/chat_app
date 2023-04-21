import 'base_get_response.dart';

class GetImageUrl extends BaseGetResponse {
  final String? imageUrl;

  GetImageUrl({
    this.imageUrl,
    int? pageNumber,
    int? pageSize,
    int? totalRecord,
    int? status,
    String? error,
  }) : super(
          pageNumber: pageNumber,
          pageSize: pageSize,
          totalRecord: totalRecord,
          status: status,
          error: error,
        );

  factory GetImageUrl.fromJson(Map<String, dynamic> json) => GetImageUrl(
        imageUrl: json[''],
        pageNumber: json['pageNumber'],
        pageSize: json['pageSize'],
        totalRecord: json['totalRecord'],
        status: json['status'],
        error: json['error'],
      );
}
