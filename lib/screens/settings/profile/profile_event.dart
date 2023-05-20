import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUserInfo extends ProfileEvent {
  final int userID;

  GetUserInfo(this.userID);
}

class EditProfile extends ProfileEvent {}
