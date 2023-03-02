import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final bool isEnable;

  RegisterState({this.isEnable = false});

  @override
  List<Object?> get props => [];
}

extension RegisterStateExtension on RegisterState {
  RegisterState copyWith({
    bool? isEnable,
  }) =>
      RegisterState(
        isEnable: isEnable ?? this.isEnable,
      );
}
