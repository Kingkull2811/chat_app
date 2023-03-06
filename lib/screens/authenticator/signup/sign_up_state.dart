import 'package:equatable/equatable.dart';

class SignUpState extends Equatable {
//   final bool isEnable;
//
//   const SignUpState({this.isEnable = false});
//
  @override
  List<Object?> get props => [];
// }
//
// extension RegisterStateExtension on SignUpState {
//   SignUpState copyWith({
//     bool? isEnable,
//   }) =>
//       SignUpState(
//         isEnable: isEnable ?? this.isEnable,
//       );
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;

  SignUpFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SignUpFailure { error: $error }';
}
