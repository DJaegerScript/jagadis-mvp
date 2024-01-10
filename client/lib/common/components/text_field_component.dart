import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldComponent extends StatelessWidget {
  const TextFieldComponent(
      {super.key,
        required this.labelText,
        this.hintText,
        this.initialValue,
        this.height,
        this.keyboardType,
        this.inputFormatter,
        this.maxLines = 1,
        this.isTextObscured = false,
        this.isForPhone = false,
        required this.action,
        required this.validator});

  final String? hintText;
  final String labelText;
  final TextInputType? keyboardType;
  final void Function(String? value) action;
  final String? Function(String? value) validator;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLines;
  final double? height;
  final bool isTextObscured;
  final String? initialValue;
  final bool isForPhone;

  void handleAction(String? value) {
    action(value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: MediaQuery.of(context).size.width,
      // Using padding of 8 pixels
      child: TextFormField(
        initialValue: initialValue,
        obscureText: isTextObscured,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatter,
        textAlignVertical: TextAlignVertical.top,
      
        // Only numbers can be entered,
        // Only numbers can be entered
        decoration: InputDecoration(
          prefixIcon: isForPhone ? Padding( 
            padding: EdgeInsets.only(right: 8),
            child: Container(
            height: height,
            width: 60,
            margin: const EdgeInsets.only(left: 1),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  bottomLeft: Radius.circular(60)
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 15.5, bottom: 15.5),
              child: Align(
                alignment: Alignment.center,
                child: Text('+62', style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
              ),
            )
          )): null,
          hintText: hintText,
          labelText: labelText,
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        // Added behavior when name is typed
        onChanged: handleAction,
        onSaved: handleAction,
        // Validator as form validation
        validator: validator,
      ),
    );
  }
}