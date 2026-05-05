import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';


import 'package:flutter/services.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../../../../common_widget/common.dart';
import '../../../../../../common_widget/get_date_layout.dart';
import '../../../../../../common_widget/signleLine_TexformField.dart';
import '../../../../../../core/app_preferance.dart';
import '../../../../../../core/colors.dart';
import '../../../../../../core/common_style.dart';
import '../../../../../../core/internet_check.dart';
import '../../../../../../core/localss/api_data_fetch_localization.dart';
import '../../../../../../core/localss/application_localizations.dart';
import '../../../../../../core/size_config.dart';
import '../../../../../../data/commonRequest/get_toakn_request.dart';
import '../../../../../../data/constant.dart';
import '../../../../../../searchable_Dropdowns/ledger_searchable_dropdown.dart';
import '../../../../../../searchable_Dropdowns/search_dropdown_with_acceptance.dart';
import '../../../../../../searchable_Dropdowns/serchable_drop_down_for_existing_list.dart';
import '../../core/string_en.dart';
import '../../data/postMilkCollection.dart';
import '../../data/request_helper.dart';
import '../../dialog/deleteDialog.dart';
import '../../searchable_Dropdowns/common_dropdown.dart';
import '../common_widget/custom_appbar.dart';
import 'add_or_edit_milk_collection.dart';

class MilkCollectionActivity extends StatefulWidget {
  final come;
  final route_type;
  final String title;
  final String setVal;
  final from_date;
  final to_date;
  const MilkCollectionActivity( {super.key, this.route_type, required this.title, required this.setVal,
    required  this.from_date,
    required this.to_date, this.come,
  });

