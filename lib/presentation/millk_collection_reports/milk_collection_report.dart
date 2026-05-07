import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../core/localss/api_data_fetch_localization.dart';

import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import '../../../../../core/size_config.dart';
import '../../../../../data/request_helper.dart';
import '../../../../common_widget/common.dart';
import '../../../../common_widget/get_date_layout.dart';
import '../../../../core/app_preferance.dart';
import '../../../../core/colors.dart';
import '../../../../core/common_style.dart';
import '../../../../core/internet_check.dart';
import '../../../../core/localss/application_localizations.dart';
import '../../../../core/size_config.dart';
import '../../../../core/string_en.dart';
import '../../../../data/commonRequest/get_toakn_request.dart';
import '../../../../data/constant.dart';
import 'dart:io';
import '../../../../searchable_Dropdowns/common_dropdown.dart';
import '../../../../../../common_widget/signleLine_TexformField.dart';
import '../../common_widget/pdf_view_for_post_model.dart';
import '../../common_widget/singleLine_TextformField_without_double.dart';
import '../../searchable_Dropdowns/multi_selection_dropdown.dart';
import '../common_widget/custom_appbar.dart';

class MilkCollectionReportActivity extends StatefulWidget {
  final  viewWorkDDate;
  final  viewWorkDVisible;
  final String logoImage;
  final String routType;
  final String reportType;
  final ledgerCode;
  final ledgerName;
  final String title;
  final String setText;
  final String partyCode;
  final fromDate;
  final toDate;
  final formId;
  const MilkCollectionReportActivity({super.key, required this.title, required this.setText, this.fromDate, this.toDate,this.ledgerCode, this.ledgerName, required this.logoImage, this.viewWorkDDate, this.viewWorkDVisible, this.formId, required this.routType, required this.reportType, required this.partyCode});

  @override
  State<MilkCollectionReportActivity> createState() => _OutstandingState();
}

class _OutstandingState extends State<MilkCollectionReportActivity>   {
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();

  bool isLoaderShow=false;

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  List<dynamic> outstanding_list=[];

  TextEditingController remark = TextEditingController();
  FocusNode remarkFocus = FocusNode();
  TextEditingController fatFrom = TextEditingController();
  FocusNode fatFocusFrom = FocusNode();

  TextEditingController snfqtyFrom = TextEditingController();
  FocusNode snfFocusFrom = FocusNode();


  TextEditingController fatTo = TextEditingController();
  FocusNode fatFocusTo  = FocusNode();

  TextEditingController snfqtyTo  = TextEditingController();
  FocusNode snfFocusTo  = FocusNode();

  var selectedFromSession="";
  var selectedFromSessionCode="";

  var selectedToSession="";
  var selectedToSessionCode="";
  int page = 1;
  bool isPagination = true;
  final ScrollController _scrollController =  ScrollController();
  bool isApiCall=false;
  double minX = 30;
  double minY = 30;
  double maxX = SizeConfig.screenWidth*0.78;
  double maxY = SizeConfig.screenHeight*0.9;

