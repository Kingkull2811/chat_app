import 'package:equatable/equatable.dart';

abstract class ClassManagementEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitEvent extends ClassManagementEvent {}

class AddClassEvent extends ClassManagementEvent {}

class AddSuccess extends ClassManagementEvent {}

class AddFailure extends ClassManagementEvent {}
