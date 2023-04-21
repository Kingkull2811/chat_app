import 'package:equatable/equatable.dart';

abstract class FillProfileEvent extends Equatable {
  const FillProfileEvent();

  @override
  List<Object> get props => [];
}

class GetUserInfoEvent extends FillProfileEvent {
  final int userId;

  const GetUserInfoEvent(this.userId);
}

class FillEvent extends FillProfileEvent {}
