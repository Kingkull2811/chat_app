import '../../../bloc/api_result_state.dart';
import '../../../network/model/message_content_model.dart';
import '../../../utilities/enum/api_error_result.dart';

class ChatRoomState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final List<MessageContentModel>? listMessage;

  ChatRoomState({
    this.isLoading = false,
    ApiError apiError = ApiError.noError,
    this.listMessage,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension ChatRoomStateExtension on ChatRoomState {
  ChatRoomState copyWith({
    bool? isLoading,
    ApiError? apiError,
    List<MessageContentModel>? listMessage,
  }) =>
      ChatRoomState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        listMessage: listMessage ?? this.listMessage,
      );
}
