import 'dart:io';

import 'package:chat_app/network/provider/news_provider.dart';
import 'package:chat_app/network/response/base_get_response.dart';

class GetListNewsRepository {
  final NewsProvider _newsProvider = NewsProvider();

  Future<Object?> getImageUrl({required File image}) async =>
      await _newsProvider.getImageUrl(image: image);

  Future<BaseGetResponse> getListNews() async {
    return await _newsProvider.getListNews();
  }
}
