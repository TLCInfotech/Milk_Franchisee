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

class GetDateLayout extends StatefulWidget{
  final readOnly;
  final title;
  final comeFor;
  var hideDate;
  final applicablefrom;
  final parentWidth;
  final dateTime;
  final Function(DateTime?) callback;
  final titleIndicator;
  var endate;
  var fdate;
  var isclear;

  GetDateLayout({required this.title, required this.callback, required this.applicablefrom,   this.titleIndicator,  this.parentWidth, this.comeFor, this.readOnly, this.dateTime, this.hideDate,this.endate,this.fdate,this.isclear});

  @override
  State<GetDateLayout> createState() => _GetDateLayoutState();
}

class _GetDateLayoutState extends State<GetDateLayout> {
  bool hideD=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.hideDate==true){
      hideD=widget.hideDate;
    }
  }
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
              setState(() {
                hideD=false;
              });
              if(widget.readOnly==null|| widget.readOnly==false) {
                FocusScope.of(context).requestFocus(FocusNode());
                if (widget.comeFor != "newOne") {
                  if (Platform.isIOS) {
                    var date = await CommonWidget.startDate(
                        context, widget.applicablefrom,widget.endate,widget.fdate);
                    widget.callback(date);
                    // startDateIOS(context);
                  } else if (Platform.isAndroid) {
                    var date = await CommonWidget.startDate(
                        context, widget.applicablefrom,widget.endate,widget.fdate);
                    widget.callback(date);
                  }
                } else {
                  print("Voucher Number blank???????");
                }
              }
            },
            child: Container(
              padding: EdgeInsets.all(10),
              width:  widget.parentWidth ==null? (SizeConfig.screenWidth ):  widget.parentWidth *.4,
              height: (SizeConfig.screenHeight) * .055,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:CommonColor.WHITE_COLOR,
                borderRadius: BorderRadius.circular(5),
                border:Border.all(color: Colors.transparent) ,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child:hideD==true?Container():  Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.applicablefrom==null?Text("${ApplicationLocalizations.of(context).translate("select_date")}",style: hint_textfield_Style,):
                        widget.dateTime==true?Text(
                          CommonWidget.getDateTimeLayout(widget.applicablefrom),
                          //DateFormat('dd-MM-yyyy').format(applicablefrom),
                          style: item_heading_textStyle,)
                            :Text(
                          CommonWidget.getDateLayout(widget.applicablefrom),
                          //DateFormat('dd-MM-yyyy').format(applicablefrom),
                          style:item_heading_textStyle,),
                        FaIcon(FontAwesomeIcons.calendar,
                          color: Colors.black87, size: 16,),

                      ],
                    ),
                  ),
                  widget.isclear!=null && widget.applicablefrom!=null? GestureDetector(
                    onTap: (){
                      widget.callback(null);
                    },
                    child: Padding(
                      padding:EdgeInsets.only(left: 15,top: 2),
                      child: FaIcon(FontAwesomeIcons.close,
                        color: Colors.black87, size: 20,),
                    ),
                  ):Container()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}