import 'dart:async';
import 'package:flutter/material.dart';


import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


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
import '../../../../../../data/postMilkCollection.dart';
import '../../../../../../data/request_helper.dart';
import '../../../../../../dialog/back_page_dialog.dart';
import '../../../../../../dialog/deleteDialog.dart';
import '../../../../../../searchable_Dropdowns/ledger_searchable_dropdown.dart';
import '../../../../../../searchable_Dropdowns/search_dropdown_with_acceptance.dart';
import '../../searchable_Dropdowns/common_dropdown.dart';
import '../common_widget/custom_appbar.dart';
import 'add_or_edit_milk_route_collection.dart';
class CrateMilkRouteCollection extends StatefulWidget {

  final CreateMilkCollectionInterface mListener;
  final dateNew;
  final Transporter_No;
  final editedItem;
  final come;
  final readOnly;
  final invoiceNo;
  final String logoImage;
  final route_type;
  final session;
  final sessionName;
  const CrateMilkRouteCollection({super.key, required this.dateNew,
    required this.mListener,
    required this.Transporter_No,
    this.editedItem,
    this.come,
    this.readOnly,
    this.invoiceNo,
    required this.logoImage,
    this.route_type,
    this.session,
    this.sessionName});


  @override
  State<CrateMilkRouteCollection> createState() => _CrateMilkRouteCollectionState();
}

class _CrateMilkRouteCollectionState extends State<CrateMilkRouteCollection> with SingleTickerProviderStateMixin implements AddOrEditMilkRouteCollectionInterface{
  final ScrollController _scrollController = ScrollController();
  bool disableColor = false;
  late AnimationController _Controller;

