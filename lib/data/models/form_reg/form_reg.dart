import 'package:flutter/services.dart';

class FormReg {
  FormReg({
    this.name,
    this.required,
    this.hintText,
    this.suffixIcon,
    this.obscure,
    this.validate,
    this.keyboardType,
    this.emailValidate,
    this.phoneValidate,
    this.imgValidate,
    this.inputFormat,
  });

  final dynamic name;
  final dynamic required;
  final dynamic hintText;
  final dynamic suffixIcon;
  final dynamic obscure;
  final dynamic validate;
  final dynamic keyboardType;
  final dynamic emailValidate;
  final dynamic phoneValidate;
  final dynamic imgValidate;
  final List<TextInputFormatter>? inputFormat;
}
