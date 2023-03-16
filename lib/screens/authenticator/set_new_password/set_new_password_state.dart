class SetNewPasswordState {
  final bool isLoading;

  SetNewPasswordState({
    this.isLoading = false,
  });
}

extension SetNewPasswordStateEx on SetNewPasswordState {
  SetNewPasswordState copyWith({
    bool? isLoading,
  }) =>
      SetNewPasswordState(
        isLoading: isLoading ?? this.isLoading,
      );
}
