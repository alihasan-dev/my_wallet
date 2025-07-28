import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_extension_method.dart';
import '../constants/app_icons.dart';
import '../utils/helper.dart';
import '../widgets/custom_text.dart';
import '../constants/app_color.dart';
import '../constants/app_style.dart';
import '../constants/app_size.dart';

class CustomTextField extends StatelessWidget {

  final String title;
  final TextEditingController textEditingController;
  final bool isPasswordField;
  final bool? isEnabled;
  final int? maxLines;
  final int? maxLength;
  final bool? isMandatory;
  final List<TextInputFormatter>? textInputFormatter;
  final VoidCallback? onSuffixTap;
  final TextInputType? keyboardType;
  final String? errorText;
  final TextInputAction? textInputAction;
  final Function(String)? onChange;
  final Function(String)? onSubmitted;
  final bool? readOnly;
  final IconData? suffixIcon;

  const CustomTextField({
    required this.title,
    required this.isPasswordField,
    required this.textEditingController,
    this.keyboardType,
    this.isEnabled,
    this.isMandatory,
    this.onSuffixTap,
    this.errorText,
    this.onChange,
    this.onSubmitted,
    this.textInputAction,
    this.readOnly,
    this.maxLines,
    this.maxLength,
    this.textInputFormatter,
    this.suffixIcon,
    super.key
  });

  @override 
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '  $title', 
                style: TextStyle(
                  color: textTheme.bodyLarge!.color
                ),
              ),
              TextSpan(
                text: isMandatory == null || !isMandatory! 
                ? '' 
                : ' *', 
                style: const TextStyle(color: AppColors.red)
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSize.s4),
        TextField(
          obscureText: isPasswordField,
          controller: textEditingController,
          cursorWidth: 1.5,
          style: getMediumStyle(
            color: Helper.isDark 
            ? AppColors.white.withValues(alpha: 0.9) 
            : AppColors.black
          ),
          textInputAction: textInputAction,
          readOnly: readOnly == null || !readOnly! ? false : true,
          maxLength: maxLength,
          inputFormatters: textInputFormatter,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: title,
            counterText: '',
            hintStyle: getRegularStyle(
              color: Helper.isDark 
              ? AppColors.grey 
              : AppColors.black
            ),
            isDense: true,
            enabled: isEnabled == null || isEnabled! ? true : false,
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppSize.s12, 
              horizontal: AppSize.s10
            ),
            border: const OutlineInputBorder(borderSide: BorderSide(width: AppSize.s05)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: errorText == null || errorText!.isBlank
                  ? AppSize.s05
                  : 1.5, 
                color: Helper.isDark 
                ? AppColors.grey 
                : errorText == null || errorText!.isBlank 
                  ? AppColors.black
                  : AppColors.red
              )
            ),
            suffixIcon: suffixIcon != null
            ? InkWell(
                onTap: onSuffixTap,
                child: Icon(suffixIcon, color: AppColors.grey),
              )
            : onSuffixTap == null
              ? null
              : InkWell(
                onTap: onSuffixTap,
                child: Icon(
                isPasswordField 
                ? AppIcons.visibilityIcon
                : AppIcons.visibilityOffIcon,
                color: AppColors.grey
              ),
            ),
          ),
          onChanged: onChange,
          onSubmitted: onSubmitted
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: AppSize.s10, 
            top: AppSize.s2
          ),
          child: CustomText(
            title: errorText ?? '',
            textStyle: getRegularStyle(color: AppColors.red)
          ),
        ),
      ],
    );
  }  
  
}