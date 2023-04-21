class SignUpData {
  final String username;
  final String phone;
  final String fullName;
  final String password;
  final String confirmPassword;
  final List<String>? roles;
  final bool isFillProfileKey;

  SignUpData({
    required this.username,
    required this.phone,
    required this.fullName,
    required this.password,
    required this.confirmPassword,
    this.roles,
    this.isFillProfileKey = false,
  });
}
