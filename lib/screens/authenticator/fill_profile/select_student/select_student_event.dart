import 'package:equatable/equatable.dart';

class SelectStudentEvent extends Equatable {
  final String studentSSID;

  const SelectStudentEvent(this.studentSSID);

  @override
  List<Object?> get props => [studentSSID];
}
