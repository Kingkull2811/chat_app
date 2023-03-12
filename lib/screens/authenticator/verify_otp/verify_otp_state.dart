class VerifyOtpState {
  final bool isLoading;

  VerifyOtpState({
    this.isLoading = false,
  });
}

extension VerifyOtpStateEx on VerifyOtpState {
  VerifyOtpState copyWith({
    bool? isLoading,
  }) =>
      VerifyOtpState(
        isLoading: isLoading ?? this.isLoading,
      );
}
