import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AppColors.dart';
import 'Fonts.dart';

class InputTextFieldWithText extends StatelessWidget {
  final String label;
  final String hintText;
  final String iconPath;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  const InputTextFieldWithText({
    super.key,
    required this.label,
    required this.hintText,
    required this.textController,
    required this.iconPath,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Text
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: Fonts.interSemiBold,
            ),
          ),
        ),

        // TextField with gradient background
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: TextField(
            obscureText: obscureText,
            controller: textController,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              fillColor: AppColors.colorTransparent,
              filled: true,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 13.0, horizontal: 20.0),
              counterText: '',
              hintStyle: TextStyle(
                color: AppColors.color4D4D4D,
                fontWeight: FontWeight.w400,
                fontSize: 16,
                fontFamily: Fonts.interMedium,
              ),
              hintText: hintText,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.colorTransparent),
                borderRadius: BorderRadius.circular(30.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.colorTransparent),
                borderRadius: BorderRadius.circular(30.0),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 15, right: 10),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).brightness == Brightness.dark
                        ? AppColors.colorWhite
                        : AppColors.colorGreyDark,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    iconPath,
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
            ),
            keyboardType: keyboardType,
            textInputAction: textInputAction,
          ),
        ),
      ],
    );
  }
}
