import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import '../../../../../../common_widget/common.dart';
import '../../../../../../common_widget/get_date_layout.dart';
import '../../../../../../core/app_preferance.dart';
import '../../../../../../core/colors.dart';
import '../../../../../../core/common_style.dart';
import '../../../../../../core/internet_check.dart';
import '../../../../../../core/localss/api_data_fetch_localization.dart';
import '../../../../../../core/localss/application_localizations.dart';
import '../../../../../../core/size_config.dart';
import '../../../../../../data/commonRequest/get_toakn_request.dart';
import '../../../../../../data/constant.dart';
import '../../../../../../data/request_helper.dart';
import '../../../../../../dialog/deleteDialog.dart';
import '../../core/string_en.dart';
import '../../searchable_Dropdowns/common_dropdown.dart';
import '../common_widget/custom_appbar.dart';
import 'create_route_milk_collection.dart';

class MilkRouteCollectionActivity extends StatefulWidget {
  final route_type;
  final from_date;
  final to_date;
  final title;
  const MilkRouteCollectionActivity( {super.key, this.route_type,
    required  this.from_date,
    required this.to_date, required this.title,
  });

  @override
  State<MilkRouteCollectionActivity> createState() => _MilkRouteCollectionActivityState();
}

class _MilkRouteCollectionActivityState extends State<MilkRouteCollectionActivity> implements CreateMilkCollectionInterface {
  // DateTime invoiceDate =  DateTime.now().add(Duration(minutes: 30 - DateTime.now().minute % 30));
  DateTime from_date = DateTime.now();
  DateTime to_date = DateTime.now();
  bool isLoaderShow=true;

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  List<dynamic> MilkCollection_list=[];

  int page = 1;
  bool isPagination = true;
  final ScrollController _scrollController =  ScrollController();
  bool isApiCall=false;
  double minX = 30;
  double minY = 30;
  double maxX = SizeConfig.screenWidth*0.78;
  double maxY = SizeConfig.screenHeight*0.9;

  Offset position = Offset(SizeConfig.screenWidth*0.75, SizeConfig.screenHeight*0.85);


  String selectedSession="";
  String selectedSessionCode="";

  String selectedRouteName="";
  var selectedRouteCode=null;

  String TotalAmount="0.00";
  String   TotalInvoice="0";

