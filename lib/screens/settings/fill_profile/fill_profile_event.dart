import 'package:equatable/equatable.dart';

abstract class FillProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FillInit extends FillProfileEvent {}

class FillProfile extends FillProfileEvent {
  final int userId;
  final Map<String, dynamic> userData;

  FillProfile({required this.userId, required this.userData});
}
