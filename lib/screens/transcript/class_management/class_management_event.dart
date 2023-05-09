import 'package:equatable/equatable.dart';

abstract class ClassManagementEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitClassEvent extends ClassManagementEvent {}

class AddClassEvent extends ClassManagementEvent {}

class EditClassEvent extends ClassManagementEvent {}

class DeleteClassEvent extends ClassManagementEvent {
  final int classId;

  DeleteClassEvent({required this.classId});
  @override
  List<Object?> get props => [classId];
}
