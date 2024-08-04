import 'package:flutter/material.dart';

class CustomInkWellWidget extends StatelessWidget {

  final Widget widget;
  final Function()? onTap;

  const CustomInkWellWidget({
    super.key, 
    required this.onTap, 
    required this.widget
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: widget,
    );
  }

}