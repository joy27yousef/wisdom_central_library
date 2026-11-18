enum UserRole { admin, user }

UserRole parseRole(String? role) {
  switch (role?.toLowerCase()) {
    case 'admin':
      return UserRole.admin;
    case 'user':
      return UserRole.user;

    default:
      return UserRole.user;
  }
}
