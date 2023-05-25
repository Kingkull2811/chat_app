import 'package:equatable/equatable.dart';

import '../../../../network/model/learning_result_info.dart';

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

class UpdatePointEvent extends EnterPointSubjectEvent {
  final List<LearningResultInfo> listResult;
  final String schoolYear;
  final int studentID;
  UpdatePointEvent({
    required this.listResult,
    required this.schoolYear,
    required this.studentID,
  });
}
