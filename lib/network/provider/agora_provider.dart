import 'dart:convert';

import 'package:chat_app/network/api/api_path.dart';
import 'package:chat_app/network/provider/provider_mixin.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

class AgoraProvider with ProviderMixin {
  Future<String> getToken({
    required String channelName,
    required String uid,
  }) async {
    String token = '';
    final String tokenUrl = join(
      ApiPath.agoraServerDomain,
      'rtc',
      channelName,
      'publisher/uid',
      uid,
    );
    final response = await dio.get(tokenUrl);

    if (response.statusCode == 200) {
      token = jsonDecode(response.data)['rtcToken'];
      return token;
    } else {
      debugPrint('Failed to fetch the token');
      return '';
    }
  }
}
