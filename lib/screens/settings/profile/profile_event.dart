import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUserInfo extends ProfileEvent {}

class EditProfile extends ProfileEvent {}
