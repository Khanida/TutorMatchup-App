import 'package:flutter/material.dart';
import 'package:tutor_matchup/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color? buttonTextColor;
  final Color? buttonBorderColor;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final double? textSize;
  final String? image;

  const CustomButton({
    this.backgroundColor,
    this.image,
    this.buttonTextColor,
    this.buttonBorderColor,
    this.textSize,
    required this.onTap,
    required this.buttonText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final background = backgroundColor ?? lightBlueColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.9,
        height: 52,
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: buttonBorderColor ?? Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  if (image != null) ...[
                    Image.asset(
                      image!,
                      width: 26,
                      height: 26,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Center(
                      child: Text(
                        buttonText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: buttonTextColor ??
                              (background == whiteColor
                                  ? midnightBlueColor
                                  : whiteColor),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: textSize ?? 16,
                        ),
                      ),
                    ),
                  ),
                  if (image != null) const SizedBox(width: 38),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