  @override
  State<MilkCollectionActivity> createState() => _MilkCollectionActivityState();
}
class _MilkCollectionActivityState extends State<MilkCollectionActivity>
    with SingleTickerProviderStateMixin
    implements AddOrEditMilkCollectionInterface{
final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  late AnimationController _Controller;

  // DateTime invoiceDate = DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  DateTime from_date = DateTime.now();
  DateTime to_date = DateTime.now();
  final _voucherNoFocus = FocusNode();
  final VoucherNoController = TextEditingController();

  TextEditingController invoiceNo = TextEditingController();

  String selectedVendorName = "";
  dynamic selectedVendorId = "";

  String selectedWorkingUnderName = "";
  String setVel = "";
  String title = "";
  dynamic selectedWorkingUnderId = "";

  var selectedSession="";
  var selectedSessionCode="";

  List<dynamic> ListMenu = [];


  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  var companyId = "0";
  bool isLoaderShow = false;
  bool showButton = false;

  var editedItemIndex = null;

  double minX = 30;
  double minY = 30;
  double maxX = SizeConfig.screenWidth*0.78;
  double maxY = SizeConfig.screenHeight*0.9;

  Offset position = Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.75);

  String TotalAmount = "0.00";
  String TotalInvoice="0";
  String avgSNF = "0.00";
  String avgFAT = "0.00";
  String totalLtr = "0.00";


  var route_type="";

  void _updateOffset(Offset newOffset) {
    setState(() {
      // Clamp the Offset values to stay within the defined constraints
      double clampedX = newOffset.dx.clamp(minX, maxX);
      double clampedY = newOffset.dy.clamp(minY, maxY);
      position = Offset(clampedX, clampedY);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    route_type=widget.route_type;
    setVel=widget.setVal;
    title=widget.title;
    _Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    setState(() {
      from_date=widget.from_date;
      to_date=widget.to_date;
    });
    getData();

  }

  getData() async{
    if(widget.come=="dashboard"){
      setState(() {
        selectedSession="";
        selectedSessionCode="";
      });
    }
    else{
      await    checkAfterFive();

    }
    await _getMilkCollection(1);
  }
  checkAfterFive() async {
    // await Future.delayed(Duration(seconds: 2));
    DateTime now = DateTime.now();
    DateTime fivePM = DateTime(now.year, now.month, now.day, 17, 0); // 17:00 is 5:00 PM
    if (now.isAfter(fivePM)) {
      print("It's after 5 PM");
      setState(() {
        selectedSession="Evening";
        selectedSessionCode="E";
      });

    } else {
      print("It's before 5 PM");
      setState(() {
        selectedSession="Morning";
        selectedSessionCode="M";
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // if (showButton == true) {
          //           //   await showCustomDialog(context);
          //           //   return false;
          //           // } else {
          //           //   return true;
          //           // }
          return true;
        },
        child: contentBox(context));
  }
  Widget contentBox(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: SizeConfig.safeUsedHeight,
          width: SizeConfig.screenWidth,
          // padding: EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: CommonColor.BACKGROUND_COLOR,
            // borderRadius: BorderRadius.circular(16.0),
          ),
          child: Scaffold(
            backgroundColor: CommonColor.BACKGROUND_COLOR,
            // appBar: PreferredSize(
            //   preferredSize: AppBar().preferredSize,
            //   child: SafeArea(
            //     child: Card(
            //       elevation: 3,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(25)),
            //       color: Colors.transparent,
            //       // color: Colors.red,
            //       margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            //       child: AppBar(
            //         leadingWidth: 0,
            //         automaticallyImplyLeading: false,
            //         title: Container(
            //           width: SizeConfig.screenWidth,
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               GestureDetector(
            //                 onTap: () async {
            //                   Navigator.pop(context);
            //                 },
            //                 child: FaIcon(Icons.arrow_back),
            //               ),
            //               Expanded(
            //                 child: Center(
            //                     child:Text(
            //                       widget.title,
            //                       style: appbar_text_style,)
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(25)),
            //         backgroundColor: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
            appBar: PreferredSize(
              preferredSize: AppBar().preferredSize,
              child:  CustomeAppBar(title: widget.title,dashbord: false, onPress: null,),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: RefreshIndicator(
                    color: CommonColor.THEME_COLOR,
                    onRefresh: () {
                      return refreshList();
                    },
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        // color: CommonColor.DASHBOARD_BACKGROUND,
                        child: getAllFields(
                            SizeConfig.screenHeight, SizeConfig.screenWidth)),
                  ),
                ),
                ListMenu.length<0  && showButton==false?Container(): Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: CommonColor.WHITE_COLOR,
                      border: Border(
                        top: BorderSide(
                          color: Colors.black.withOpacity(0.08),
                          width: 1.0,
                        ),
                      ),
                    ),
                    height: SizeConfig.safeUsedHeight * .13,
                    child: getSaveAndFinishButtonLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth)),
                CommonWidget.getCommonPadding(
                    SizeConfig.screenBottom, CommonColor.WHITE_COLOR),
              ],
            ),
          ),
        ),

        setVel==StringEn.farmerLabTesting||setVel==StringEn.centerLabTesting?Container():
        Positioned(
          left: position.dx,
          top: position.dy,
          child:GestureDetector(
              onPanUpdate: (details) {

                // setState(() {
                //   position = Offset(position.dx + details.delta.dx, position.dy + details.delta.dy);
                // });
                _updateOffset(position + details.delta);
              },
              child: FloatingActionButton(
                  backgroundColor: CommonColor.THEME_COLOR,
                  child: const Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white ,
                  ),
                  onPressed: () async {
                    if(selectedSessionCode!="") {
                      FocusScope.of(context)
                          .requestFocus(FocusNode());
                      if (selectedVendorId != "") {
                        editedItemIndex = null;
                        goToAddOrEditItem(null,from_date);
                      } else {
                        // CommonWidget.errorDialog(context,
                        //     "Select Sale Ledger and Party !");
                        goToAddOrEditItem(null,from_date);
                      }
                    }
                    else{
                      var snackBar =
                      SnackBar(content: Text("${ApplicationLocalizations.of(context).translate("select_all_field")}"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  })
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  /* Widget for navigate to next screen button  */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        setVel==StringEn.farmerLabTesting||setVel==StringEn.centerLabTesting?Container():
        Container(
          width: SizeConfig.halfscreenWidth,
          padding: EdgeInsets.only(top: 0, bottom: 0),
          decoration: BoxDecoration(
            // color:  CommonColor.DARK_BLUE,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${ApplicationLocalizations.of(context)!
                        .translate("entry")!} : ${ListMenu.length} ",
                    style:
                    item_regular_textStyle_small.copyWith(color: Colors.grey),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    "${ApplicationLocalizations.of(context)!
                        .translate("ltr")!} : $totalLtr  ",
                    style:item_regular_textStyle_small.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [

                  Text(
                    "${ApplicationLocalizations.of(context)!
                        .translate("fat")!} : ${avgFAT} ",
                    style:
                    item_regular_textStyle_small.copyWith(color: Colors.grey),
                  ),
                  SizedBox(width: 5,),

                  Text(
                    "${ApplicationLocalizations.of(context)!
                        .translate("snf")!} : ${avgSNF} ",
                    style:
                    item_regular_textStyle_small.copyWith(color: Colors.grey),
                  ),

                ],
              ),

              SizedBox(
                height: 4,
              ),
              Text(
                "${CommonWidget.getCurrencyFormat(double.parse(TotalAmount))}",
                style: item_heading_textStyle,
              ),
            ],
          ),
        ),
        /* showButton==true ?GestureDetector(
          onTap: () {

            if (selectedSession == "") {
              var snackBar =
              SnackBar(content: Text('Select Session!'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else
            if (ListMenu.length == 0) {
              var snackBar =
              SnackBar(content: Text("${ApplicationLocalizations.of(context)!
                  .translate("add_atleast_one_item")!} "));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (
            selectedSession != " " &&
                ListMenu.length > 0) {
              if (mounted) {
                setState(() {
                  showButton = false;
                });
              }

              callPostMilkCollection();


            }
          },
          onDoubleTap: () {},
          child: Container(
            width: SizeConfig.halfscreenWidth,
            height: 50,
            decoration: BoxDecoration(
              color: disableColor == true
                  ? CommonColor.THEME_COLOR.withOpacity(.5)
                  : CommonColor.THEME_COLOR,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: parentWidth * .005),
                  child: Text(
                    ApplicationLocalizations.of(context)!
                        .translate("save")!,
                    style: page_heading_textStyle,
                  ),
                ),
              ],
            ),
          ),
        ):Container(),*/
      ],
    );
  }

  Widget getAllFields(double parentHeight, double parentWidth) {
    return isLoaderShow
        ? Container()
        : ListView(
      shrinkWrap: true,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.only(top: parentHeight * .01),
          child: Container(
            child: Form(
              child: Column(
                children: [
                  InvoiceInfo(),
                  SizedBox(
                    height: 5,
                  ),
                  getAddSearchLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                  SizedBox(height: 5,),
                  getWorkingUnderLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                  SizedBox(
                    height: 10,
                  ),
                  ListMenu.length > 0
                      ? get_ListMenu_layout(SizeConfig.screenHeight,
                      SizeConfig.screenWidth)
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container InvoiceInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(
        bottom: 10,
        left: 5,
        right: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  width: SizeConfig.halfscreenWidth,
                  child: getFromDate()),
              Container(alignment: Alignment.center,width: 40,child: Text("To",textAlign: TextAlign.center,style: item_heading_textStyle.copyWith(fontWeight: FontWeight.w600),),),

              Expanded(child: geToDate())
              // )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Expanded(child: Padding(
              //   padding:  EdgeInsets.only(top: 0),
              //   child: getPurchaseDateLayout(),
              // )),
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.only(top: 0 ,left: 0),
                  child:getSeesionLayout(SizeConfig.screenHeight, SizeConfig.halfscreenWidth),
                ),
              )
            ],
          ),
          SizedBox(height: 5,),



        ],
      ),
    );
  }

  //franchisee name
  Widget getAddSearchLayout(double parentHeight, double parentWidth) {

    return CommonDropdown(
      apiUrl:ApiConstants().ledger+"?Group_ID=${widget.route_type}&Route_Code=null&",
      titleIndicator: true,
      ledgerName:selectedVendorName,
      franchiseeName: selectedVendorName,
      franchisee: selectedVendorName.isNotEmpty ? "edit" : "",
      readOnly: true,
      nameField: "Name",
      idField: "ID",
      title:  ApplicationLocalizations.of(context)!.translate("party")!,
      callback: (item)async{
        print(item);
        if(item==""||item ==null){
          setState(() {
            showButton = true;
            selectedVendorName ="";
            selectedVendorId = "";
            ListMenu=[];
          });
        }
        else if(item!="") {
          setState(() {
            showButton = true;
            selectedVendorName = item['Name']!;
            selectedVendorId = item['ID']!;
            ListMenu=[];
          });
        }
        await _getMilkCollection(1);

      },
    );


  }

  /* Widget to get Franchisee Name Layout */

  Widget getWorkingUnderLayout(double parentHeight, double parentWidth) {
    return CommonDropdown(
      apiUrl:ApiConstants().working_under + "?",
      titleIndicator: true,
      ledgerName:selectedWorkingUnderName,
      franchiseeName: selectedWorkingUnderName,
      franchisee: selectedWorkingUnderName.isNotEmpty ? "edit" : "",
      readOnly: true,
      nameField: "Code",
      idField: "Code",
      title:  ApplicationLocalizations.of(context)!.translate("working_under")!,
      callback: (item)async{
        print(item);
        if(item==""||item ==null){
          setState(() {
            showButton = true;
            selectedWorkingUnderName ="";
            selectedWorkingUnderId = "";
            ListMenu=[];
          });
        }
        else if(item!="") {
          setState(() {
            showButton = true;
            selectedWorkingUnderName = item['Code']!;
            selectedWorkingUnderId = item['Code']!;
            ListMenu=[];

          });
        }
        _getMilkCollection(1);
      },
    );
  }

  /* Widget to get add Invoice date Layout */
  // Widget getPurchaseDateLayout() {
  //   return GetDateLayout(
  //       titleIndicator: true,
  //       title: ApplicationLocalizations.of(context)!.translate("date")!,
  //       callback: (date)async {
  //         setState(() {
  //           invoiceDate = date!;
  //           ListMenu = [];
  //         });
  //
  //         await _getMilkCollection(1);
  //
  //       },
  //       applicablefrom: invoiceDate);
  // }
  /* Widget to_date get add Invoice date Layout */
  Widget getFromDate(){
    return GetDateLayout(
        titleIndicator: false,
        title:  ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            from_date=date!;
          });
          _getMilkCollection(1);
        },
        applicablefrom: from_date
    );
  }

  Widget geToDate(){
    return GetDateLayout(

        titleIndicator: false,
        title:  ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            to_date=date!;
          });
          _getMilkCollection(1);
        },
        applicablefrom: to_date
    );
  }


  /* Widget to get Franchisee Name Layout */
  Widget getSeesionLayout(double parentHeight, double parentWidth) {
    return  CommonDropdown(
      mandatory: true,
      apiUrl: ApiConstants().session+"?",
      nameField:"Name",
      idField:"Code",
      titleIndicator: true,
      ledgerName: selectedSession,
      franchiseeName:  selectedSession,
      franchisee: selectedSession!=null?"edit":"",
      readOnly: true,
      title: ApplicationLocalizations.of(context)!.translate("session")!,
      callback: (item)async {
        print("################## ${item}");
        if(item==""||item==null){
          setState(() {
            selectedSession = "";
            selectedSessionCode ="";
            position = Offset(SizeConfig.screenWidth * 0.75, SizeConfig.screenHeight * 0.75);
          });
        }
        if(item!="") {
          setState(() {
            showButton = true;
            selectedSession = item['Name']!;
            selectedSessionCode = item['Code'];
            position = Offset(SizeConfig.screenWidth * 0.75, SizeConfig.screenHeight * 0.75);
          });
        }
        await _getMilkCollection(1);
        print("################## ${selectedSession}");

      },
    );


  }

  Widget get_ListMenu_layout(double parentHeight, double parentWidth) {
    print("kjdfjffjfj  ${ListMenu.length}");
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: ListMenu.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {
              setState(() {
                editedItemIndex = index;
              });
              // if (widget.readOnly == false) {
              // } else {
              //   FocusScope.of(context).requestFocus(FocusNode());
              //   if (context != null) {
              //   }
              // }
              goToAddOrEditItem(ListMenu[index],ListMenu[index]['Date']);

            },
            child:  Card(
              color: CommonColor.WHITE_COLOR,
              child: Column(
                children: [
                  ListTile(
                    // titleAlignment: ListTileTitleAlignment.threeLine,
                    // leading:
                    title:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListMenu[index][
                        'Date'] ==
                            null
                            ? Container()
                            : Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.calendar_today,size: 20,),
                              SizedBox(width: 5,),
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Text(
                                    "${DateFormat("dd-MM-yyyy").format(DateTime.parse(ListMenu[index]['Date'].toString()))}",
                                    style: item_heading_textStyle
                                        .copyWith(
                                        fontSize:
                                        18)),
                              ),


                            ],
                          ),
                        ),
                        SizedBox(width: 20,),

                        Text("${ApplicationLocalizations.of(context).translate("transport_no")}: ${ListMenu[index]['Transport_No']}",style: subHeading_withBold.copyWith(fontSize: 16,color: Colors.purple),),



                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5,),
                        Divider(height: 1,),
                        SizedBox(height: 5,),

                        Row(
                          children: [

                            CircleAvatar(
                              //radius: 15,
                              backgroundColor: CommonColor.THEME_COLOR,
                              child: Text("${index + 1}", style: TextStyle(color: Colors.white,
                                /*fontSize: 12.0,*/)),
                            ),

                            SizedBox(width: 5,),
                            Expanded(

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text( "${ListMenu[index]['Code_Name']}", style: TextStyle(fontSize: 20,fontWeight:FontWeight.w600)),
                                    ListMenu[index]['Milk_Type']==null?Text(""):Text( "Type : ${ListMenu[index]['Milk_Type']}", style: item_regular_textStyle.copyWith(fontSize: 18)),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        // if (product['Unit'].isNotEmpty) Text(product['Unit']),
                                        ListMenu[index]['Qty_In_KG']!=null? Container(
                                            alignment:
                                            Alignment.centerLeft,
                                            child: Text( "KG : ${CommonWidget.getCurrencyFormatWithoutSymbol((double.parse(ListMenu[index]['Qty_In_KG'].toString())))}",
                                              overflow: TextOverflow.clip,
                                              style: item_heading_textStyle
                                                  .copyWith(
                                                  color:
                                                  Colors.grey),
                                            )):Container(),
                                        SizedBox(width: 10,),
                                        ListMenu[index]['Qty_In_Liter']!=null? Container(
                                            alignment:
                                            Alignment.centerLeft,
                                            child: Text( "${ApplicationLocalizations.of(context).translate("ltr")} : ${CommonWidget.getCurrencyFormatWithoutSymbol((double.parse(ListMenu[index]['Qty_In_Liter'].toString())))}",
                                              overflow: TextOverflow.clip,
                                              style: item_heading_textStyle
                                                  .copyWith(
                                                  color:
                                                  Colors.grey),
                                            )):Container(),

                                      ],
                                    ),

                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        // if (product['Unit'].isNotEmpty) Text(product['Unit']),
                                        ListMenu[index]['Fat']!=null? Container(
                                            alignment:
                                            Alignment.centerLeft,
                                            child: Text( "${ApplicationLocalizations.of(context).translate("fat")} : ${double.parse(ListMenu[index]['Fat'].toString()).toStringAsFixed(2)}",
                                              overflow: TextOverflow.clip,
                                              style: item_heading_textStyle
                                                  .copyWith(
                                                  color:
                                                  Colors.grey),
                                            )):Container(),
                                        SizedBox(width: 10,),

                                        ListMenu[index]['SNF']!=null? Container(
                                            alignment:
                                            Alignment.centerLeft,
                                            child: Text( "SNF : ${double.parse(ListMenu[index]['SNF'].toString()).toStringAsFixed(2)}",
                                              overflow: TextOverflow.clip,
                                              style: item_heading_textStyle
                                                  .copyWith(
                                                  color:
                                                  Colors.grey),
                                            )):Container(),
                                        SizedBox(width: 10,),
                                        // ListMenu[index]['Rate']!=null? Container(
                                        //     alignment:
                                        //     Alignment.centerLeft,
                                        //     child: Text( "Rate : "+
                                        //         CommonWidget.getCurrencyFormat(
                                        //             double.parse(ListMenu[
                                        //             index]
                                        //             [
                                        //             'Rate']
                                        //                 .toString()))
                                        //             .toString() ,
                                        //       // "${(double.parse(ListMenu[index]['Quantity'].toString())).toStringAsFixed(2)}${ListMenu[index]['Unit']}"
                                        //       overflow: TextOverflow.clip,
                                        //       style: item_heading_textStyle
                                        //           .copyWith(
                                        //           color:
                                        //           Colors.grey),
                                        //     )):Container(),

                                      ],
                                    ),
                                    ListMenu[index]['Rate']!=null? Container(
                                        alignment:
                                        Alignment.centerLeft,
                                        child: Text( "Rate : "+
                                            CommonWidget.getCurrencyFormat(
                                                double.parse(ListMenu[
                                                index]
                                                [
                                                'Rate']
                                                    .toString()))
                                                .toString() ,
                                          // "${(double.parse(ListMenu[index]['Quantity'].toString())).toStringAsFixed(2)}${ListMenu[index]['Unit']}"
                                          overflow: TextOverflow.clip,
                                          style: item_heading_textStyle
                                              .copyWith(
                                              color:
                                              Colors.grey),
                                        )):Container(),
                                  ],
                                )),
                          ],
                        ),


                        SizedBox(height: 5,),
                        Divider(height: 1,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // if (product['Unit'].isNotEmpty) Text(product['Unit']),



                            ListMenu[index]['Amount']!=null? Container(
                                alignment:
                                Alignment.centerLeft,
                                child: Text("${ApplicationLocalizations.of(context).translate("amt")} : "+
                                    CommonWidget.getCurrencyFormat(
                                        double.parse(ListMenu[
                                        index]
                                        [
                                        'Amount']
                                            .toString()))
                                        .toString() ,
                                  // "${(double.parse(ListMenu[index]['Quantity'].toString())).toStringAsFixed(2)}${ListMenu[index]['Unit']}"
                                  overflow: TextOverflow.clip,
                                  style: item_heading_textStyle
                                      .copyWith(
                                      color:
                                      Colors.blue),
                                )):Container(),
                            Container(
                                width: parentWidth * .1,
                                // height: parentHeight*.1,
                                color: Colors.transparent,
                                child: DeleteDialogLayout(
                                    callback: (response) async {
                                      if (response == "yes") {
                                        if( widget.setVal==StringEn.farmerLabTesting||widget.setVal==StringEn.centerLabTesting){
                                          callPutMilkCollection(  ListMenu[index]['Code']
                                              .toString(),  ListMenu[index]['Milk_Type']
                                              .toString(),  ListMenu[index]['Date'].toString(),
                                              ListMenu[index]['Transport_No'],ListMenu[index]['Seq_No']);
                                        }else{
                                          await callDeleteMilkCollection(
                                            ListMenu[index]['Transport_No'],
                                            ListMenu[index]['Code']
                                                .toString(),
                                            ListMenu[index]['Seq_No'],
                                            index,
                                            ListMenu[index]['Date'],
                                          );}


                                      }
                                    }))
                          ],
                        ),

                      ],
                    ),
                    /* trailing:   Container(
                      width: parentWidth * .1,
                      // height: parentHeight*.1,
                      color: Colors.transparent,
                      child: DeleteDialogLayout(
                          callback: (response) async {
                            if (response == "yes") {

                              setState(() {
                                ListMenu.removeAt(index);
                                ListMenu=ListMenu;
                                showButton=true;
                              });
                              await calculateTotalAmt();
                            }
                          })),*/

                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    child: Divider(height: 1,),
                  )
                ],
              ),
            )
          // Card(
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Stack(
          //           alignment: Alignment.topRight,
          //           children: [
          //             Container(
          //                 margin: const EdgeInsets.only(
          //                     top: 10, left: 10, right: 10, bottom: 10),
          //                 child: Row(
          //                   children: [
          //
          //                     Expanded(
          //                       child: Container(
          //                         padding: EdgeInsets.only(left: 10),
          //                         width: parentWidth * .70,
          //                         //  height: parentHeight*.1,
          //                         child: Column(
          //                           mainAxisAlignment:
          //                           MainAxisAlignment.start,
          //                           crossAxisAlignment:
          //                           CrossAxisAlignment.start,
          //                           children: [
          //
          //                             // ${index + 1}
          //                             Row(
          //                               crossAxisAlignment: CrossAxisAlignment.start,
          //                               children: [
          //                                 Expanded(
          //                                   child: Container(
          //                                     width: SizeConfig.screenWidth*0.8,
          //                                     child: Row(
          //                                       crossAxisAlignment: CrossAxisAlignment.start,
          //                                       children: [
          //                                         Text(
          //                                           "${index + 1}) ",
          //                                           textAlign: TextAlign.center,
          //                                           style:  item_heading_textStyle.copyWith(
          //                                               fontWeight: FontWeight.bold,
          //                                               color: Colors.purple,fontSize: 24
          //                                           ),
          //                                         ),
          //                                         SizedBox(width: 5,),
          //
          //                                         Container(
          //                                           width: SizeConfig.screenWidth*0.65,
          //                                           child: Text(
          //                                             "${ListMenu[index]['Code_Name']}",
          //                                             style: item_heading_textStyle.copyWith(
          //                                                 fontWeight: FontWeight.bold
          //                                             ),
          //                                           ),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //
          //
          //                             SizedBox(
          //                               height: 5,
          //                             ),
          //                             Text(
          //                                 "Milk  : ${ListMenu[index]['Milk_Type']}",
          //                                 style: item_heading_textStyle
          //                             ),
          //                             SizedBox(
          //                               height: 5,
          //                             ),
          //                             setVel==StringEn.farmerLabTesting||setVel==StringEn.centerLabTesting?Container():   Row(
          //                               children: [
          //                                 Container(
          //                                     alignment:
          //                                     Alignment.centerRight,
          //                                     child: Text(
          //                                       "KG : ${ CommonWidget.getCurrencyFormatWithoutSymbol((double.parse(ListMenu[index]['Qty_In_KG'].toString())))} ",
          //                                       // "${(double.parse(ListMenu[index]['Quantity'].toString())).toStringAsFixed(2)}${ListMenu[index]['Unit']}"
          //                                       overflow: TextOverflow.clip,
          //                                       style: item_heading_textStyle
          //                                           .copyWith(),
          //                                     )),
          //                                 SizedBox(width: 10,),
          //                                 Container(
          //                                   // alignment: Alignment.centerRight,
          //                                   width:
          //                                   SizeConfig.halfscreenWidth -
          //                                       50,
          //                                   child: Text(
          //                                     "${ApplicationLocalizations.of(context).translate("ltr")} :  ${ CommonWidget.getCurrencyFormatWithoutSymbol((double.parse(ListMenu[index]['Qty_In_Liter'].toString())))} ",
          //                                     overflow: TextOverflow.ellipsis,
          //                                     style: item_heading_textStyle
          //                                         .copyWith(),
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                             SizedBox(
          //                               height: 5,
          //                             ),
          //                             Row(
          //                               children: [
          //                                 ListMenu[index]['Fat']==null?Container():  Text(
          //                                   "FAT : ${double.parse(ListMenu[index]['Fat'].toString()).toStringAsFixed(2)}",
          //                                   style: item_heading_textStyle,
          //                                 ),
          //                                 SizedBox(
          //                                   width: 7,
          //                                 ),
          //
          //                                 ListMenu[index]['SNF']==null?Container():   Text(
          //                                   "SNF : ${double.parse(ListMenu[index]['SNF'].toString()).toStringAsFixed(2)}",
          //                                   style: item_heading_textStyle,
          //                                 ),
          //                                 SizedBox(
          //                                   width: 7,
          //                                 ),
          //                                // widget.setVal!=StringEn.farmerLabTesting||widget.setVal!=StringEn.centerLabTesting?Container():
          //                                 widget.setVal==StringEn.farmerLabTesting||widget.setVal==StringEn.centerLabTesting?  ListMenu[index]['Lacto']==null?Container():   Text(
          //                                   "CLR : ${double.parse(ListMenu[index]['Lacto'].toString()).toStringAsFixed(2)}",
          //                                   style: item_heading_textStyle,
          //                                 ):Container(),
          //
          //                                 widget.setVal==StringEn.farmerLabTesting||widget.setVal==StringEn.centerLabTesting?Container():
          //                                 ListMenu[
          //                                 index]
          //                                 [
          //                                 'Rate']!=null?  Container(
          //                                     alignment:
          //                                     Alignment.centerRight,
          //                                     child: Text("Rate : "+
          //                                         CommonWidget.getCurrencyFormat(
          //                                             double.parse(ListMenu[index]
          //                                             ['Rate'].toString())),
          //                                       // "${(double.parse(ListMenu[index]['Quantity'].toString())).toStringAsFixed(2)}${ListMenu[index]['Unit']}"
          //                                       overflow: TextOverflow.clip,
          //                                       style: item_heading_textStyle
          //                                           .copyWith(
          //                                           color:
          //                                           Colors.blue),
          //                                     )):Container(),
          //                               ],
          //                             ),
          //                             SizedBox(
          //                               height: 5,
          //                             ),
          //                             widget.setVal==StringEn.farmerLabTesting||widget.setVal==StringEn.centerLabTesting?Container():
          //                             Row(
          //                               mainAxisAlignment:
          //                               MainAxisAlignment.spaceBetween,
          //                               children: [
          //
          //                                 ListMenu[
          //                                 index]
          //                                 [
          //                                 'Amount']!=null?Container(
          //                                     alignment:
          //                                     Alignment.centerRight,
          //                                     child: Text("${ApplicationLocalizations.of(context).translate("amt")} : "+
          //                                         CommonWidget.getCurrencyFormat(
          //                                             double.parse(ListMenu[index]['Amount'].toString()))
          //                                             .toString() ,
          //                                       // "${(double.parse(ListMenu[index]['Quantity'].toString())).toStringAsFixed(2)}${ListMenu[index]['Unit']}"
          //                                       overflow: TextOverflow.clip,
          //                                       style: item_heading_textStyle
          //                                           .copyWith(
          //                                           color:
          //                                           Colors.blue),
          //                                     )):Container(),
          //                               ],
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ),
          //
          //
          //                     /* SizedBox(
          //                       height: 5,
          //                     ),
          //
          //
          //                     Container(
          //                         width: parentWidth * .1,
          //                         // height: parentHeight*.1,
          //                         color: Colors.transparent,
          //                         child: DeleteDialogLayout(
          //                             callback: (response) async {
          //                               if (response == "yes") {
          //
          //                                 setState(() {
          //                                   ListMenu.removeAt(index);
          //                                   ListMenu=ListMenu;
          //                                   showButton=true;
          //                                 });
          //                                 calculateTotalAmt();
          //                               }
          //                             })),*/
          //                   ],
          //                 )),
          //             Padding(
          //               padding:  EdgeInsets.only(bottom: 5),
          //               child: Container(
          //                   width: parentWidth * .1,
          //                   // height: parentHeight*.1,
          //                   color: Colors.transparent,
          //                   child: DeleteDialogLayout(
          //                       callback: (response) async {
          //                         if (response == "yes") {
          //                           if( widget.setVal==StringEn.farmerLabTesting||widget.setVal==StringEn.centerLabTesting){
          //                             callPutMilkCollection(  ListMenu[index]['Code']
          //                                 .toString(),  ListMenu[index]['Milk_Type']
          //                                 .toString(),  ListMenu[index]['Date'].toString(),
          //                                 ListMenu[index]['Transport_No'],ListMenu[index]['Seq_No']);
          //                           }else{
          //                           await callDeleteMilkCollection(
          //                             ListMenu[index]['Transport_No'],
          //                             ListMenu[index]['Code']
          //                                 .toString(),
          //                             ListMenu[index]['Seq_No'],
          //                             index,
          //                             ListMenu[index]['Date'],
          //                           );}
          //
          //
          //                         }
          //                       })),
          //             ),
          //           ],
          //         ),
          //       )
          //     ],
          //   ),
          // ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 5,
        );
      },
    );
  }

  var isLoader=true;

  Future<Object?> goToAddOrEditItem(product,invoiceDate) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AddOrEditMilkCollection(
                  mListener: this,
                  setVal: setVel,
                  title: title,
                  editproduct: product,
                  date: invoiceDate.toString(),
                  route_type:route_type,
                  session: selectedSessionCode,
                  sessionName:selectedSession
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation2, animation1) {
          throw Exception('${ApplicationLocalizations.of(context).translate("no_return_pagebuilder")}');
        });
  }

  @override
  AddOrEditMilkCollectionDetail(item) async{
    // TODO: implement AddOrEditOrderDetail
    await _getMilkCollection(1);
  }

  calculateTotalAmt() async {
    setState(() {
      TotalAmount = "0.00";
    });
    var total = 0.00;
    for (var item in ListMenu) {
      if(item['Amount']!=null && item['Amount']!="" && item['Amount']!="null") {
        total = total +double.parse( item['Amount'].toString());
      }
      // print(item['Amount']);
    }
    // var amt = double.parse((total.toString()).substring((total.toString()).length - 3, (total.toString()).length)).toStringAsFixed(3);
    double amt = total % 1;

    print("%%%%%%%%%%%%%%%%%%%%% $amt");
    if (double.parse((total.toString()).substring((total.toString()).length - 3, (total.toString()).length)) == 0.0) {
      var total1 = (total).floorToDouble();
      setState(() {
        TotalAmount = total1.toStringAsFixed(2);
      });
    } else {
      if ((amt) < 0.50) {
        print("Here");
        var total1 = (total).floorToDouble();
        setState(() {
          TotalAmount = total1.toStringAsFixed(2);
        });
      } else if ((amt) >= 0.50) {
        setState(() {
          TotalAmount = (total.ceilToDouble()).toStringAsFixed(2);
        });
      }
    }
    await CalculateAvgfat();
    await CalculateAvgSnf();
    await CalculateLtr();
  }

  CalculateAvgSnf()async{
    var avgsnf=0.00;
    var kgsum=0.00;
    for (var item in ListMenu) {
      if(item['SNF']!=null && item['SNF']!="")
        avgsnf = avgsnf + (double.parse(item['SNF'].toString())*double.parse(item['Qty_In_KG'].toString()));
      kgsum=kgsum+double.parse(item['Qty_In_KG'].toString());
      // print(item['Amount']);
    }

    setState(() {
      avgSNF=(avgsnf/kgsum).toStringAsFixed(2);
    });

  }

  CalculateAvgfat()async{
    var avgfat=0.00;
    var kgsum=0.00;
    for (var item in ListMenu) {
      if(item['Fat']!=null && item['Fat']!="")
        avgfat = avgfat + (double.parse(item['Fat'].toString())*double.parse(item['Qty_In_KG'].toString()));
      kgsum=kgsum+double.parse(item['Qty_In_KG'].toString());
      // print(item['Amount']);
    }

    setState(() {
      avgFAT=(avgfat/kgsum).toStringAsFixed(2);
    });


  }

  CalculateLtr()async{
    var qtyLtr=0.00;
    for (var item in ListMenu) {
      if(item['Qty_In_Liter']!=null && item['Qty_In_Liter']!="")
        qtyLtr = qtyLtr +double.parse(item['Qty_In_Liter'].toString());
      // print(item['Amount']);
    }

    setState(() {
      totalLtr=qtyLtr.toStringAsFixed(2);
    });
  }
  int page = 1;
  bool isPagination = true;
  _getMilkCollection(int page) async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl = await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        TokenRequestModel model =
        TokenRequestModel(token: sessionToken, page: page.toString());
        String apiUrl = "${baseurl}${ApiConstants().milk_collection}?Company_ID=$companyId&Session=${selectedSessionCode}&Center_Code=${selectedVendorId}&Route_Type=$route_type&Working_Under=${selectedWorkingUnderId}&From_Date=${DateFormat('yyyy-MM-dd').format(from_date)}&To_Date=${DateFormat('yyyy-MM-dd').format(to_date)}";
        // "&Party_ID=${selectedVendorId}";
        apiRequestHelper.callAPIsForGetAPI(context,apiUrl, model.toJson(), "",
            onSuccess: (data)async {
              print(data);
              setState(() {
                isLoaderShow=false;
                if(data!=null){
                  TotalAmount="0.00";
                  TotalInvoice="0";
                  List<dynamic> _arrList = [];
                  TotalInvoice=data['Voucher_Total_Count']!=null?data['Voucher_Total_Count'].toString():"0";
                  TotalAmount=data['Voucher_Total_Amount']!=null?data['Voucher_Total_Amount'].toString():"0";
                  print("vgnngv vg    $TotalInvoice   $TotalAmount");
                  _arrList=data['Vouchers'];
                  print("orderDate    $data");
                  if (_arrList.length > 50) {
                    if (mounted) {
                      setState(() {
                        isPagination = true;
                      });
                    }
                  }
                  if (page == 1) {
                    setDataToList(_arrList);
                  } else {
                    setMoreDataToList(_arrList);
                  }
                  // calculateTotalAmt();
                }else{
                  //isApiCall=true;
                }
              });
              print("  LedgerLedger  $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              print("Here2=> $e");
              setState(() {
                isLoaderShow = false;
              });
              var val = CommonWidget.errorDialog(context, e);
              print("YES");
              if (val == "yes") {
                print("Retry");
              }
            }, sessionExpire: (e) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.gotoLoginScreen(context);
            });
      });
    } else {
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  setDataToList(List<dynamic> _list) {
    if (ListMenu.isNotEmpty) ListMenu.clear();
    if (mounted) {
      setState(() {
        ListMenu.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        ListMenu.addAll(_list);
      });
    }
  }
  _scrollListener() {
    if (_scrollController.position.pixels==_scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        _getMilkCollection(page);
      }
    }
  }

  //FUNC: REFRESH LIST
  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;
    await _getMilkCollection(page);
  }
  callDeleteMilkCollection(int removeId,String party_code,int seq,int index,invoiceDate) async {
    String uid = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    String creatorName = await AppPreferences.getUId();
    String device = await AppPreferences.getDeviceId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        var model={
          "Date":DateFormat('yyyy-MM-dd').format(DateTime.parse(invoiceDate.toString())),
          "Session":selectedSessionCode.toString(),
          "Transport_No": removeId.toString(),
          "Center_Code": party_code.toString() ,
          "Seq_No": seq.toString(),
          "Modifier": creatorName,
          "Modifier_Machine": deviceId
        };
        print("MODEL $model");
        String apiUrl = baseurl + ApiConstants().milk_collection+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForDeleteAPI(context,apiUrl, model, "",
            onSuccess:(data)async{
              // setState(() {
              //   isLoaderShow=false;
              //   ListMenu.removeAt(index);
              // });
              // if(ListMenu.length==0){
              //   setState(() {
              //     TotalAmount="0.00";
              //   });
              // }
              setState(() {
                ListMenu=[];
              });
              await _getMilkCollection(1);
              print("  LedgerLedger  $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());
              // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
              //  widget.mListener.loaderShow(false);
              //  Navigator.of(context, rootNavigator: true).pop();
            }, onException: (e) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, e.toString());

            },sessionExpire: (e) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.gotoLoginScreen(context);
              // widget.mListener.loaderShow(false);
            });
      });
    }else{
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  callPostMilkCollection() async {
    String creatorName = await AppPreferences.getUId();
    String device = await AppPreferences.getDeviceId();
    String baseurl = await AppPreferences.getDomainLink();
    String companyId = await AppPreferences.getCompanyId();

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });

        PostMilkCollection model = PostMilkCollection(
          date: DateFormat('yyyy-MM-dd').format(from_date),
          session: "M",//selectedSession
          operatorCode: creatorName,
          modifierMachine: device,
          data: ListMenu.toList(),
        );

        String apiUrl = baseurl + ApiConstants().milk_collection+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForDynamicPI(context,apiUrl, model.toJson(), "",
            onSuccess: (data) async {
              print("  ITEM  $data ");
              setState(() {
                isLoaderShow = true;
                ListMenu = [];


              });
            }, onFailure: (error) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.errorDialog(context, e.toString());
            }, sessionExpire: (e) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.gotoLoginScreen(context);
              // widget.mListener.loaderShow(false);
            });
      });
    } else {
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  callPutMilkCollection(String selectedPartyId , String selectedMilkType,String dateNew,int TransportNo,int SeqNo) async {
    String baseurl = await AppPreferences.getDomainLink();
    String companyId = await AppPreferences.getCompanyId();
    String creatorName = await AppPreferences.getUId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        var model={
          "Seq_No": SeqNo,
          "Transport_No":TransportNo,
          "Session": selectedSessionCode,
          "Date":DateFormat('yyyy-MM-dd').format(DateTime.parse(dateNew.toString())),
          "Code":selectedPartyId,
          "Milk_Type": selectedMilkType,
          "Qty_In_KG":null,
          "Qty_In_Liter":null,
          "Fat": null,
          "Lacto": null,
          "SNF": null,
          "Rate": null,
          "Amount":null,
          "Modifier": creatorName,
          "Modifier_Machine": deviceId
        };

        String apiUrl = baseurl + ApiConstants().milk_collection+"?Company_ID=$companyId";
        print("newwwwwwww $apiUrl \n $model");
        apiRequestHelper.callAPIsForPutAPI(context,apiUrl, model, "",
            onSuccess: (data) async {
              print("  ITEM  $data ");
              setState(() {
                isLoaderShow = true;
              });
              await _getMilkCollection(1);
            }, onFailure: (error) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.errorDialog(context, e.toString());
            }, sessionExpire: (e) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.gotoLoginScreen(context);
              // widget.mListener.loaderShow(false);
            });
      });
    } else {
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }
}

abstract class CreateMilkCollectionInterface {
  backToList(DateTime updateDate);
}
