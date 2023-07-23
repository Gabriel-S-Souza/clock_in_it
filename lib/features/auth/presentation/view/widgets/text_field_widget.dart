import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscure;
  final TextInputType? textInputType;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;
  final void Function(bool)? onFocusChange;
  final bool? enabled;
  final bool readOnly;

  const TextFieldWidget({
    Key? key,
    this.onChanged,
    this.validator,
    this.hint,
    this.prefix,
    this.suffix,
    this.obscure = false,
    this.readOnly = false,
    this.textInputType,
    this.enabled,
    this.controller,
    this.onFocusChange,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) => Focus(
        onFocusChange: widget.onFocusChange,
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.obscure,
          keyboardType: widget.textInputType,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          validator: widget.validator,
          autofocus: false,
          onFieldSubmitted: (value) {
            if (value.isNotEmpty) {
              widget.onSubmitted?.call(value);
            }
          },
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefix,
            suffixIcon: widget.suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          textAlignVertical: TextAlignVertical.center,
        ),
      );
}
