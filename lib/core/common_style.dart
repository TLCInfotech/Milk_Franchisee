import 'package:flutter/material.dart';
import 'package:milk_fr/core/size_config.dart';
import '../core/localss/api_data_fetch_localization.dart';


import 'colors.dart';

const big_title_style=TextStyle(
  fontSize: 26.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  fontFamily: "OpenSans-Medium"
);

const heading_title_style=TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  fontFamily: "OpenSans-Medium"
);

const button_textStyle=TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: "OpenSans-SemiBold"
);

const subHeading_withBold=TextStyle(
  fontSize: 20.0,
  color: Colors.black,
  fontFamily: "OpenSans-SemiBold"
);
const fordashboard=TextStyle(
    fontSize: 18.0,
    color: Colors.black,
    fontFamily: "OpenSans-SemiBold"
);

const subHeading=TextStyle(
  fontSize: 20.0,
  color: Colors.white,
  fontFamily: "OpenSans-SemiBold"
);

var button_text_style=TextStyle(
    color: Colors.black87,
    fontSize: SizeConfig.blockSizeHorizontal* 4.5,
    fontWeight: FontWeight.w500,
    fontFamily: "OpenSans-SemiBold"
);

const textfield_label_style=TextStyle(
    fontSize: 18.0,
    color: Colors.black,
    fontFamily: "OpenSans-SemiBold"

);

const hint_textfield_Style = TextStyle(
    fontFamily: ' OpenSans-Regular',
    color:Colors.grey,
    fontSize: 20
);

var textfield_decoration = InputDecoration(
  hintText: '',
  contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
  labelStyle: item_heading_textStyle,
  fillColor:  Colors.white,
  filled: true,
  hintStyle: item_heading_textStyle.copyWith(color: Colors.grey),
  floatingLabelStyle: const TextStyle(fontFamily: ' OpenSans-Regular',fontSize: 20,color: Colors.indigo,fontWeight: FontWeight.w700),

  enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent,width: 0.5),
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  focusedBorder: const OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.transparent,width: 1),
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  focusedErrorBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  errorBorder:  const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),

);

var box_decoration=BoxDecoration(
  color: CommonColor.WHITE_COLOR,
  borderRadius: BorderRadius.circular(4),
  boxShadow: [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 5,
      color: Colors.black.withOpacity(0.1),
    ),
  ],
);


const appbar_text_style=TextStyle(
    fontSize: 22.0,
    color: Colors.black87,
    fontFamily: "  OpenSans-Medium"
);

const page_heading_textStyle=TextStyle(
    fontSize: 22.0,
    color: Colors.black87,
    fontFamily: "  OpenSans-Medium"
);

const text_field_textStyle=TextStyle(
    fontSize: 22,
    color: Colors.black87,
    fontFamily: "  OpenSans-Medium"
);


const item_heading_textStyle=TextStyle(
    fontSize: 20.0,
    color: Colors.black87,
    fontFamily: "  OpenSans-Medium"
);

const item_list=TextStyle(
    fontSize: 20.0,
    color: Colors.white,
    fontFamily: "  OpenSans-Medium"
);

 
const item_regular_textStyle=TextStyle(
    fontSize: 18.0,
    color: Colors.black87,
    fontFamily: " OpenSans-Regular"
);


const item_regular_textStyle_small=TextStyle(
    fontSize: 16.0,
    color: Colors.black87,
    fontFamily: " OpenSans-Regular"
);

