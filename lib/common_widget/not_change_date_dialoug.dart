import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/localss/api_data_fetch_localization.dart';

import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/colors.dart';
import '../core/common_style.dart';
import '../core/size_config.dart';
import 'common.dart';

class NoChangeDate extends StatefulWidget{
  final title;
  final comeFor;
  final applicablefrom;
  final parentWidth;
  final titleIndicator;

  NoChangeDate({required this.title, required this.applicablefrom,   this.titleIndicator,  this.parentWidth, this.comeFor});

  @override
  State<NoChangeDate> createState() => _NoChangeDateState();
}

class _NoChangeDateState extends State<NoChangeDate> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  widget.titleIndicator!=false?EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.015):EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.titleIndicator!=false? Text(
            widget.title,
            style: item_heading_textStyle,
          ):Container(),

          GestureDetector(
            onTap: ()async{
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              width:  widget.parentWidth ==null? (SizeConfig.screenWidth ):  widget.parentWidth *.4,
              height: (SizeConfig.screenHeight) * .055,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  // BoxShadow(
                  //   offset: Offset(0, 1),
                  //   blurRadius: 5,
                  //   color: Colors.black.withOpacity(0.1),
                  // ),
                ],
              ),
              child:  Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color:CommonColor.TexField_COLOR,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        CommonWidget.getDateLayout(widget.applicablefrom),
                        //DateFormat('dd-MM-yyyy').format(applicablefrom),
                        style: item_heading_textStyle,),
                      FaIcon(FontAwesomeIcons.calendar,
                        color: Colors.black87, size: 16,)
                    ],
                  )
              ),
            ),
          )
        ],
      ),
    );
  }

}