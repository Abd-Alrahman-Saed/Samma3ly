enum UserRole {
  admin('Admin'),
  teacher('Teacher');

  final String value;
  const UserRole(this.value);

  static UserRole fromValue(String value) {
    return UserRole.values.firstWhere(
      (r) => r.value == value,
      orElse: () => UserRole.teacher,
    );
  }

  bool get isAdmin => this == UserRole.admin;
  bool get isTeacher => this == UserRole.teacher;
}
