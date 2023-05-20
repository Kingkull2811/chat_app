import 'package:equatable/equatable.dart';

abstract class TranscriptEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetTranscriptByUserID extends TranscriptEvent {}

class GetLearningResult extends TranscriptEvent {
  final int studentId, term;
  final String year;

  GetLearningResult({
    required this.studentId,
    required this.term,
    required this.year,
  });
}
