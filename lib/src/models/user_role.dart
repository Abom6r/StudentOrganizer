enum UserRole { student, tutor, both }

String userRoleToString(UserRole role) {
  switch (role) {
    case UserRole.student:
      return 'student';
    case UserRole.tutor:
      return 'tutor';
    case UserRole.both:
      return 'both';
  }
}

UserRole userRoleFromString(String value) {
  switch (value) {
    case 'tutor':
      return UserRole.tutor;
    case 'both':
      return UserRole.both;
    case 'student':
    default:
      return UserRole.student;
  }
}
