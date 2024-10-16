import 'package:flutter/widgets.dart';
import '../widgets/custom_text.dart';
import '../constants/app_color.dart';
import '../constants/app_style.dart';
import '../constants/app_size.dart';

class CustomEmptyWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  const CustomEmptyWidget({
    super.key,
    required this.title,
    required this.icon
  });

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: AppSize.s60),
          CustomText(
            title: title, 
            textStyle: getSemiBoldStyle(
              color: AppColors.black, 
              fontSize: AppSize.s20
            ),
          ),
        ],
      ),
    );
  }
}