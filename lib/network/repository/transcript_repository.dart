import 'package:chat_app/network/provider/transcript_provider.dart';

import '../response/base_response.dart';

class TranscriptRepository {
  final _transcriptProvider = TranscriptProvider();

  Future<Object> updatePoint({
    required int id,
    required Map<String, dynamic> data,
  }) async =>
      await _transcriptProvider.updatePoint(id: id, data: data);

  Future<BaseResponse> mathGPA({
    required int studentID,
    required String schoolYear,
  }) async =>
      await _transcriptProvider.mathGPA(
          studentID: studentID, schoolYear: schoolYear);
}
