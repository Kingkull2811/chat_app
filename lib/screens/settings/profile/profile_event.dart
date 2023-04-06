import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DisplayLoading extends ProfileEvent {}

class EditProfile extends ProfileEvent {}
