import 'package:chat_app/network/model/news_model.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/network/response/base_get_response.dart';
import 'package:chat_app/network/response/news_response.dart';
import 'package:path/path.dart';

import '../api/api_path.dart';

class NewsProvider with ProviderMixin {
  Future<BaseGetResponse> getListNews() async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.get(
        ApiPath.listNews,
        options: await defaultOptions(url: ApiPath.listNews),
      );

      return NewsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.listNews);
    }
  }

  Future<Object> postNews({required Object data}) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.post(
        ApiPath.listNews,
        data: data,
        options: await defaultOptions(
          url: ApiPath.listNews,
        ),
      );
      return NewsModel.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.listNews);
    }
  }

  Future<Object> updateNews({
    required int newsId,
    required Object data,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    final String apiUpdateNews = join(ApiPath.listNews, newsId.toString());

    try {
      final response = await dio.put(
        apiUpdateNews,
        data: data,
        options: await defaultOptions(url: apiUpdateNews),
      );
      return NewsModel.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, apiUpdateNews);
    }
  }

  Future<Object> deleteNews({
    required int newsId,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }

    final String apiDeleteNews = join(ApiPath.listNews, newsId.toString());
    try {
      return await dio.delete(
        apiDeleteNews,
        options: await defaultOptions(url: apiDeleteNews),
      );
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, apiDeleteNews);
    }
  }
}
