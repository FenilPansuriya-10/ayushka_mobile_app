// ignore_for_file: must_be_immutable

import 'package:cattle_app/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    this.shape,
    this.inputFormatters,
    this.padding,
    this.variant,
    this.fontStyle,
    this.alignment,
    this.width,
    this.margin,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.isObscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    required this.labelText,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.validator,
    this.enabled,
    this.onChanged,
    this.globalKey,
    this.onTap,
  });

  TextFormFieldShape? shape;

  TextFormFieldPadding? padding;

  TextFormFieldVariant? variant;

  TextFormFieldFontStyle? fontStyle;

  Alignment? alignment;

  double? width;

  void Function()? onTap;

  EdgeInsetsGeometry? margin;

  TextEditingController? controller;
  List<TextInputFormatter>? inputFormatters;

  FocusNode? focusNode;

  bool? autofocus;

  bool? isObscureText;

  TextInputAction? textInputAction;

  TextInputType? textInputType;

  int? maxLines;

  String? hintText;
  String labelText;

  Widget? prefix;

  BoxConstraints? prefixConstraints;

  Widget? suffix;

  BoxConstraints? suffixConstraints;

  FormFieldValidator<String>? validator;

  bool? enabled;

  void Function(String)? onChanged;

  GlobalKey<FormState>? globalKey;

  @override
  Widget build(BuildContext context) {
    return alignment != null ? Align(alignment: alignment ?? Alignment.center, child: _buildTextFormFieldWidget()) : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Container(
        width: width ?? double.maxFinite,
        margin: margin,
        child: Form(
          key: globalKey,
          child: TextFormField(
            inputFormatters: inputFormatters,
            onTap: onTap,
            controller: controller,
            focusNode: focusNode,
            autofocus: autofocus ?? false,
            style: _setFontStyle(),
            obscureText: isObscureText ?? false,
            textInputAction: textInputAction,
            keyboardType: textInputType,
            maxLines: maxLines ?? 1,
            decoration: _buildDecoration(),
            validator: validator,
            enabled: enabled,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      hintText: hintText ?? "",
      hintStyle: _setFontStyle(),
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black54),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      filled: _setFilled(),
      isDense: true,
      contentPadding: _setPadding(),
    );
  }

  _setFontStyle() {
    switch (fontStyle) {
      default:
        return TextStyle(color: ColorConstant.blueGray9007f, fontSize: getFontSize(20), fontFamily: 'Outfit', fontWeight: FontWeight.w500);
    }
  }

  _setOutlineBorderRadius() {
    switch (shape) {
      default:
        return BorderRadius.circular(getHorizontalSize(10.00));
    }
  }

  _setBorderStyle() {
    switch (variant) {
      case TextFormFieldVariant.None:
        return InputBorder.none;
      default:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(color: ColorConstant.blueGray9007f, width: 2),
        );
    }
  }

  _setFilled() {
    switch (variant) {
      case TextFormFieldVariant.OutlineBluegray9007f:
        return false;
      case TextFormFieldVariant.None:
        return false;
      default:
        return false;
    }
  }

  _setPadding() {
    switch (padding) {
      case TextFormFieldPadding.PaddingT26_1:
        return getPadding(left: 17, top: 18, bottom: 18);
      default:
        return getPadding(left: 17, top: 18, right: 17, bottom: 18);
    }
  }
}

enum TextFormFieldShape { RoundedBorder30 }

enum TextFormFieldPadding { PaddingT26, PaddingT26_1 }

enum TextFormFieldVariant { None, OutlineBluegray9007f }

enum TextFormFieldFontStyle { OutfitMedium20 }

class CustomTextField extends StatelessWidget {
  CustomTextField({
    this.shape,
    this.inputFormatters,
    this.padding,
    this.variant,
    this.fontStyle,
    this.alignment,
    this.width,
    this.margin,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.isObscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    required this.labelText,
    required this.image,
    required this.height,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.validator,
    this.enabled,
    this.onChanged,
    this.globalKey,
    this.onTap,
  });

  TextFormFieldShape? shape;

  TextFormFieldPadding? padding;

  TextFormFieldVariant? variant;

  TextFormFieldFontStyle? fontStyle;

  Alignment? alignment;

  double? width;

  void Function()? onTap;

  EdgeInsetsGeometry? margin;

  TextEditingController? controller;
  List<TextInputFormatter>? inputFormatters;

  FocusNode? focusNode;

  bool? autofocus;

  bool? isObscureText;

  TextInputAction? textInputAction;

  TextInputType? textInputType;

  int? maxLines;

  String? hintText;
  String labelText;
  String image;
  double height;

  Widget? prefix;

  BoxConstraints? prefixConstraints;

  Widget? suffix;

  BoxConstraints? suffixConstraints;

  FormFieldValidator<String>? validator;

  bool? enabled;

  void Function(String)? onChanged;

  GlobalKey<FormState>? globalKey;

  @override
  Widget build(BuildContext context) {
    return alignment != null ? Align(alignment: alignment ?? Alignment.center, child: _buildTextFormFieldWidget()) : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Container(
        width: width ?? double.maxFinite,
        margin: margin,
        decoration: BoxDecoration(
          border: Border.all(color: ColorConstant.blueGray9007f, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image(image: AssetImage(image), height: height),
            ),
            Expanded(
              child: Form(
                key: globalKey,
                child: TextFormField(
                  inputFormatters: inputFormatters,
                  onTap: onTap,
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: autofocus ?? false,
                  style: _setFontStyle(),
                  obscureText: isObscureText ?? false,
                  textInputAction: textInputAction,
                  keyboardType: textInputType,
                  maxLines: maxLines ?? 1,
                  decoration: _buildDecoration(),
                  validator: validator,
                  enabled: enabled,
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      hintText: hintText ?? "",
      hintStyle: _setFontStyle(),
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black54),
      border: InputBorder.none,
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      filled: _setFilled(),
      isDense: true,
      contentPadding: _setPadding(),
    );
  }

  _setFontStyle() {
    switch (fontStyle) {
      default:
        return TextStyle(color: ColorConstant.blueGray9007f, fontSize: getFontSize(20), fontFamily: 'Outfit', fontWeight: FontWeight.w500);
    }
  }

  _setFilled() {
    switch (variant) {
      case TextFormFieldVariant.OutlineBluegray9007f:
        return false;
      case TextFormFieldVariant.None:
        return false;
      default:
        return false;
    }
  }

  _setPadding() {
    switch (padding) {
      case TextFormFieldPadding.PaddingT26_1:
        return getPadding(left: 17, top: 18, bottom: 18);
      default:
        return getPadding(left: 17, top: 18, right: 17, bottom: 18);
    }
  }
}
