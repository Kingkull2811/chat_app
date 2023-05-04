import 'package:equatable/equatable.dart';

abstract class AddStudentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends AddStudentEvent {}

class StudentAdd extends AddStudentEvent {}

class AddSuccess extends AddStudentEvent {}

class AddFailure extends AddStudentEvent {}
