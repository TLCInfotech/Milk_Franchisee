import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../common_widget/common.dart';
import '../../common_widget/singleLine_TextformField_without_double.dart';
import '../../core/app_preferance.dart';
import '../../core/colors.dart';
import '../../core/common_style.dart';
import '../../core/localss/api_data_fetch_localization.dart';
import '../../core/size_config.dart';
import '../dashboard_activity.dart';
import 'login_screen.dart';

class DomainLinkActivity extends StatefulWidget {
  const DomainLinkActivity({super.key});
  // final DomainLinkActivityInterface mListener;
  @override
  State<DomainLinkActivity> createState() => _DomainLinkActivityState();
}

class _DomainLinkActivityState extends State<DomainLinkActivity> {



  final _domainLinkFocus = FocusNode();
  final _companyIdFocus = FocusNode();
  final domainLinkController = TextEditingController();
  final companyId = TextEditingController();

  bool disableColor = false;
  List companyIDList=[];

  @override
  void initState() {
    // TODO: implement initState
    getLocalData();
    super.initState();

  }

  getLocalData()async {
    var cidList=await AppPreferences.getCompanyIdList();
    var baseUrl=await AppPreferences.getDomainLink();
    print(cidList.length);
    domainLinkController.text=await AppPreferences.getDomainLink();
    domainLinkController.text=baseUrl;
    setState(() {
      if(cidList.length!=0) {
        companyIDList = jsonDecode(cidList);
      }
      domainLinkController.text="http://61.2.227.173:4000/";
    });
  }



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: CommonColor.BACKGROUND_COLOR,
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: SafeArea(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: Colors.transparent,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: AppBar(
                leadingWidth: 0,
                automaticallyImplyLeading: false,
                title:  Container(
                  width: SizeConfig.screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async{
                          String sessionToken =await AppPreferences.getSessionToken();
                          setState(() {
                            if(sessionToken!="") {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => HomePage()));
                            }
                            else{
                              Navigator.of(context).pushReplacementNamed('/loginActivity');
                            }
                          });
                        },
                        child: FaIcon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "${ApplicationLocalizations.of(context).translate("setting")}",
                            style: appbar_text_style,),
                        ),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                  child: getAllTextFormFieldLayout(
                      SizeConfig.screenHeight, SizeConfig.screenWidth)),
            ),
            // Container(
            //     decoration: BoxDecoration(
            //       color: CommonColor.WHITE_COLOR,
            //       border: Border(
            //         top: BorderSide(
            //           color: Colors.black.withOpacity(0.08),
            //           width: 1.0,
            //         ),
            //       ),
            //     ),
            //     height: SizeConfig.safeUsedHeight * .08,
            //     child: getSaveAndFinishButtonLayout(
            //         SizeConfig.screenHeight, SizeConfig.screenWidth)),
            CommonWidget.getCommonPadding(
                SizeConfig.screenBottom, CommonColor.WHITE_COLOR),
          ],
        ),
      ),
    );
  }


  double opacityLevel = 1.0;

  var selecteditemindex=null;

  /* Widget for all text form field widget layout */
  Widget getAllTextFormFieldLayout(double parentHeight, double parentWidth) {
    return ListView(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
          left: parentWidth * 0.04,
          right: parentWidth * 0.04,
          top: parentHeight * 0.01,
          bottom: parentHeight * 0.02),
      children: [
        Padding(
          padding: EdgeInsets.only(top: parentHeight * .01),
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(
                  left: parentWidth * .01, right: parentWidth * .01),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey,width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8),
                    child: Text(
                      "${ApplicationLocalizations.of(context).translate("company")} ",
                      style: item_heading_textStyle,
                    ),
                  ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(
                    //     "Link",
                    //     style: item_heading_textStyle,
                    //   ),
                    // ),

                  getCompanyId(parentHeight, parentWidth),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.only(left: 8,right: 8),
                      child: Text(
                        "${ApplicationLocalizations.of(context).translate("domain")} ",
                        style: item_heading_textStyle,
                      ),
                    ),
                    getDomainLinkLayout(parentHeight, parentWidth),

                    Padding(
                      padding: EdgeInsets.only(
                          left: parentWidth * .04,
                          right: parentWidth * 0.04,
                          top: parentHeight * .015),
                      child: GestureDetector(
                        onTap: () async{


                          if (mounted && companyId.text!="" && domainLinkController.text!="") {
                            var listItem={
                              "company":companyId.text.trim(),
                              "domainLink":"${domainLinkController.text}".trim()
                            };
                            setState(() {
                              companyIDList.add(listItem);
                              companyId.clear();
                              domainLinkController.clear();
                              _domainLinkFocus.requestFocus();
                              selecteditemindex=null;
                            });
                            AppPreferences.setCompanyIdList(jsonEncode(companyIDList));
                            AppPreferences.setDomainLinkVisibility("2");
                            print(companyIDList);
                          }
                          else{
                            var snackBar = SnackBar(content: Text('Fill all the necessary field!'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        onDoubleTap: () {},
                        child: Container(
                          height: parentHeight * .06,
                          decoration: BoxDecoration(
                            color: disableColor == true
                                ? CommonColor.THEME_COLOR.withOpacity(.5)
                                : CommonColor.THEME_COLOR,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: parentWidth * .005),
                                child:  Text(
                                  "${ApplicationLocalizations.of(context).translate('adds')}",
                                  style: subHeading_withBold.copyWith(color: Colors.white ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 9,),
       companyIDList.length>0? SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            showCheckboxColumn: false, //
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10)
            ),
            dataRowColor: MaterialStateProperty.all(Colors.white),
            columnSpacing: 10,
            headingRowColor: MaterialStateColor.resolveWith((states) => CommonColor.THEME_COLOR),
            columns:  <DataColumn>[
              DataColumn(
                label: Container(
                  width: 10,
                  child: Text(
                    '',
                    style: subHeading_withBold.copyWith(color: Colors.white),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  width: SizeConfig.halfscreenWidth-10,
                  child: Text(
                    '${ApplicationLocalizations.of(context).translate("company")}',
                    style:subHeading_withBold.copyWith(color: Colors.white,fontSize: 22),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  width: SizeConfig.halfscreenWidth-10,
                  child: Text(
                    '${ApplicationLocalizations.of(context).translate("link")}',
                    style: subHeading_withBold.copyWith(color: Colors.white,fontSize: 22),
                  ),
                ),
              ),

            ],

            rows:  <DataRow>[
              for(var i in companyIDList)
               DataRow(
                 onSelectChanged: (bool){
                  setState(() {
                    domainLinkController.text=i['domainLink'];
                    companyId.text=i['company'];
                    selecteditemindex=companyIDList.indexOf(i);
                    companyIDList.remove(i);
                  });

                 },
                cells: <DataCell>[
                  DataCell(
                    GestureDetector(
                    onTap: ()async{
                      setState(() {
                        companyIDList.remove(i);
                        AppPreferences.setDomainLinkVisibility("1");
                      });
                      await AppPreferences.setCompanyIdList(jsonEncode(companyIDList));

                    },
                    child:Icon(Icons.delete,color: Colors.red,size: 20,),
                  ),),
                  DataCell(Text('${i['company']}',style: item_regular_textStyle.copyWith(fontSize: 22),)),
                  DataCell(Text('${i['domainLink']}',style: item_regular_textStyle.copyWith(fontSize: 22) ,)),
                ],
              ),
            ],
          ),
        ):Container()
      ],
    );
  }

  /* Widget for domain Link text from field layout */
  Widget getDomainLinkLayout(double parentHeight, double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(
        top: parentHeight * 0.01,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: parentHeight * .1,
                decoration: BoxDecoration(
                  color: CommonColor.WHITE_COLOR,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: parentHeight * .01),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    textCapitalization: TextCapitalization.sentences,
                    scrollPadding: EdgeInsets.only(bottom: parentHeight * .2),
                    focusNode: _domainLinkFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    maxLines: 20,
                    maxLength: 500,
                    cursorColor: CommonColor.BLACK_COLOR,
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.only(left: parentWidth * .04),
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      hintText: "Domain Link",
                      hintStyle: hint_textfield_Style,
                    ),
                    controller: domainLinkController,
                    validator: (value){
                      setState(() {
                        // domainLinkController.text=value!;
                        print("hdghghdgh  $value");

                      });
                    },
                    onEditingComplete: () {

                      _domainLinkFocus.unfocus();
                    },
                    style: text_field_textStyle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getCompanyId(double parentHeight, double parentWidth){
    return    Container(
      width: (SizeConfig.screenWidth ),
      height:(SizeConfig.screenHeight) * .07,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:CommonColor.WHITE_COLOR,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return     "Enter Company ";
          }
          return null;
        },
        controller: companyId,
        focusNode: _companyIdFocus,
        onChanged: (value) {
          setState(() {
            //companyId.text = value;
          });
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
              left: (SizeConfig.screenWidth) * .04, right: (SizeConfig.screenWidth) * .02),
          border: InputBorder.none,

          counterText: '',
          isDense: false,
          hintText: "${ApplicationLocalizations.of(context).translate("company")}",
          hintStyle: hint_textfield_Style,
          errorStyle: TextStyle(
              color: Colors.redAccent,
              fontSize: 16.0,
              height: 0

          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent,width: 0.5),
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Colors.transparent,width: 1),
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          ),

        ),
        keyboardType: TextInputType.text,
        maxLines: 2,
        style: text_field_textStyle,
        // onFieldSubmitted: (v){
        //   setState(() {
        //     companyIDList.add(v);
        //     companyId.clear();
        //
        //   });
        // },

      ),
    );
  }

  /* Widget for navigate to next screen button layout */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: parentWidth * .04,
              right: parentWidth * 0.04,
              top: parentHeight * .015),
          child: GestureDetector(
            onTap: () async{

              if (mounted && companyIDList.length>0 ) {
                String sessionToken =await AppPreferences.getSessionToken();
                setState(() {
                  disableColor = true;
                  AppPreferences.setCompanyIdList(jsonEncode(companyIDList));
                  var snackBar = SnackBar(content: Text('Domain save succesfully!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  if(sessionToken!="") {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HomePage()));
                  }
                  else{
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => LoginScreen()));
                    // callGetCompany();
                  }
                });
              }
              else{
                var snackBar = SnackBar(content: Text('Fill all the necessary field!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            onDoubleTap: () {},
            child: Container(
              height: parentHeight * .06,
              decoration: BoxDecoration(
                color: disableColor == true
                    ? CommonColor.THEME_COLOR.withOpacity(.5)
                    : CommonColor.THEME_COLOR,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: parentWidth * .005),
                    child:  Text(
                     "Save",
                      style: subHeading_withBold.copyWith(color: Colors.white ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

}

abstract class DomainLinkActivityInterface {
  backToLogin();
}
