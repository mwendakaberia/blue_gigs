import 'package:email_validator/email_validator.dart';

class validation {
  static emailValidation(var val) {
    if (val == null || val.isEmpty) {
      return "Email can't be null";
    } else if (!EmailValidator.validate(val, true)) {
      return "The email is invalid";
    } else {
      return null;
    }
  }

  static userNameValidation(var val,message) {
    if (val == null || val.isEmpty) {
      return message;
    } else {
      return null;
    }
  }

  static userPhoneValidation(var val,message) {
    if (val == null || val.isEmpty) {
      return message;
    } else {
      return null;
    }
  }

  static passwordValidation(var val) {
    if (val == null || val.isEmpty) {
      return "Password can't be empty";
    } else if (val.length < 6) {
      return "Password too short";
    } else {
      return null;
    }
  }

  static confirmPassword(var val1, val2) {
    if (val1 == null || val1.isEmpty) {
      return "Please confirm your password";
    } else if (!(val2 == null || val2.isEmpty)) {
      if(!(val1.compareTo(val2)==0)){
        return "Password don't match";
      }else{
        return null;
      }
    } else {
      return null;
    }
  }

  static userGenderValidation(var val) {
    if (val == "Please select Gender") {
      return "Please select Gender";
    } else {
      return null;
    }
  }

  static upload(var val,message,previous_data) {
    if (val == null || val.isEmpty && (previous_data==null || previous_data.isEmpty)) {
      return message;
    } else {
      return null;
    }
  }
}
