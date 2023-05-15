import 'package:chat_app/bloc/api_result_state.dart';
import 'package:chat_app/network/model/learning_result_info.dart';

import '../../../../utilities/enum/api_error_result.dart';

class EnterPointSubjectState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<LearningResultInfo>? listLearningInfo;

  EnterPointSubjectState({
    this.isLoading = true,
    ApiError apiError = ApiError.noError,
    this.listLearningInfo,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension EnterPointSubjectStateEx on EnterPointSubjectState {
  EnterPointSubjectState copyWith({
    ApiError? apiError,
    bool? isLoading,
    List<LearningResultInfo>? listLearningInfo,
  }) =>
      EnterPointSubjectState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listLearningInfo: listLearningInfo ?? this.listLearningInfo,
      );
}
