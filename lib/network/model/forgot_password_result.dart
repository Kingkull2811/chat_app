class ForgotPasswordResult {
  final bool isSuccess;
  String? errors;

  ForgotPasswordResult({
    this.isSuccess =false,
    this.errors,
});

  @override
  String toString() {
    return 'ForgotPasswordResult{isSuccess: $isSuccess, error: $errors}';
  }
}
