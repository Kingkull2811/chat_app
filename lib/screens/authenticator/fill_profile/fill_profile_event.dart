import 'package:equatable/equatable.dart';

abstract class FillProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FillInit extends FillProfileEvent {
  @override
  List<Object> get props => [];
}

class FillProfile extends FillProfileEvent {
  final Map<String, dynamic> userMap;

  FillProfile({required this.userMap});

  @override
  List<Object> get props => [userMap];
}
