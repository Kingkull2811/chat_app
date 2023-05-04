import 'package:chat_app/network/provider/news_provider.dart';
import 'package:chat_app/network/response/base_get_response.dart';

class NewsRepository {
  final NewsProvider _newsProvider = NewsProvider();

  // Future<Object?> getImageUrl({required File image}) async =>
  //     await _newsProvider.getImageUrl(image: image);

  Future<BaseGetResponse> getListNews() async {
    return await _newsProvider.getListNews();
  }

  Future<Object> postNews({
    String? title,
    String? content,
    String? mediaUrl,
    int? mediaType,
  }) async {
    final Object data = {
      "content": content,
      "mediaUrl": mediaUrl,
      "title": title,
      "typeMedia": mediaType
    };

    return await _newsProvider.postNews(data: data);
  }

  Future<Object> updateNews({
    required int newsId,
    String? title,
    String? content,
    String? mediaUrl,
    int? mediaType,
  }) async {
    final Object data = {
      "content": content,
      "mediaUrl": mediaUrl,
      "title": title,
      "typeMedia": mediaType
    };

    return _newsProvider.updateNews(newsId: newsId, data: data);
  }

  Future<Object> deleteNews({
    required int newsId,
  }) async {
    return await _newsProvider.deleteNews(newsId: newsId);
  }
}
