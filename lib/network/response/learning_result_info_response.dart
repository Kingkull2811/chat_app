import 'package:chat_app/network/model/learning_result_info.dart';

class LearningResultInfoResponse {
  final List<LearningResultInfo>? listResult;

  LearningResultInfoResponse({this.listResult});

  factory LearningResultInfoResponse.fromJson(List<dynamic> json) {
    return LearningResultInfoResponse(
        listResult: json.map((e) => LearningResultInfo.fromJson(e)).toList());
  }

  @override
  String toString() {
    return 'LearningResultInfoResponse{listResult: $listResult}';
  }
}
