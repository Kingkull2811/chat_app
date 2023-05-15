import 'package:equatable/equatable.dart';

abstract class EnterPointSubjectEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitEvent extends EnterPointSubjectEvent {}

class GetListSubjectEvent extends EnterPointSubjectEvent {
  final int studentId;
  final int semester;
  final String schoolYear;

  GetListSubjectEvent({
    required this.studentId,
    required this.semester,
    required this.schoolYear,
  });
}

class EnterPointEvent extends EnterPointSubjectEvent {}
