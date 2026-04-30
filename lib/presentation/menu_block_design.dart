import 'package:flutter/material.dart';
import '../../core/common_style.dart';

class MenuBlocksDesign extends StatelessWidget {
  final menuHeight;
  final menuWidth;
  final borderColor;
  final menuTitle;
  final menuIcon;
  final fontmenuSize;
  final  onPressed;


  const MenuBlocksDesign({
    super.key,
    this.borderColor,
    this.menuTitle,
    this.menuIcon, required this.onPressed,
    this.menuHeight,
    this.menuWidth, this.fontmenuSize,

  });

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
       onTap: onPressed,
        child: Container(
        height: double.parse(menuHeight.toString()),
        width:menuWidth,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            menuIcon==null?Container(): Icon(
              menuIcon,
              color: borderColor,
            ),
            Text(
              "$menuTitle",
              style: textfield_label_style.copyWith(fontSize: fontmenuSize!=null?double.parse(fontmenuSize.toString()):16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
            ),
      );
  }
}
