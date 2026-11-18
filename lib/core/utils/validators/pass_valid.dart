class PasswordValidator {
  PasswordValidator._();

  static String? validate(String value) {
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return 'Password must contain at least one special character (!@#\$&*~)';
    }
    return null;
  }
}

class EasyPasswordValidator {
  EasyPasswordValidator._();

  static String? validate(String value) {
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }
}

class PhoneNumberValidator {
  PhoneNumberValidator._();

  static String? validate(String value) {
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter a valid number';
    }
    return null;
  }
}

class NumberValidator {
  NumberValidator._();

  static String? validate(String value) {
    if (!RegExp(r'^\d*\.?\d+$').hasMatch(value)) {
      return 'Please enter a valid number (integer or decimal)';
    }
    return null;
  }
}

class RequiredValidator {
  RequiredValidator._();

  static String? validate(String value) {
    if (value.isEmpty) {
      return 'Field required';
    }
    return null;
  }
}
