import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'custom_text_widget.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final TextInputType? textInputType;
  final IconButton? suffixIcon;
  final Icon? prefixIcon;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  const CustomTextField({
    this.controller,
    this.suffixIcon,
    this.textInputType,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.onTap,
    this.readOnly = false,
    this.textInputAction,
    this.validator,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null)
            CustomTextWidget(
              text: widget.labelText ?? '',
              textColor: smokyBrownColor,
              fontSize: 14,
            ),
          const SizedBox(height: 5),
          TextFormField(
            controller: widget.controller,
            obscureText: widget.suffixIcon != null ? _obscureText : false,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            validator: widget.validator,
            textInputAction: widget.textInputAction,
            keyboardType: widget.textInputType,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              hintText: widget.hintText,
              suffixIcon: widget.suffixIcon != null
                  ? IconButton(
                      tooltip: _obscureText ? 'Show password' : 'Hide password',
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: smokyBrownColor,
                      ),
                      onPressed: () {
                        _toggleObscureText();
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