  Offset position = Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.9);


  String selctedvendorName="";
  var selctedvendorId="";

  String opening="0.00";
  String closing="0.00";
  String closingAmtT="";
  String openingAmtT="";

  String TotalCR="0.00";
  String TotalDR="0.00";
  bool viewWorkDVisible=true;

  File? logo;
  String companyId='';

  String EmpNo = "";


  String selectedBranchName = "";
  String selectedBranchId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    print("${widget.reportType}");
    getVoucherType();
    getData();
    // setVal();
  }

  getData()async{
    companyId=await AppPreferences.getCompanyId();

    // EmpNo = await AppPreferences.getVendor();
    setState(() {
      // EmpNo = EmpNo;
      // partyName=widget.ledgerName;
    });
    from=widget.fromDate;
    to=widget.toDate;

    if(widget.ledgerCode!=""||widget.ledgerCode!=null){
      setState(() {
        // selctedvendorId=widget.ledgerCode!=null?widget.ledgerCode.toString():"";
        // selctedvendorName=widget.ledgerName;
      });
    }

  }

  _scrollListener() {
    if (_scrollController.position.pixels==_scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;

      }
    }
  }

  setDataToList(List<dynamic> _list) {
    if (outstanding_list.isNotEmpty) outstanding_list.clear();
    if (mounted) {
      setState(() {
        outstanding_list.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        outstanding_list.addAll(_list);
      });
    }
  }

  //FUNC: REFRESH LIST
  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      page=1;
    });
    isPagination = true;

  }
  String partyName="";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:   Stack(
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
                appBar: PreferredSize(
                    preferredSize: AppBar().preferredSize,
                    child:
                    CustomeAppBar(title:widget.title
                      ,dashbord: false, onPress: null,)
                  //     :
                  //
                  // CustomeAppBar(title: widget.route_type=="F"?
                  // ApplicationLocalizations.of(context)!.translate("farmer_deduction")!:
                  // ApplicationLocalizations.of(context)!.translate("center_deduction")!
                  //   ,dashbord: false, onPress: null,)

                ),
                body: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        //color: Colors.pink,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(bottom: 30),
                                child:
                                  Container(

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      getReportTypeLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                                      Row(
                                        children: [
                                          Expanded(child: getFromDate()),
                                          SizedBox(width: 10,),
                                     /*     Container(
                                            alignment: Alignment.center,
                                            width: 40,
                                            child: Text(ApplicationLocalizations.of(context).translate("to"),
                                              textAlign: TextAlign.center,
                                              style: item_heading_textStyle.copyWith(fontWeight: FontWeight.w600),
                                            ),
                                          ),*/
                                          Expanded(child: geToDate()),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      getMultiCenterTLayout(
                                        SizeConfig.screenHeight,
                                        SizeConfig.screenWidth,
                                      ),
                                      SizedBox(height: 10,),
                                      // Ledger Multi
                                      // getMultiCenterLayout(
                                      //   SizeConfig.screenHeight,
                                      //   SizeConfig.screenWidth,
                                      // ),
                                      // SizedBox(height: 10,),
                                      // Ledger Multi
                                      getMultiMilkTypeLayout(
                                        SizeConfig.screenHeight,
                                        SizeConfig.screenWidth,
                                      ),
                                      SizedBox(height: 10,),
                                      getMultiRouteLayout(
                                        SizeConfig.screenHeight,
                                        SizeConfig.screenWidth,
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Expanded(child: getFromSeesionLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),),
                                          SizedBox(width: 10,),
                                          Expanded(child: getToSeesionLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      getBillingDaysLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),

                                      SizedBox(height: 10,),  // Group Multi
                                      getMultiWorkingUnderLayout(
                                        SizeConfig.screenHeight,
                                        SizeConfig.screenWidth,
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Expanded(child: getFatQuantityFromLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),),
                                          SizedBox(width: 10,),
                                          Expanded(child: getFatQuantityToLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Expanded(child: getSnfQuantityFromLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),),
                                          SizedBox(width: 10,),
                                          Expanded(child: getSnfQuantityToLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      // Group Multi
                                      getMultiStateLayout(
                                        SizeConfig.screenHeight,
                                        SizeConfig.screenWidth,
                                      ),
                                      SizedBox(height: 10,),
                                      getRemark(),
                                      SizedBox(height: 20,),
                                      SizedBox(height: 100), // Button overlap टाळण्यासाठी
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            CommonWidget.getCommonPadding(SizeConfig.screenBottom, CommonColor.WHITE_COLOR),
                          ],
                        ),
                      ),
                    ),
                    Container(
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
                        height: SizeConfig.safeUsedHeight * .12,
                        child: getSaveAndFinishButtonLayout(
                            SizeConfig.screenHeight, SizeConfig.screenWidth)),
                  ],
                ),
              ),
            ),


            Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
          ],
        )
    );
  }

  getRemark(){
    return SingleLineEditableTextFormFieldWithoubleDouble(
        mandatory: false,
        validation: (value) {
          if (value!.isEmpty) {
            return "";
          }
          return null;
        },
        readOnly: true,
        controller: remark,
        focuscontroller: remarkFocus,
        focusnext: remarkFocus,
        title:  ApplicationLocalizations.of(context)!.translate("remark")!,
        callbackOnchage: (value) async {
          if(mounted){
            setState(() {
            //  showButton = true;
              // remark.text = value;
            });}
        },
        textInput: TextInputType.text,
        maxlines: 2,
        format:  FilteringTextInputFormatter.allow(RegExp(r'[0-9 a-z A-Z ]'))
    );
  }

  Widget getLedgerLayout(double parentHeight, double parentWidth) {
    return isLoaderShow?Container():  CommonDropdown(
      apiUrl: ApiConstants().getLedgerList+"?",
      nameField:"Name",
      idField:"ID",
      titleIndicator: true,
      ledgerName: selctedvendorName,
      franchiseeName:  selctedvendorName,
      franchisee: selctedvendorName!=null?"edit":"",
      readOnly: true,
      title: ApplicationLocalizations.of(context).translate("ledger"),
      callback: (item)async {
        if(item==""||item==null){
          setState(() {
            selctedvendorId="";
            selctedvendorName="";
          });
        }
        else {
          setState(() {
            selctedvendorId = item['ID'].toString();
            selctedvendorName = item['Name'].toString();
          });
          print("DSDsds$selctedvendorId");
        }

      },
    );}


  /* Widget to get Franchisee Name Layout */
  Widget getFromSeesionLayout(double parentHeight, double parentWidth) {
    return  CommonDropdown(
      mandatory: false,
      apiUrl: ApiConstants().session+"?",
      nameField:"Name",
      idField:"Code",
      titleIndicator: true,
      ledgerName: selectedFromSession,
      franchiseeName:  selectedFromSession,
      franchisee: selectedFromSession!=null?"edit":"",
      readOnly: true,
      title: "${ApplicationLocalizations.of(context).translate("from")} "+ApplicationLocalizations.of(context)!.translate("session")!,
      callback: (item)async {
        print("################## ${item}");
        if(item==""||item==null){
          setState(() {
            selectedFromSession = "";
            selectedFromSessionCode ="";
            position = Offset(SizeConfig.screenWidth * 0.75, SizeConfig.screenHeight * 0.75);
          });
        }
        if(item!="") {
          setState(() {
            selectedFromSession = item['Name']!;
            selectedFromSessionCode = item['Code'];
            position = Offset(SizeConfig.screenWidth * 0.75, SizeConfig.screenHeight * 0.75);
          });
        }
      },
    );


  }


  /* Widget to get Franchisee Name Layout */
  Widget getToSeesionLayout(double parentHeight, double parentWidth) {
    return  CommonDropdown(
      mandatory: false,
      apiUrl: ApiConstants().session+"?",
      nameField:"Name",
      idField:"Code",
      titleIndicator: true,
      ledgerName: selectedToSession,
      franchiseeName:  selectedToSession,
      franchisee: selectedToSession!=null?"edit":"",
      readOnly: true,
      title: "${ApplicationLocalizations.of(context).translate("to")} "+ApplicationLocalizations.of(context)!.translate("session")!,
      callback: (item)async {
        print("################## ${item}");
        if(item==""||item==null){
          setState(() {
            selectedToSession = "";
            selectedToSessionCode ="";
            position = Offset(SizeConfig.screenWidth * 0.75, SizeConfig.screenHeight * 0.75);
          });
        }
        if(item!="") {
          setState(() {
            selectedToSession = item['Name']!;
            selectedToSessionCode = item['Code'];
            position = Offset(SizeConfig.screenWidth * 0.75, SizeConfig.screenHeight * 0.75);
          });
        }
        print("################## ${selectedToSession}");

      },
    );


  }
  String reportTypeName="";
  var reportTypeId="";
  Widget getReportTypeLayout(double parentHeight, double parentWidth) {
    return   CommonDropdown(
      apiUrl: ApiConstants().reportType+"?Form_Name=${widget.reportType}&",
      nameField:"Name",
      idField:"ID",
      titleIndicator: true,
      ledgerName: reportTypeName,
      franchiseeName:  reportTypeName,
      franchisee: reportTypeName!=null?"edit":"",
      readOnly: true,
      title: ApplicationLocalizations.of(context).translate("report_type"),
      callback: (item)async {
        if(item==""||item==null){
          setState(() {
            reportTypeId="";
            reportTypeName="";
          });
        }
        else {
          setState(() {
            reportTypeId = item['ID'].toString();
            reportTypeName = item['Name'].toString();
          });
        }
      },
    );}
  String groupName="";
  var groupId="";
  TextEditingController billdays=TextEditingController();

  Widget getBillingDaysLayout(double parentHeight, double parentWidth) {
    return  SingleLineEditableTextFormFieldWithoubleDouble(
      mandatory: false,
      validation: (value) {
        if (value!.isEmpty) {
          return "";
        }
        return null;
      },
      readOnly: true,
      controller: billdays,
      focuscontroller: null,
      focusnext: null,
      title: ApplicationLocalizations.of(context)!.translate("billing_days")!,
      callbackOnchage: (value) async {},
      textInput: TextInputType.number,
      maxlines: 1,
      format: FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    );}

  /* widget for item quantity layout */
  Widget getFatQuantityFromLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
        mandatory: false,
        suffix: Text(""),
        validation: (value) {
          if (value!.isEmpty) {
            return "";
          }
          return null;
        },
        readOnly: true,
        controller: fatFrom,
        focuscontroller: fatFocusFrom,
        focusnext: snfFocusFrom,
        title:"${ApplicationLocalizations.of(context).translate("from")} "+ ApplicationLocalizations.of(context)!.translate("fat")!,
        callbackOnchage: (value) async {
          if (mounted) {
            if (fatFrom.text == "") {
              setState(() {

              });
            } else {
              setState(() {
                //  fat.text = value;
              });
            }
          }
        },
        textInput: TextInputType.numberWithOptions(decimal: true),
        maxlines: 1,
        format: FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})')));
  }

  /* widget for item quantity layout */
  Widget getSnfQuantityFromLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
        mandatory: false,
        suffix: Text(""),
        validation: (value) {
          if (value!.isEmpty) {
            return "";
          }
          return null;
        },
        readOnly: true,
        controller: snfqtyFrom,
        focuscontroller: snfFocusFrom,
        focusnext: snfFocusFrom,
        title: "${ApplicationLocalizations.of(context).translate("from")} "+ApplicationLocalizations.of(context)!.translate("snf")!,
        callbackOnchage: (value) async {
          if (value != "") {
            if (mounted) {
              setState(() {
              });
            }
          }
        },
        textInput: TextInputType.numberWithOptions(decimal: true),
        maxlines: 1,
        format: FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})')));
  }
  /* widget for item quantity layout */
  Widget getFatQuantityToLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
        mandatory: false,
        suffix: Text(""),
        validation: (value) {
          if (value!.isEmpty) {
            return "";
          }
          return null;
        },
        readOnly:true,
        controller: fatTo,
        focuscontroller: fatFocusTo,
        focusnext: snfFocusTo,
        title:"${ApplicationLocalizations.of(context).translate("to")} "+ ApplicationLocalizations.of(context)!.translate("fat")!,
        callbackOnchage: (value) async {
          if (mounted) {
            if (fatTo.text == "") {
              setState(() {

              });
            } else {
              setState(() {
                //  fat.text = value;
              });
            }
          }
        },
        textInput: TextInputType.numberWithOptions(decimal: true),
        maxlines: 1,
        format: FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})')));
  }

  /* widget for item quantity layout */
  Widget getSnfQuantityToLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
        mandatory: false,
        suffix: Text(""),
        validation: (value) {
          if (value!.isEmpty) {
            return "";
          }
          return null;
        },
        readOnly: true,
        controller: snfqtyTo,
        focuscontroller: snfFocusTo,
        focusnext: snfFocusTo,
        title: "${ApplicationLocalizations.of(context).translate("to")} ${ApplicationLocalizations.of(context)!.translate("snf")!}",
        callbackOnchage: (value) async {
          if (value != "") {
            if (mounted) {
              setState(() {
                // snfqty.text = value;
              });
            }
          }
        },
        textInput: TextInputType.numberWithOptions(decimal: true),
        maxlines: 1,
        format: FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})')));
  }
  dynamic multiCenterType =[];
  dynamic multiledgerList=[];
  dynamic multiledgerAgainstList=[];
  dynamic multiGroupList=[];
  Widget getMultiCenterTLayout(double parentHeight, double parentWidth) {
    return MultiSelectDropdown(
      title: ApplicationLocalizations.of(context).translate("party"),
      apiUrl:  ApiConstants().partyLedger+"?Group_Code=${widget.partyCode}&",
      nameField: "Name",
      idField: "Code",
      selectedItems: multiCenterType, // e.g., List<String>
      mandatory: false,
      onSelectionChanged: (selectedList) {
        setState(() {
          multiCenterType = selectedList;
          // handle additional logic
        });
        print(multiCenterType);
      },
    );
  }
  
  dynamic multiWorkingUnder =[];
  Widget getMultiWorkingUnderLayout(double parentHeight, double parentWidth) {
    return MultiSelectDropdown(
      title:ApplicationLocalizations.of(context).translate("working_under"),
      apiUrl: ApiConstants().working_under + "?",
      nameField: "Code",
      idField: "Code",
      selectedItems: multiWorkingUnder, // e.g., List<String>
      mandatory: false,
      onSelectionChanged: (selectedList) {
        setState(() {
          multiWorkingUnder = selectedList;
          print("jnvvnbgvbgv   $selectedList \n    newwwwww  $multiWorkingUnder");
          // handle additional logic
        });
        print(multiWorkingUnder);
      },
    );}

  dynamic multiMilkType =[];

  Widget getMultiMilkTypeLayout(double parentHeight, double parentWidth) {
    return MultiSelectDropdown(
      title: "${ApplicationLocalizations.of(context).translate("milk_type")}",
      apiUrl: ApiConstants().milkType + "?",
      nameField: "Name",
      idField: "ID",
      selectedItems: multiMilkType, // e.g., List<String>
      mandatory: false,
      onSelectionChanged: (selectedList) {
        print("vnjvnjnvnv  ");
        setState(() {
          multiMilkType = selectedList;
          // handle additional logic
        });
        print(multiMilkType);
      },
    );
  }

  dynamic multiRoute =[];
  Widget getMultiRouteLayout(double parentHeight, double parentWidth) {
    return MultiSelectDropdown(
      title: ApplicationLocalizations.of(context).translate("route"),
      apiUrl: ApiConstants().route + "?Route_Type=${widget.routType}&",
      nameField: "Name",
      idField: "ID",
      selectedItems: multiRoute, // e.g., List<String>
      mandatory: false,
      onSelectionChanged: (selectedList) {
        setState(() {
          multiRoute = selectedList;
          print("jnvvnbgvbgv   $selectedList \n    newwwwww  $multiRoute");
          // handle additional logic
        });
        print(multiRoute);
      },
    );
  }

  dynamic multiState=[];
  Widget getMultiStateLayout(double parentHeight, double parentWidth) {
    return MultiSelectDropdown(
      title: ApplicationLocalizations.of(context).translate("state"),
      apiUrl: ApiConstants().stateList + "?",
      nameField: "Code",
      idField: "Code",
      selectedItems: multiState, // e.g., List<String>
      mandatory: false,
      onSelectionChanged: (selectedList) {
        print("vnjvnjnvnv  ");
        setState(() {
          multiState = selectedList;
          // handle additional logic
        });
        print(multiState);
      },
    );
  }

  dynamic multiCenter=[];
  Widget getMultiCenterLayout(double parentHeight, double parentWidth) {
    return MultiSelectDropdown(
      title: ApplicationLocalizations.of(context).translate("party_group"),
      apiUrl: ApiConstants().ledgerGroupList + "?Code=${widget.partyCode}&",
      nameField: "Code",
      idField: "Code",
      selectedItems: multiCenter, // e.g., List<String>
      mandatory: false,
      onSelectionChanged: (selectedList) {
        setState(() {
          multiCenter = selectedList;
          print("jnvvnbgvbgv   $selectedList \n    newwwwww  $multiCenter");
          // handle additional logic
        });
        print(multiCenter);
      },
    );

  }



  /* Widget to get add Invoice date Layout */
  Widget getFromDate(){
    return GetDateLayout(
        titleIndicator: true,
        title:"${ApplicationLocalizations.of(context).translate("from")} "+  ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            from=date!;
          });

        },
        applicablefrom: from
    );
  }

  Widget geToDate(){
    return GetDateLayout(

        titleIndicator: true,
        title: "${ApplicationLocalizations.of(context).translate("to")} "+ ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
          setState(() {
            to=date!;
          });

        },
        applicablefrom: to
    );
  }



  /*widget for no data*/
  Widget getNoData(double parentHeight,double parentWidth){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "${ApplicationLocalizations.of(context).translate("no_data")}",
          style: TextStyle(
            color: CommonColor.BLACK_COLOR,
            fontSize: SizeConfig.blockSizeHorizontal * 4.2,
            fontFamily: 'Inter_Medium_Font',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  var selectedVoucherType="";
  /* Widget to get Franchisee Name Layout */
  Widget getVoucherNameLayout(double parentHeight, double parentWidth) {
    return  voucherList.length<=1?Container():CommonDropdown(
      apiUrl: ApiConstants().voucher_name+"?",
      nameField:"Voucher_Name",
      idField:"Voucher_Name",
      titleIndicator: true,
      ledgerName: selectedVoucherType,
      franchiseeName:  selectedVoucherType,
      franchisee: selectedVoucherType!=""?"edit":"",
      readOnly: true,
      title: ApplicationLocalizations.of(context).translate("voucher_name"),
      callback: (item)async {
        setState(() {
          selectedVoucherType = item['Voucher_Name']!;
          position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.75);
        });
      },
    );
  }

  List<dynamic> voucherList = [];

  getVoucherType() async {
    String companyId = await AppPreferences.getCompanyId();
    String baseUrl = await AppPreferences.getDomainLink();
    String sessionToken = await AppPreferences.getSessionToken();
    AppPreferences.getDeviceId().then((deviceId) {
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = baseUrl+ ApiConstants().voucher_name+"?Company_ID=$companyId";
      apiRequestHelper.callAPIsForGetAPI(context,apiUrl, model.toJson(), "",
          onSuccess:(data){
            if(data!=null) {
              setState(() {
                voucherList = data;
                if(voucherList.length<=1){
                  selectedVoucherType=voucherList.elementAt(0)['Voucher_Name'];
                }              });

              print("  LedgerLedgersearrr  ${voucherList.length} \n listtttttt ${voucherList.elementAt(0)['Code']} ");
            }
          }, onFailure: (error) {

            CommonWidget.errorDialog(context, error);
          }, onException: (e) {
            CommonWidget.errorDialog(context, e);

          },sessionExpire: (e) {
            // CommonWidget.gotoLoginScreen(context);

          });

    });
  }
  /* Widget for navigate to next screen button  */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            String companyId = await AppPreferences.getCompanyId();
            String uid=await AppPreferences.getUId();

            String baseurl = await AppPreferences.getDomainLink();
            if(reportTypeId==""){
              CommonWidget.snackBarLay(context, "select report type");
            }else{
            print("fjfhhghghfhg    $multiledgerList   .....$multiCenterType ... $multiGroupList ...  $multiledgerAgainstList ");
            // if(multiCenterType.isNotEmpty ||
            //     multiMilkType.isNotEmpty ||
            //     multiRoute.isNotEmpty ||
            //     multiWorkingUnder.isNotEmpty ||
            //     multiState.isNotEmpty||billdays.text!=""
            //     ||fatFrom.text!=""||
            //     snfqtyFrom.text!=""||
            //     selectedFromSessionCode!=""||
            //     selectedToSessionCode!=""||
            //     snfqtyTo.text!=""){
              var gcode=widget.routType=="F"?"Farmer":"Collection Center";
              print("fjbbvbvbbv");
              String apiUrl = baseurl +
                  ApiConstants()
                      .milkCollectionReportPdf + "?Company_ID=$companyId&Report_Type=$reportTypeId&From_Date=${DateFormat("yyyy-MM-dd").format(from)}&To_Date=${DateFormat("yyyy-MM-dd").format(to)}&User=$uid";
              await Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  APIFileViewerForPostModel(apiUrl:  apiUrl,extension:"pdf",name:"Accounting_${DateFormat("yyyy-MM-dd").format(from)}_To_${DateFormat("yyyy-MM-dd").format(to)}",
                model:
                {
                  "Center" : multiCenterType,
                  "Center_Group": widget.routType=="F"?["Farmer"]:["Collection Center"],
                  "Milk_Type" : multiMilkType,
                  "Route" : multiRoute,
                  "Working_Under" : multiWorkingUnder,
                  "State" : multiState,
                  "Billing_Days" :billdays.text,
                  "From_Session" :selectedFromSessionCode,
                  "To_Session" : selectedToSessionCode,
                  "From_FAT" : fatFrom.text,
                  "To_FAT" : fatTo.text,
                  "From_SNF" : snfqtyFrom.text,
                  "To_SNF" : snfqtyTo.text
                }, reportname: 'Milk Collection Report',
              )));
            // }
            // else {
            //   var gcode=widget.routType=="F"?"Farmer":"Collection Center";
            //
            //   String apiUrl = baseurl +
            //       ApiConstants()
            //           .milkCollectionReportPdf +
            //       "?Company_ID=$companyId&Report_Type=$reportTypeId&From_Date=${DateFormat(
            //           "yyyy-MM-dd").format(from)}&To_Date=${DateFormat(
            //           "yyyy-MM-dd").format(to)}&Group_Code=$gcode";
            //   await Navigator.push(
            //       context, MaterialPageRoute(builder: (context) =>
            //       APIFileViewerForPostModel(apiUrl: apiUrl,
            //         extension: "pdf",
            //         name: "Accounting_${DateFormat("yyyy-MM-dd").format(
            //             from)}_To_${DateFormat("yyyy-MM-dd").format(to)}",
            //         model:null,
            //         reportname: 'Milk Collection Report',
            //       )));
            // }
              }
            //   downloadVoucharInvoice();
          },
          onDoubleTap: () {},
          child: Container(
            width: SizeConfig.screenWidth*.92,
            height: 50,
            decoration: BoxDecoration(
              color: CommonColor.THEME_COLOR,
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
                        .translate("show_report")!,
                    style: button_textStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  calculateTotalAmt()async{
    var cr=0.00;
    var dr=0.00;
    for(var item  in outstanding_list ){

      if(item['Amnt_Type']=="CR") {
        cr = cr + item['Amount'];
      }
      else {
        dr = dr + item['Amount'];
      }

    }
    setState(() {
      TotalCR=cr.toStringAsFixed(2) ;
      TotalDR=dr.toStringAsFixed(2) ;

    });

  }



  @override
  backToCRDRList(DateTime updateDate, cid, cname, lid, lname) {
    // TODO: implement backToCRDRList
    setState(() {
      outstanding_list.clear();
      // invoiceDate=updateDate;
    });

  }

  @override
  backToListPR(DateTime updateDate, cid, cname, lid, lname) {
    // TODO: implement backToListPR
    setState(() {
      outstanding_list.clear();
      // invoiceDate=updateDate;
    });
  }



  List<int> byteData = [];

  downloadVoucharInvoice() async {
    String companyId = await AppPreferences.getCompanyId();
    String uid = await AppPreferences.getUId();
    String baseurl = await AppPreferences.getDomainLink();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) async {
        setState(() {
          isLoaderShow = true;
        });

        var model=
        {
          "Ledger" :multiledgerList,
          "Voucher_Name" : multiCenterType,
          "Ledger_Group" :multiGroupList

        };

        String apiUrl =     baseurl +
            ApiConstants()
                .accountVoucherDownload + "?Company_ID=$companyId&User=$uid&Report_Type=$reportTypeId&From_Date=${DateFormat("yyyy-MM-dd").format(from)}&To_Date=${DateFormat("yyyy-MM-dd").format(to)}";
        apiRequestHelper.callAPIsForDynamicPI(context,apiUrl, model, "",
            onSuccess: (data)async {
              setState(() {
                isLoaderShow=false;
              });
              await Navigator.push(context, MaterialPageRoute(builder: (context)=>APIFileViewerForPostModel(apiUrl:  apiUrl,extension:"pdf",name:"AccountVoucher_${DateFormat("yyyy-MM-dd").format(from)}_To_${DateFormat("yyyy-MM-dd").format(to)}_${EmpNo}",
                reportname: '${widget.title}',  model: null,
              )));


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
}
