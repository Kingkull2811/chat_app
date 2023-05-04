import 'package:equatable/equatable.dart';

import '../../network/model/user_info_model.dart';

abstract class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object> get props => [];
}

class ChatInitState extends ChatsState {}

class LoadingState extends ChatsState {}

class ErrorState extends ChatsState {
  final bool isNoInternet;

  const ErrorState({this.isNoInternet = false});
}

class SuccessState extends ChatsState {
  final UserInfoModel? userData;
  final List<UserInfoModel>? listUser;

  const SuccessState({
    this.userData,
    this.listUser,
  });
}
