import 'package:equatable/equatable.dart';

abstract class StudentsManagementEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitStudentsEvent extends StudentsManagementEvent {}

class AddStudentsEvent extends StudentsManagementEvent {
  final Map<String, dynamic> data;

  AddStudentsEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class EditStudentsEvent extends StudentsManagementEvent {
  final int studentID;
  final Map<String, dynamic> data;

  EditStudentsEvent({required this.studentID, required this.data});

  @override
  List<Object?> get props => [studentID, data];
}

class DeleteStudentsEvent extends StudentsManagementEvent {
  final int studentID;

  DeleteStudentsEvent(this.studentID);

  @override
  List<Object?> get props => [studentID];
}
