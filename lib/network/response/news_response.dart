import 'package:chat_app/network/model/news_model.dart';
import 'package:chat_app/network/response/base_get_response.dart';
import 'package:chat_app/utilities/utils.dart';

class NewsResponse extends BaseGetResponse {
  final List<NewsModel>? listNews;

  NewsResponse({
    this.listNews,
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

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      listNews: isNullOrEmpty(json['content'])
          ? []
          : List.generate(
              json['content'].length,
              (index) => NewsModel.fromJson(json['content'][index]),
            ),
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalRecord: json['totalRecord'],
      status: json['status'],
      error: json['error'],
    );
  }

  @override
  String toString() {
    return 'GetListNewResponse{listNews: $listNews}';
  }
}
