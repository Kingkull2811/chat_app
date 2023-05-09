import 'package:equatable/equatable.dart';

abstract class ClassInfoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClassInfoInit extends ClassInfoEvent {
  @override
  List<Object?> get props => [];
// final int? classId;
// const ClassInfoInit({this.classId});
}

class AddClassEvent extends ClassInfoEvent {
  final Map<String, dynamic> data;

  AddClassEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class EditClassEvent extends ClassInfoEvent {
  final int subjectId;
  final Map<String, dynamic> data;

  EditClassEvent({required this.subjectId, required this.data});

  @override
  List<Object?> get props => [subjectId, data];
}

class DeleteClassEvent extends ClassInfoEvent {
  final int classId;

  DeleteClassEvent(this.classId);

  @override
  List<Object?> get props => [classId];
}
