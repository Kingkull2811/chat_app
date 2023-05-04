import '../../bloc/api_result_state.dart';
import '../../network/model/news_model.dart';
import '../../utilities/enum/api_error_result.dart';

class NewsState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final bool isUserRole;
  final List<NewsModel>? listNews;

  NewsState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.isUserRole = false,
    this.listNews,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension NewsStateExtension on NewsState {
  NewsState copyWith({
    ApiError? apiError,
    bool? isLoading,
    bool? isUserRole,
    List<NewsModel>? listNews,
  }) =>
      NewsState(
        apiError: apiError ?? this.apiError,
        isLoading: isLoading ?? this.isLoading,
        isUserRole: isUserRole ?? this.isUserRole,
        listNews: listNews ?? this.listNews,
      );
}
