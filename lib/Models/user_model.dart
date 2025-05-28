class UserModel {
  final String username;
  final String email;
  final String role;
  final String plan;
  final String goal;

  UserModel(
      {required this.username,
      required this.email,
      required this.role,
      required this.plan,
      required this.goal});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['user']['username'] ?? 'Sin nombre',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      plan: json['user']['plan'] ?? '',
      goal: json['goal']['goal'] ?? '',
    );
  }
}
