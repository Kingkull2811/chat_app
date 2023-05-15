import '../provider/learning_result_provider.dart';

class LearningResultInfoRepository {
  final _learningResultProvider = LearningResultProvider();

  Future<Object> getListSubjectPoint({
    required Map<String, dynamic> queryParameters,
  }) async =>
      await _learningResultProvider.getListSubjectPoint(
        queryParameters: queryParameters,
      );
}
