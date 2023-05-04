import 'package:chat_app/network/provider/class_provider.dart';

import '../response/base_get_response.dart';

class ClassRepository {
  final _classProvider = ClassProvider();

  Future<BaseGetResponse> getListClass() async =>
      await _classProvider.getListClass();
}
