import 'package:chat_app/network/model/news_model.dart';
import 'package:chat_app/network/response/base_get_response.dart';

class GetListNewResponse extends BaseGetResponse {
  final List<NewsModel>? listNews;

  GetListNewResponse({
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

  factory GetListNewResponse.fromJson(Map<String, dynamic> json) {
    // var contentList = json['content'] ?? [];
    // List<NewsModel> posts =
    //     contentList.map((post) => NewsModel.fromJson(post)).toList();
    return GetListNewResponse(
      listNews: json['content'] == null
          ? []
          : List.generate(
              json['content'].lenght,
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
