import 'dart:developer';
import 'dart:io';

import 'package:chat_app/network/api/api_path.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:chat_app/network/response/base_get_response.dart';
import 'package:chat_app/network/response/get_list_news_response.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart'; // import 'package:mime/mime.dart';
import 'package:path/path.dart';

import '../response/get_image_url.dart';

class NewsProvider with ProviderMixin {
  Future<Object?> getImageUrl({required File image}) async {
    log('image $image');

    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final data = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          image.path,
          filename: basename(image.path),
          contentType: MediaType('image', 'jpeg'),
        )
        // MediaType.parse("${lookupMimeType(basename(image.path))}")),
      });

      final response = await dio.post(
        ApiPath.upLoadImageToCloud,
        data: data,
        options: await defaultOptions(url: ApiPath.upLoadImageToCloud),
      );

      log('ressonse: ${response.toString()}');
      return GetImageUrl.fromJson(response.data);
    } catch (error, stacktrace) {
      log(error.toString());
      // return errorGetResponse(error, stacktrace, ApiPath.upLoadImageToCloud);
    }
  }

  Future<BaseGetResponse> getListNews() async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.get(
        ApiPath.listNews,
        // queryParameters: request.toJson(),
        options: await defaultOptions(url: ApiPath.listNews),
      );
      return GetListNewResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.listNews);
    }
  }

  Future<BaseGetResponse> postNews({
    String? content,
    String? mediaUrl,
    String? title,
  }) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      // final data = {
      //   "content": "$content",
      //   "mediaUrl": "$mediaUrl",
      //   "title": "$title",
      //   "typeMedia" = '0'
      // };

      final response = await dio.post(
        ApiPath.listNews,
        // data: data,
        options: await defaultOptions(url: ApiPath.listNews),
      );
      return GetListNewResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.listNews);
    }
  }
}
