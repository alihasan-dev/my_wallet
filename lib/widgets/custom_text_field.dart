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
  final Widget? prefix;
  final TextStyle? hintStyle;
  final bool animatedError;
  final Function()? onTap;
  final String? hintText;

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
    this.prefix,
    this.hintStyle,
    this.animatedError = true,
    this.onTap,
    this.hintText,
    super.key
  });

  @override 
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // RichText(
        //   text: TextSpan(
        //     children: [
        //       TextSpan(
        //         text: '  $title', 
        //         style: TextStyle(
        //           color: textTheme.bodyLarge!.color
        //         ),
        //       ),
        //       TextSpan(
        //         text: isMandatory == null || !isMandatory! 
        //         ? '' 
        //         : ' *', 
        //         style: const TextStyle(color: AppColors.red)
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(height: AppSize.s4),
        TextField(
          obscureText: isPasswordField,
          controller: textEditingController,
          cursorWidth: 1.8,
          style: getMediumStyle(
            color: Helper.isDark 
            ? AppColors.white.withValues(alpha: 0.9) 
            : AppColors.black,
          ),
          textInputAction: textInputAction,
          readOnly: readOnly == null || !readOnly! ? false : true,
          maxLength: maxLength,
          inputFormatters: textInputFormatter,
          keyboardType: keyboardType,
          onTap: onTap,
          decoration: InputDecoration(
            label: RichText(
              text: TextSpan(
                text: title,
                style: TextStyle(
                  color: Helper.isDark 
                  ? AppColors.white.withValues(alpha: 0.8)
                  : AppColors.black.withValues(alpha: 0.7),
                  fontFamily: 'OpenSans'
                ),
                children: isMandatory == null || !isMandatory!
                ? null
                : const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            hintText: hintText ?? title,
            counterText: '',
            hintStyle: hintStyle ?? getRegularStyle(
              color: Helper.isDark 
              ? AppColors.grey 
              : AppColors.black
            ),
            errorText: animatedError
            ? null
            : (errorText ?? '').isBlank
              ? null
              : errorText ?? '',
            errorStyle: TextStyle(color: AppColors.red),
            // isDense: true,
            enabled: isEnabled == null || isEnabled! ? true : false,
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppSize.s12, 
              horizontal: AppSize.s10
            ),
            border: const OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: AppColors.primaryColor)),
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: AppColors.primaryColor)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: AppColors.red)),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: AppColors.primaryColor)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: errorText == null || errorText!.isBlank
                  ? AppSize.s05
                  : 1.5, 
                color: Helper.isDark 
                ? AppColors.grey 
                : errorText == null || errorText!.isBlank 
                  ? AppColors.primaryColor
                  : AppColors.red
              )
            ),
            suffixIcon: onSuffixTap == null
            ? null
            : Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: GestureDetector(
                onTap: onSuffixTap,
                child: Icon(
                  suffixIcon ?? (isPasswordField 
                  ? AppIcons.visibilityIcon
                  : AppIcons.visibilityOffIcon),
                  color: AppColors.grey,
                  size: 22,
                ),
              ),
            ),
            prefix: prefix
          ),
          onChanged: onChange,
          onSubmitted: onSubmitted
        ),
        if (animatedError) ...[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: (errorText == null || errorText!.isEmpty)
            ? CustomText(title: '')
            : Padding(
              key: ValueKey(errorText),
              padding: const EdgeInsets.only(
                left: AppSize.s10,
                top: 3,
              ),
              child: CustomText(
                title: errorText!,
                textStyle: getRegularStyle(color: AppColors.red),
              ),
            ),
          )
        ]
      ],
    );
  }  
  
}