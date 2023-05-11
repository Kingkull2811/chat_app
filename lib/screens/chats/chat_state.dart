import 'package:chat_app/bloc/api_result_state.dart';
import 'package:chat_app/network/model/user_from_firebase.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';

class ChatsState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final UserFirebaseData? userData;
  final List<UserFirebaseData>? listUser;

  ChatsState({
    this.isLoading = true,
    ApiError apiError = ApiError.noError,
    this.userData,
    this.listUser,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;
}

extension ChatsStateEx on ChatsState {
  ChatsState copyWith({
    bool? isLoading,
    ApiError? apiError,
    UserFirebaseData? userData,
    List<UserFirebaseData>? listUser,
  }) =>
      ChatsState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        userData: userData ?? this.userData,
        listUser: listUser ?? this.listUser,
      );
}

// class ChatInitState extends ChatsState {}
//
// class LoadingState extends ChatsState {}
//
// class ErrorState extends ChatsState {
//   final bool isNoInternet;
//
//   const ErrorState({this.isNoInternet = false});
//
//   @override
//   List<Object> get props => [isNoInternet];
// }
//
// class SuccessState extends ChatsState {
//   const SuccessState({
//     required this.userData,
//     this.listUser,
//   });
//
//   @override
//   List<Object> get props => [userData, listUser ?? []];
// }
