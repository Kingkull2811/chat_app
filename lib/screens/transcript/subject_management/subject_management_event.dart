import 'package:equatable/equatable.dart';

abstract class SubjectManagementEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitSubjectEvent extends SubjectManagementEvent {}

class AddSubjectEvent extends SubjectManagementEvent {
  final Map<String, dynamic> data;

  AddSubjectEvent({required this.data});
}

class EditSubjectEvent extends SubjectManagementEvent {
  final int subjectId;
  final Map<String, dynamic> data;

  EditSubjectEvent({required this.subjectId, required this.data});
}

class DeleteSubjectEvent extends SubjectManagementEvent {
  final int subjectId;

  DeleteSubjectEvent(this.subjectId);
}