  DateTime invoiceDate = DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));

  final _voucherNoFocus = FocusNode();
  final VoucherNoController = TextEditingController();

  TextEditingController invoiceNo = TextEditingController();

  String selectedVendorName = "";
  dynamic selectedVendorId = "";

  String selectedSaleLedgerName = "";
  dynamic selectedSaleLedgerId = "";

  var selectedSession="";
  var selectedSessionCode="";

  List<dynamic> ListMenu = [];

  List<dynamic> Pending_Order_list = [];

  List<dynamic> Pending_Order_ListMenu = [];

  List selectedPendingOrders =[];

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  var companyId = "0";
  bool isLoaderShow = false;
  bool showButton = false;

  var editedItemIndex = null;
  var invoice_No;

  double minX = 30;
  double minY = 30;
  double maxX = SizeConfig.screenWidth*0.78;
  double maxY = SizeConfig.screenHeight*0.9;

  Offset  position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.75);

  String TotalAmount = "0.00";
  String avgSNF = "0.00";
  String avgFAT = "0.00";
  String totalLtr = "0.00";

  var roundoff = "0.00";

  final _formkey = GlobalKey<FormState>();


  String selectedRouteId="";
  String selectedRouteName="";

  String selectedVehicalNo = "";

  String selectedTransporter="";

  String selectedDriverName="";
  String selectedDriverMobile="";


  String finInvoiceNo = "";
  var franchiseereadonly=true;

  var company_details=null;
  var partyState="";

  var route_type="";
  var voucher_no=null;

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
print("fknvnv  ");
    setState(() {
      invoice_No = widget.invoiceNo;
      invoiceDate = widget.dateNew;
      route_type=widget.route_type;
      selectedSession=widget.sessionName;
      selectedSessionCode=widget.session;
    });

    _Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    if(widget.come=="edit")
      getStateToVerifyGSTType();
  }


  getStateToVerifyGSTType()async{
    setState(() {
      selectedSessionCode=widget.session;
    });
    print("HEREEEEEEEEEEe ${selectedSessionCode}");
    print(widget.sessionName);
    await    _getMilkCollection(1);

  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (showButton == true) {
                      await showCustomDialog(context);
                      return false;
                    } else {
                      return true;
                    }
          // return true;
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
            //
            //               Expanded(
            //                 child: Center(
            //                   child: widget.route_type=="F"?Text(
            //                     ApplicationLocalizations.of(context)!.translate("farmer_route_collection")!,
            //                     style: appbar_text_style,):Text(
            //                     ApplicationLocalizations.of(context)!.translate("center_route_collection")!,
            //                     style: appbar_text_style,),
            //                 ),
            //               ),
            //
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
              child:  CustomeAppBar(title: widget.route_type=="F"?
              ApplicationLocalizations.of(context)!.translate("farmer_route_collection")!:
              ApplicationLocalizations.of(context)!.translate("center_route_collection")!
                ,dashbord: false, onPress: null,),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                    // color: CommonColor.DASHBOARD_BACKGROUND,
                      child: getAllFields(
                          SizeConfig.screenHeight, SizeConfig.screenWidth)),
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
                    height: SizeConfig.safeUsedHeight * .12,
                    child: getSaveAndFinishButtonLayout(
                        SizeConfig.screenHeight, SizeConfig.screenWidth)),
                CommonWidget.getCommonPadding(
                    SizeConfig.screenBottom, CommonColor.WHITE_COLOR),
              ],
            ),
          ),
        ),

        voucher_no==null? Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
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
                    if(selectedRouteId!=""&&selectedSession!=""&&selectedTransporter!="") {
                      FocusScope.of(context)
                          .requestFocus(FocusNode());
                      if (selectedVendorId != "") {
                        editedItemIndex = null;
                        goToAddOrEditItem(null);
                      } else {
                        // CommonWidget.errorDialog(context,
                        //     "Select Sale Ledger and Party !");
                        goToAddOrEditItem(null);
                      }
                    }
                    else{
                      print(selectedSession);
                      if(selectedSession==""||selectedSession==null){
                        var snackBar =
                        SnackBar(content: Text("Please select Session !"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      else if(selectedRouteId==""||selectedRouteId==null){
                        var snackBar =
                        SnackBar(content: Text("Please select route !"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      else if(selectedTransporter==""|| selectedTransporter==null){
                        var snackBar =
                        SnackBar(content: Text("Please select transporter !"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }

                    }
                  })
          ),
        ):Container(),

        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  Future<void> showCustomDialog(BuildContext context) async {
    await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: BackPageDialog(
              onCallBack: (value) async {
                if (value == "yes") {
                 if(selectedVehicalNo==""&&selectedTransporter==""){
                    var snackBar = SnackBar(content: Text('Select vehical no. and transporter !'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if(selectedRouteId==""){
                    var snackBar = SnackBar(content: Text('Select Route !'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }else if(ListMenu.length==0){
                    var snackBar=SnackBar(content: Text("${ApplicationLocalizations.of(context).translate("add_atleast_one_item")}!"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                else  if(selectedVendorId!=""&&selectedRouteId!=""&&selectedVehicalNo!=""&&selectedTransporter!=""&&ListMenu.length>0) {
                   print("#######");
                   callPostMilkCollection();
                 }
              }
              },
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation2, animation1) {
        return Container();
      },
    );
  }

  /* Widget for navigate to next screen button  */
  Widget getSaveAndFinishButtonLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
                        .translate("entry")!} : ${ListMenu.length}",
                    style:
                    item_regular_textStyle.copyWith(fontSize:16,color: Colors.grey),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    "${ApplicationLocalizations.of(context)!
                        .translate("ltr")!} : $totalLtr",
                    style: item_regular_textStyle.copyWith(fontSize:16,color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [

                  Text(
                    "${ApplicationLocalizations.of(context)!
                        .translate("fat")!} : ${avgFAT}   ",
                    style:
                    item_regular_textStyle.copyWith(fontSize:16,color: Colors.grey),
                  ),
                  SizedBox(width: 0,),

                  Text(
                    "${ApplicationLocalizations.of(context)!
                        .translate("snf")!} : ${avgSNF} ",
                    style:
                    item_regular_textStyle.copyWith(fontSize:16,color: Colors.grey),
                  ),

                ],
              ),

              SizedBox(
                height: 4,
              ),
              Text(
                "${CommonWidget.getCurrencyFormat(double.parse(TotalAmount).ceilToDouble())}",
                style: item_heading_textStyle,
              ),
            ],
          ),
        ),
        showButton==true ?GestureDetector(
          onTap: () {
            if (widget.readOnly == false) {
              Navigator.pop(context);
            } else {
              if (selectedSession == "") {
                var snackBar =
                SnackBar(content: Text('Select Session!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else
              if (selectedTransporter == "") {
                var snackBar =
                SnackBar(content: Text("Select Transporter "));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }else
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
                print(widget.Transporter_No);
                if (widget.Transporter_No == null) {
                  print("#######");
                  callPostMilkCollection();
                } else {
                  print("dfsdf");
                  callPostMilkCollection();
                }
              }
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
        ):Container(),
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
      margin: const EdgeInsets.only(top: 0),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Padding(
                padding:  EdgeInsets.only(top: 0),
                child: getPurchaseDateLayout(),
              )),
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.only(top: 0 ,left: 5),
                  child:getSeesionLayout(SizeConfig.screenHeight, SizeConfig.halfscreenWidth),
                ),
              )
            ],
          ),
          getRoutesLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),

          getTransporter(SizeConfig.screenHeight, SizeConfig.halfscreenWidth),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child:getVehicalNo(SizeConfig.screenHeight,SizeConfig.screenWidth),
              ),
              widget.invoiceNo!=null? Expanded(
                child: Padding(
                  padding:  EdgeInsets.only(top: 9 ,left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${ApplicationLocalizations.of(context).translate("transport_no")}",style: item_heading_textStyle,),
                      getInvoiceNo(SizeConfig.screenHeight, SizeConfig.halfscreenWidth),
                    ],
                  ),
                ),
              ):Container()
            ],
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Expanded(child: gettranspoter_detail()),
          //   ],
          // ),
          //getSaleLedgerLayout(SizeConfig.screenHeight,SizeConfig.halfscreenWidth),
          // SizedBox(width: 5,),
        ],
      ),
    );
  }

  /* Widget to get Franchisee Name Layout */

  Widget getRoutesLayout(double parentHeight, double parentWidth) {
    return CommonDropdown(
      mandatory: true,
      apiUrl:ApiConstants().route + "?Route_Type=${widget.route_type}&",
      titleIndicator: true,
      ledgerName: selectedRouteName,
      franchiseeName: selectedRouteName,
      franchisee: selectedRouteName.isNotEmpty ? "edit" : "",
      readOnly: voucher_no!=null?false:true,
      nameField: "Name",
      idField: "ID",
      title:  ApplicationLocalizations.of(context)!.translate("route")!,
      callback: (item)async{
        print(item);
        if(item==""){
          setState(() {
            isLoaderShow=true;
            showButton = true;
            selectedRouteName ="";
            selectedRouteId = "";
          });
        }
        else if(item!="") {
          setState(() {
            showButton = true;
            isLoaderShow=true;
            selectedRouteName = item['Name']!;
            selectedRouteId = item['ID']!;
            selectedVehicalNo =item['Vehicle_No']!=null? item['Vehicle_No'].toString()!:"";
            selectedTransporter = item['Transporter_Name']!=null? item['Transporter_Name'].toString()!:"";
          });
        }
        Future.delayed(Duration(seconds: 1)).then((_) {
          print("This will run after 1 seconds");
          setState(() {
            isLoaderShow=false;
          });
        });
      },
    );
  }

  Widget getTransporter(double parentHeight, double parentWidth){
    return  SearchDropdownWithAcceptance(
      mandatory: true,
      apiUrl: ApiConstants().transporter + "?Date=${CommonWidget.getDateLayout(invoiceDate)}&",
      nameField: "Transporter",
      idField: "Transporter",
      titleIndicator: true,
      ledgerName: selectedTransporter,
      franchiseeName: selectedTransporter,
      franchisee: selectedTransporter.isNotEmpty ? "edit" : "",
      readOnly: voucher_no!=null?false:true,
      title: ApplicationLocalizations.of(context)!.translate("transporter")!,
      callback: (item) async {
        if (item is String) {
          print("The value is a String: $item");
          setState(() {
            showButton = true;
            isLoaderShow = false;
            selectedTransporter = item;
          });

        } else if (item is Map<String, dynamic>) {
          setState(() {
            showButton = true;
            isLoaderShow = false;
            selectedTransporter = item['Transporter'];
          });
        }
      },
    );
  }

  Widget getVehicalNo(double parentHeight, double parentWidth) {
    return  CommonDropdown(
      apiUrl: ApiConstants().vehical + "?",
      nameField: "Vehicle_No",
      idField: "Code",
      titleIndicator: true,
      ledgerName: selectedVehicalNo,
      franchiseeName: selectedVehicalNo,
      franchisee: selectedVehicalNo.isNotEmpty ? "edit" : "",
      readOnly: voucher_no!=null?false:true,
      title: ApplicationLocalizations.of(context)!.translate("vehical_no")!,
      callback: (item) async {
        if (item == " ") {
          selectedVehicalNo = "";
          // selectedTransporter = "";
        } else if (item != "") {
          setState(() {
            showButton = true;
            isLoaderShow = false;
            selectedVehicalNo = item['Vehicle_No'];
            // selectedTransporter = item['Trans_Code'];
          });
        }
      },
    );
  }


  Widget getInvoiceNo(double parentHeight, double parentWidth) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.only(left: 10),
      width: parentWidth,
      height: (SizeConfig.screenHeight) * .057,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: CommonColor.WHITE_COLOR,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child:invoice_No!=null? Text(
        "${invoice_No}",
        style: text_field_textStyle,
      ):Text(""),
    );
  }


  /* Widget to get add Invoice date Layout */
  Widget getPurchaseDateLayout() {
    return GetDateLayout(
      readOnly: voucher_no!=null?true:false,
        titleIndicator: true,
        title: ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date) {
          setState(() {
            invoiceDate = date!;
            ListMenu = [];
          });

        },
        applicablefrom: invoiceDate);
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
      readOnly: voucher_no!=null?false:true,
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

        print("################## ${selectedSession}");

      },
    );


  }

  Widget get_ListMenu_layout(double parentHeight, double parentWidth) {
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
            if(voucher_no==null) {
              goToAddOrEditItem(ListMenu[index]);
            }
            },
          child: Card(
            color: CommonColor.WHITE_COLOR,
            child: Column(
              children: [
                ListTile(
                  // titleAlignment: ListTileTitleAlignment.threeLine,
                  // leading:
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: CommonColor.THEME_COLOR,
                        child: Text("${index + 1}", style: TextStyle(color: Colors.white)),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text( "${ListMenu[index]['Code_Name']}", style: TextStyle(fontSize: 20,fontWeight:FontWeight.w600)),
                              SizedBox(width: 10,),
                              Text( "${ApplicationLocalizations.of(context).translate("milk_type")} : ${ListMenu[index]['Milk_Type']}", style: item_regular_textStyle.copyWith(fontSize: 18)),
                          
                            ],
                          ),
                        ),
                      )

                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              child: Text( "${ApplicationLocalizations.of(context).translate("snf")} : ${double.parse(ListMenu[index]['SNF'].toString()).toStringAsFixed(2)}",
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
                          voucher_no==null?Container(
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
                                      calculateTotalAmt();
                                    }
                                  })):Container()
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

  setStateData(StateSetter setState)async {
    print("##### $isLoader");
    var vehicalno = selectedVehicalNo;
    setState(() {
      selectedRouteName = selectedRouteName;
      selectedRouteId = selectedRouteId;
      selectedVehicalNo = vehicalno;
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          isLoader = true; // Stop loading after delay
        });
      });
      print("#####1 $isLoader");
    });
  }

  Future<Object?> goToAddOrEditItem(product) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AddOrEditMilkRouteCollection(
                mListener: this,
                editproduct: product,
                date: invoiceDate.toString(),
                route_type:route_type,
                route_code: selectedRouteId,
                session: selectedSessionCode,
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
  AddOrEditMilkRouteCollectionDetail(item) async{
    // TODO: implement AddOrEditOrderDetail
    var itemLlist = ListMenu;
    showButton = true;
    if (editedItemIndex != null) {
      var index = editedItemIndex;
      setState(() {
        ListMenu[index]['Code'] = item['Code'];
        ListMenu[index]['Code_Name'] = item['Code_Name'];
        ListMenu[index]['Milk_Type'] = item['Milk_Type'];
        ListMenu[index]['Qty_In_KG'] = double.parse(item['Qty_In_KG']);
        ListMenu[index]['Qty_In_Liter'] = double.parse(item['Qty_In_Liter']);
        ListMenu[index]['Rate'] = item['Rate']!=null?double.parse(item['Rate']):"";
        ListMenu[index]['Amount'] = item['Amount']!=null?double.parse(item['Amount']):"";
        ListMenu[index]['Fat'] = double.parse(item['Fat']);
        ListMenu[index]['Lacto'] = double.parse(item['Lacto']);
        ListMenu[index]['SNF'] = double.parse(item['SNF']);


      });
      setState(() {
        ListMenu=ListMenu;;
      });

    } else {
      itemLlist.add(item);
      print(itemLlist);

      setState(() {
        ListMenu = itemLlist;
      });
    }
    setState(() {
      editedItemIndex = null;
      showButton=true;

    });
    await calculateTotalAmt();

    print("List");
    print(ListMenu);

    if(ListMenu.length>0){
      position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.75);
    }else{
      position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.9);
    }
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
        String apiUrl = "${baseurl}${ApiConstants().route_collection}/${widget.Transporter_No}?Company_ID=$companyId&Route_Type=${widget.route_type}&Session=${selectedSessionCode}&Route_Code=${selectedRouteId}&Date=${DateFormat('yyyy-MM-dd').format(invoiceDate)}";
        // "&Party_ID=${selectedVendorId}";
        apiRequestHelper.callAPIsForGetAPI(context,apiUrl, model.toJson(), "",
            onSuccess: (data)async {
              print(data);
              setState(() {
                if (data != null) {
                  List<dynamic> _arrList = [];
                  _arrList = (data['MilkCollection']);

                  setState(() {
                    ListMenu = _arrList;

                    selectedTransporter = data['TransportHeader']['Transporter']!=null?data['TransportHeader']['Transporter']:"";
                    selectedRouteId=data['TransportHeader']['Route_Code']==null?"":data['TransportHeader']['Route_Code'].toString();
                    selectedRouteName=data['TransportHeader']['Route_Name']!=null?data['TransportHeader']['Route_Name'].toString():"";
                    selectedVehicalNo=data['TransportHeader']['Vehicle_No']!=null?data['TransportHeader']['Vehicle_No'].toString():"";
                    selectedSession=data['TransportHeader']['Session_Name']==null?"":data['TransportHeader']['Session_Name'].toString();
                    selectedSessionCode=data['TransportHeader']['Session']==null?"":data['TransportHeader']['Session'].toString();


                    voucher_no=data['TransportHeader']['Voucher_No']==null?null:data['TransportHeader']['Voucher_No'];
                    if(widget.readOnly==true) {
                      if (data['TransportHeader']['Transport_No'] != null) {
                        setState(() {

                        });
                      }
                    }
                    if(ListMenu.length>0){
                      position=Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.78);
                    }
                  });
                  calculateTotalAmt();
                  // calculateTotalAmt();
                }
                setState(() {
                  isLoaderShow = false;

                });
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

  callPostMilkCollection() async {
    String companyId = await AppPreferences.getCompanyId();

    String creatorName = await AppPreferences.getUId();
    String device = await AppPreferences.getDeviceId();
    String baseurl = await AppPreferences.getDomainLink();

    // String totalAmount =CommonWidget.getCurrencyFormat(double.parse(TotalAmount).ceilToDouble());
    double TotalAmountInt = double.parse(TotalAmount).ceilToDouble();

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        print("############## ${selectedVehicalNo}");
        PostMilkCollection model = PostMilkCollection(
          date: DateFormat('yyyy-MM-dd').format(invoiceDate),
          session: selectedSessionCode,//selectedSession
          operatorCode: creatorName,
          modifierMachine: device,
          routeCode: selectedRouteId,
          vehicleNo: selectedVehicalNo,
          transporter: selectedTransporter,
          transportNo: widget.invoiceNo,
          data: ListMenu.toList(),
        );

        String apiUrl = baseurl + ApiConstants().route_collection+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForDynamicPI(context,apiUrl, model.toJson(), "",
            onSuccess: (data) async {
              print("  ITEM  $data ");
              setState(() {
                isLoaderShow = true;
                ListMenu = [];


              });
              widget.mListener.backToList(invoiceDate);
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