  var uid="";
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
    setState(() {
      from_date=widget.from_date;
      to_date=widget.to_date;
    });
    getData();
    // setVal();
  }

  getData()async{

   var user=await AppPreferences.getUId();
   setState(() {
     uid=user;
   });
    await checkAfterFive();
    await getMilkCollection(page);
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
  _scrollListener() {
    if (_scrollController.position.pixels==_scrollController.position.maxScrollExtent) {
      if (isPagination) {
        page = page + 1;
        getMilkCollection(page);
      }
    }
  }

  setDataToList(List<dynamic> _list) {
    if (MilkCollection_list.isNotEmpty) MilkCollection_list.clear();
    if (mounted) {
      setState(() {
        MilkCollection_list.addAll(_list);
      });
    }
  }

  setMoreDataToList(List<dynamic> _list) {
    if (mounted) {
      setState(() {
        MilkCollection_list.addAll(_list);
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
    await getMilkCollection(page);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Scaffold(
              backgroundColor: CommonColor.BACKGROUND_COLOR,
              // appBar: PreferredSize(
              //   preferredSize: AppBar().preferredSize,
              //   child: SafeArea(
              //     child:  Card(
              //       elevation: 3,
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(25)
              //       ),
              //       color: Colors.transparent,
              //       // color: Colors.red,
              //       margin: EdgeInsets.only(top: 10,left: 10,right: 10),
              //       child: AppBar(
              //         leadingWidth: 0,
              //         automaticallyImplyLeading: false,
              //         title:  Container(
              //           width: SizeConfig.screenWidth,
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               GestureDetector(
              //                 onTap: () {
              //                   Navigator.pop(context);
              //                 },
              //                 child: FaIcon(Icons.arrow_back),
              //               ),
              //               // widget.logoImage!=""? Container(
              //               //   height:SizeConfig.screenHeight*.05,
              //               //   width:SizeConfig.screenHeight*.05,
              //               //   alignment: Alignment.center,
              //               //   decoration: BoxDecoration(
              //               //       borderRadius: BorderRadius.circular(7),
              //               //       image: DecorationImage(
              //               //         image: FileImage(File(widget.logoImage)),
              //               //         fit: BoxFit.cover,
              //               //       )
              //               //   ),
              //               // ):Container(),
              //               const SizedBox(width: 10.0),
              //               Expanded(
              //                 child: Center(
              //                   child: widget.route_type=="F"?Text(
              //                     ApplicationLocalizations.of(context)!.translate("farmer_route_collection")!,
              //                     style: appbar_text_style,):Text(
              //                     ApplicationLocalizations.of(context)!.translate("center_route_collection")!,
              //                     style: appbar_text_style,),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(25)
              //         ),
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
              body: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin:  EdgeInsets.only(top: 4,left: 15,right: 15,bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            // Expanded(child: getPurchaseDateLayout()),
                            Expanded(
                              child: Padding(
                                padding:  EdgeInsets.only(top: 0 ,left: 0),
                                child: getSession(),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        getRoutesLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
                        Container(),
                        const SizedBox(
                          height: 10,
                        ),
                        get_sale_invoice_list_layout()
                      ],
                    ),
                  ),
                  Visibility(
                      visible: MilkCollection_list.isEmpty && isApiCall  ? true : false,
                      child: getNoData(SizeConfig.screenHeight,SizeConfig.screenWidth)),
                ],
              ),
            ),
            Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
          ],
        ),
        Positioned(
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
                child:  Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: ()async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      CrateMilkRouteCollection(
                          logoImage: "",
                          dateNew:   from_date,
                          Transporter_No: null,//DateFormat('dd-MM-yyyy').format(newDate),
                          mListener:this,
                          route_type: widget.route_type,
                          session:selectedSessionCode,
                          sessionName:selectedSession
                      )));
                  MilkCollection_list = [];
                  setState(() {
                    page=1;
                    isPagination=true;
                  });
                  await  getMilkCollection(page);
                }),
          ),
        ),
      ],
    );
  }

  CommonDropdown getSession() {
    return CommonDropdown(
      apiUrl: ApiConstants().session+"?",
      titleIndicator: false,
      ledgerName: selectedSession,
      franchiseeName:  selectedSession,
      franchisee: selectedSession!=null?"edit":"",
      readOnly: true,
      nameField: "Name",
      idField: "Code",
      title: ApplicationLocalizations.of(context)!.translate("session")!,
      callback: (item)async{
        print(item);
        if(item==""){
          setState(() {
            selectedSession ="";
            selectedSessionCode="";
          });
          await getMilkCollection(1);
        }
        else if(item!="") {
          setState(() {
            selectedSession = item['Name']!;
            selectedSessionCode=item['Code'];
          });
          await getMilkCollection(1);
        }

      },
    );
  }

  // /* Widget to get add Invoice date Layout */
  // Widget getPurchaseDateLayout(){
  //   return GetDateLayout(
  //       titleIndicator: false,
  //       title:  ApplicationLocalizations.of(context)!.translate("date")!,
  //       callback: (date){
  //         setState(() {
  //           MilkCollection_list.clear();
  //         });
  //         setState(() {
  //           invoiceDate=date!;
  //         });
  //         getMilkCollection(1);
  //       },
  //       applicablefrom: invoiceDate
  //   );
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
          getMilkCollection(1);
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
          getMilkCollection(1);
        },
        applicablefrom: to_date
    );
  }


  /* Widget to get Franchisee Name Layout */
  Widget getRoutesLayout(double parentHeight, double parentWidth) {
    return CommonDropdown(
      apiUrl:ApiConstants().route + "?Route_Type=${widget.route_type}&User=$uid&",
      titleIndicator: false,
      ledgerName: selectedRouteName,
      readOnly: true,
      nameField: "Name",
      idField: "ID",
      title:  ApplicationLocalizations.of(context)!.translate("route")!,
      callback: (item)async{
        print(item);
        if(item==""||item ==null){
          setState(() {
            selectedRouteName ="";
            selectedRouteCode = null;
            MilkCollection_list = [];
          });
          await getMilkCollection(1);
        }
        else if(item!="") {
          setState(() {
            selectedRouteName = item['Name']!;
            selectedRouteCode = item['ID']!;
            MilkCollection_list = [];
          });
          await getMilkCollection(1);
          print("############3");
          print(selectedRouteCode + "\n" + selectedRouteName);
        }

      },
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



  Expanded get_sale_invoice_list_layout() {
    return Expanded(
      child: RefreshIndicator(
        color: CommonColor.THEME_COLOR,
        onRefresh: () {
          return refreshList();
        },
        child: ListView.separated(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: MilkCollection_list.length,
          itemBuilder: (BuildContext context, int index) {
            return  GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CrateMilkRouteCollection(
                        logoImage: "",
                        dateNew: DateTime.parse(MilkCollection_list[index]['Date'].toString()),
                        Transporter_No: MilkCollection_list[index]['Transport_No'],
                        mListener: this,
                        readOnly:true,
                        editedItem: MilkCollection_list[index],
                        invoiceNo: MilkCollection_list[index]['Transport_No'],
                        come: "edit",
                        route_type:widget.route_type,
                        session:selectedSessionCode,
                        sessionName:selectedSession
                    ),
                  ),
                );
                selectedRouteCode = "";
                MilkCollection_list = [];
                setState(() {
                  page=1;
                  isPagination=true;
                });
                await  getMilkCollection(page);              },
              child: Stack(

                children: [
                  Card(
                      color: Colors.white,
                      shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MilkCollection_list[index][
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
                                            "${DateFormat("dd-MM-yyyy").format(DateTime.parse(MilkCollection_list[index]['Date'].toString()))}",
                                            style: item_heading_textStyle
                                                .copyWith(
                                                fontSize:
                                                18)),
                                      ),


                                    ],
                                  ),
                                ),
                                SizedBox(width: 20,),

                             Text("${ApplicationLocalizations.of(context).translate("transport_no")}: ${MilkCollection_list[index]['Transport_No']}",style: subHeading_withBold.copyWith(fontSize: 16,color: Colors.purple),),


                              ],
                            ),

                            SizedBox(height: 10,),


                            Divider(height: 1,),
                            SizedBox(height: 10,),


                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,

                              children: [

                                CircleAvatar(
                                  //radius: 15,
                                  backgroundColor: CommonColor.THEME_COLOR,
                                  child: Text("${index + 1}", style: TextStyle(color: Colors.white,
                                    /*fontSize: 12.0,*/)),
                                ),
                                SizedBox(width: 5,),
                                 Expanded(
                                   child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: SizeConfig.screenWidth*0.9,
                                          child: MilkCollection_list[index]['Route_Name']!=null? Text(
                                            "Route - ${MilkCollection_list[index]['Route_Name']}",
                                            style: subHeading_withBold,
                                          ):Container(),
                                        ),
                                        MilkCollection_list[index]['Vehicle_No']!=null? Text(
                                          "${MilkCollection_list[index]['Vehicle_No']}  ",
                                          style: item_heading_textStyle,
                                        ):Container(),
                                        // Divider(height: 1,),
                                        // SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            MilkCollection_list[index]['Quantity']!=null? Text(
                                              "Lit : ${double.parse(MilkCollection_list[index]['Quantity'].toString()).toStringAsFixed(2)}",
                                              style: item_heading_textStyle,
                                            ):Container(),
                                            SizedBox(width: 10,),
                                            MilkCollection_list[index]['FAT']!=null? Text(
                                              "${ApplicationLocalizations.of(context).translate("fat")} : ${double.parse(MilkCollection_list[index]['FAT'].toString()).toStringAsFixed(2)}",
                                              style: item_heading_textStyle,
                                            ):Container(),
                                            SizedBox(width: 10,),
                                            MilkCollection_list[index]['SNF']!=null? Expanded(
                                              child: Text(
                                                "SNF : ${double.parse(MilkCollection_list[index]['SNF'].toString()).toStringAsFixed(2)}",
                                                style: item_heading_textStyle,
                                              ),
                                            ):Container(),
                                    
                                    
                                    
                                          ],
                                        ),
                                      ],
                                    ),
                                                                   ),
                                 )
                              ],
                            ),

                            SizedBox(height: 10,),

                            Divider(height: 1,),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(right: 00),
                              padding: const EdgeInsets.only(top:0.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    MilkCollection_list[index]
                                    ['Amount']!=null?  Container(
                                      alignment: Alignment.centerRight,
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        CommonWidget.getCurrencyFormat(
                                            MilkCollection_list[index]
                                            ['Amount']),
                                        overflow: TextOverflow.ellipsis,
                                        style: item_heading_textStyle
                                            .copyWith(
                                            color: Colors.black,fontWeight: FontWeight.w600),
                                      ),
                                    ):Container(),
                                    MilkCollection_list[index]['Voucher_No']==null||MilkCollection_list[index]['Voucher_No']=="null"? DeleteDialogLayout(
                                      callback: (response) async {

                                        if (response == "yes") {

                                          await callDeleteMilkCollection(
                                            MilkCollection_list[index]['Transport_No']
                                                .toString(),
                                            MilkCollection_list[index]['Seq_No']
                                                .toString(),
                                            index,
                                          );
                                        }

                                      },
                                    )

                                    :Container(),
                                  ]//oo,
                              ),
                            ),
                          ],
                        ),
                      )
                  )

                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 5,
            );
          },
        ),
      ),
    );
  }

  @override
  backToList(DateTime updateDate) {
    setState(() {
      MilkCollection_list.clear();
      // invoiceDate=updateDate;
    });
    getMilkCollection(1);
    Navigator.pop(context);
    // TODO: implement backToList
  }

  getMilkCollection(int page) async {
    String companyId = await AppPreferences.getCompanyId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: page.toString()
        );

        String apiUrl = "${baseurl}${ApiConstants().route_collection}?Company_ID=$companyId&From_Date=${DateFormat("yyyy-MM-dd").format(from_date)}&To_Date=${DateFormat("yyyy-MM-dd").format(to_date)}&Session=${selectedSessionCode}&Route_Type=${widget.route_type}&Route_Code=${selectedRouteCode}&PageNumber=$page&${StringEn.pageSize}";
        apiRequestHelper.callAPIsForGetAPI(context,apiUrl, model.toJson(), "",
            onSuccess:(data){
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

                  calculateTotalAmt();
                }else{
                  isApiCall=true;
                }
              });
              print("  LedgerLedger  $data ");
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              print("Here2=> $e");
              setState(() {
                isLoaderShow=false;
              });
              var val= CommonWidget.errorDialog(context, e);
              print("YES");
              if(val=="yes"){
                print("Retry");
              }
            },sessionExpire: (e) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.gotoLoginScreen(context);
            });
      });
    }
    else{
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  callDeleteMilkCollection(String removeId,String route_code,int index) async {
    print("cLLL");
    String uid = await AppPreferences.getUId();
    String companyId = await AppPreferences.getCompanyId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });
        var model= {
          "Transport_No": removeId,
          "Modifier": uid,
          "Modifier_Machine": deviceId
        };
        String apiUrl = baseurl + ApiConstants().route_collection+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForDeleteAPI(context,apiUrl, model, "",
            onSuccess:(data){
              setState(() {
                isLoaderShow=false;
                MilkCollection_list.removeAt(index);
              });
              if(MilkCollection_list.length==0){
                setState(() {
                  TotalAmount="0.00";
                });
              }
              calculateTotalAmt();
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


  calculateTotalAmt()async{
    var total=0.00;
    for(var item  in MilkCollection_list ){
      if(item['Amount']!=null) {
        total = total + item['Amount'];
      }
      print(item['Amount']);
    }
    setState(() {
      TotalAmount=total.toStringAsFixed(2) ;
    });

  }

}
