import 'dart:io';

import 'package:flutter/material.dart';


import 'package:flutter/services.dart';

import '../../core/colors.dart';
import '../../core/common_style.dart';
import '../../core/size_config.dart';

class GetDisableTextFormField extends StatefulWidget{
  final title;
  final controller;
  final parentWidth;

  GetDisableTextFormField({required this.title,required this.controller, this.parentWidth,});

  @override
  State<GetDisableTextFormField> createState() => _GetDisableTextFormFieldState();
}

class _GetDisableTextFormFieldState extends State<GetDisableTextFormField> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.012),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: item_heading_textStyle,
          ),
          Padding(
            padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.0015),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: widget.parentWidth ==null? (SizeConfig.screenWidth ):  widget.parentWidth *.4,
                  height: (SizeConfig.screenHeight) * .055,
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: CommonColor.TexField_COLOR,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: widget.controller.text==""?
                  Text(widget.title,style: item_heading_textStyle,)
                      :Text(widget.controller.text,style: item_heading_textStyle,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}