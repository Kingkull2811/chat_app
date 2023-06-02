import 'package:equatable/equatable.dart';

abstract class TranscriptManagementEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitTranscriptEvent extends TranscriptManagementEvent {}

class SearchEvent extends TranscriptManagementEvent {
  final String? searchQuery;
  final String? schoolYear;
  final int? classId;

  SearchEvent({this.searchQuery, this.schoolYear, this.classId});

  @override
  List<Object?> get props => [searchQuery, schoolYear, classId];
}

class AddTranscriptEvent extends TranscriptManagementEvent {
  final Map<String, dynamic> data;

  AddTranscriptEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class EditTranscriptEvent extends TranscriptManagementEvent {
  final int subjectId;
  final Map<String, dynamic> data;

  EditTranscriptEvent({required this.subjectId, required this.data});
  @override
  List<Object?> get props => [subjectId, data];
}

class DeleteTranscriptEvent extends TranscriptManagementEvent {
  final int subjectId;

  DeleteTranscriptEvent(this.subjectId);

  @override
  List<Object?> get props => [subjectId];
}
