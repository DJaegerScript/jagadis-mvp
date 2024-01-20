import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldComponent extends StatelessWidget {
  const TextFieldComponent(
      {super.key,
      this.labelText,
      this.hintText,
      this.initialValue,
      this.height,
      this.keyboardType,
      this.inputFormatter,
      this.maxLines = 1,
      this.isTextObscured = false,
      this.isForPhone = false,
      this.controller,
      this.onTap,
      required this.action,
      required this.validator});

  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final void Function(String? value) action;
  final String? Function(String? value) validator;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLines;
  final double? height;
  final bool isTextObscured;
  final String? initialValue;
  final bool isForPhone;
  final TextEditingController? controller;
  final void Function()? onTap;

  void handleAction(String? value) {
    action(value);
  }

  @override
  Widget build(BuildContext context) {
    double inputFieldWidth = MediaQuery.of(context).size.width;
    double inputFieldHeight = height ?? 100;

    List<Widget> textInputComponents = [
      Expanded(
          child: TextFormField(
        initialValue: initialValue,
        obscureText: isTextObscured,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatter,
        textAlignVertical: TextAlignVertical.top,
        controller: controller,
        onTap: onTap,

        // Only numbers can be entered,
        // Only numbers can be entered
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFF5C96)),
            borderRadius: isForPhone
                ? const BorderRadius.horizontal(right: Radius.circular(60))
                : BorderRadius.circular(60),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF79747E)),
            borderRadius: isForPhone
                ? const BorderRadius.horizontal(right: Radius.circular(60))
                : BorderRadius.circular(60),
          ),
        ),
        // Added behavior when name is typed
        onChanged: handleAction,
        onSaved: handleAction,
        // Validator as form validation
        validator: validator,
      ))
    ];

    if (isForPhone) {
      textInputComponents.insert(
        0,
        Container(
          height: inputFieldHeight * 0.64,
          width: inputFieldWidth * 0.15,
          decoration: const BoxDecoration(
              border: Border(
                  left: BorderSide(color: Color(0xFF79747E)),
                  bottom: BorderSide(color: Color(0xFF79747E)),
                  top: BorderSide(color: Color(0xFF79747E))),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(60)),
              color: Color(0xFFF5F2F5)),
          child: const Center(
            child: Text('+62'),
          ),
        ),
      );
    }

    List<Widget> textFieldComponents = [
      Expanded(
          child: Row(
        children: textInputComponents,
      ))
    ];

    if (labelText != null) {
      textFieldComponents.insert(
        0,
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(labelText!,
              style: const TextStyle(
                  color: Color(0xFF170015),
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
      );

      textFieldComponents.insert(
        1,
        const SizedBox(
          height: 2,
        ),
      );
    }
    return Container(
        width: inputFieldWidth,
        height: inputFieldHeight,
        alignment: Alignment.topLeft,
        child: Column(
          children: textFieldComponents,
        ));
  }
}
