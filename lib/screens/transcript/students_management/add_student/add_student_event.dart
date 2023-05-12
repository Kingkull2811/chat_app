import 'package:equatable/equatable.dart';

abstract class AddStudentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends AddStudentEvent {}

class AddStudentsEvent extends AddStudentEvent {
  final Map<String, dynamic> data;

  AddStudentsEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class EditStudentsEvent extends AddStudentEvent {
  final int studentID;
  final Map<String, dynamic> data;

  EditStudentsEvent({required this.studentID, required this.data});

  @override
  List<Object?> get props => [studentID, data];
}

class DeleteStudentsEvent extends AddStudentEvent {
  final int studentID;

  DeleteStudentsEvent(this.studentID);

  @override
  List<Object?> get props => [studentID];
}
