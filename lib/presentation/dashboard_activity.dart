import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:milk_fr/core/string_en.dart';
import 'package:milk_fr/presentation/sub_menu.dart';
import '../../common_widget/common.dart';
import '../../common_widget/get_date_layout.dart';
import '../../core/app_preferance.dart';
import '../../core/colors.dart';
import '../../core/common_style.dart';
import '../../core/internet_check.dart';
import '../../core/language_select_screen.dart';
import '../../core/localss/api_data_fetch_localization.dart';
import '../../core/size_config.dart';
import '../../data/commonRequest/get_toakn_request.dart';
import '../../data/constant.dart';
import '../../data/request_helper.dart';
import 'common_widget/custom_appbar.dart';
import 'menuActivity.dart';
import 'menu_block_design.dart';
import 'milk_collection/milk_collection_activity.dart';
import 'milk_route_collection/milk_route_collection_activity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime from_date = DateTime.now();
  DateTime to_date = DateTime.now();
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  bool isLoaderShow = false;
  var dashboardData=null;
  final controller = PageController();
  bool menuOpen = false;

  bool isTransaction = true;
  bool isReport = false;
  bool isMaster = false;
  bool shouldReload = false;
  int selected = 0;

  var vname=null;
  var companyname=null;
  var companyID=null;

  var dataArrM;
  List MasterMenu = [];

  var selectedlang="English";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  getData()async{
    var name= await AppPreferences.getUId();
    var cname=await AppPreferences.getCompanyName();
    var cid=await AppPreferences.getCompanyId();
    String lang = await AppPreferences.getLang();
    print("Language :$lang");
    setState(() {
      vname=name;
      companyname=cname;
      selectedlang=lang;
      companyID=cid;
    });
    await getUserPermission();
    await getLocalRights();
    await getMenuData(cid);
    await getDashboardData();
    await  getLangData(lang);

  }
  List<dynamic> langItems = [];

  var selectedMenu="Center Milk";

  getUserPermission() async {
    String sessionToken = await AppPreferences.getSessionToken();
    String companyId = await AppPreferences.getCompanyId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl=await AppPreferences.getDomainLink();
    String date=await AppPreferences.getDateLayout();
    String uid=await AppPreferences.getUId();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        TokenRequestModel model = TokenRequestModel(
            token: sessionToken,
            page: "1"
        );
        String apiUrl = "${baseurl}${ApiConstants().userPermission}/$uid?Company_ID=$companyId";
        print("dashboardddd  111 $apiUrl  ");
        apiRequestHelper.callAPIsForGetAPI(context,apiUrl, model.toJson(), sessionToken,
            onSuccess:(data){

              setState((){
                if(data!=null){
                  if (mounted) {
                    AppPreferences.setMasterMenuList(jsonEncode(data['Rights']));
                    // AppPreferences.setTransactionMenuList(jsonEncode(data['TransactionSub_ModuleList']));
                  }
                }else{
                }
                getLocalRights();
              });
            }, onFailure: (error) {
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {

            },sessionExpire: (e) {
              CommonWidget.gotoLoginScreen(context);
            });
      });
    }
    else{
      CommonWidget.noInternetDialogNew(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
  //FUNC: REFRESH LIST
  refreshList() async {
    print("Refresh");
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLoaderShow = true;  // Ensure this flag is set to true
    });
    await getDashboardData();
    // await getLocalRights();// Ensure this function is updating the UI correctly
    setState(() {
      isLoaderShow = false;  // Reset the loader flag
    });
  }

  getLocalRights()async{
    setState(() {});
    var menu = await (AppPreferences.getMasterMenuList());
    // var tr = await (AppPreferences.getTransactionMenuList());
    // var re = await (AppPreferences.getReportMenuList());
    // print("singleRecorddddd1 rrrr  $re");
    setState(() {
      // dataArr = tr;
      dataArrM = menu;
      // dataArrR = re;
    });
    setState(() {
      MasterMenu = (jsonDecode(menu)).map((i) => i['Form']).toList();
      // TransactionMenu = (jsonDecode(tr)).map((i) => i['Form_ID']).toList();
      // ReportMenu = (jsonDecode(tr)).map((i) => i['Form_ID']).toList();
    });

    print(MasterMenu.contains("AM001"));

  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        extendBody: true,
        drawer: MenuActivity(fromD: from_date, toD: to_date),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomeAppBar(
            title: companyname ?? ApplicationLocalizations.of(context)!.translate("home")!,
            dashbord: true,
            from_Date: from_date,
            to_Date: to_date,

            // 👇 THIS IS IMPORTANT
            onPress: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        // PreferredSize(
        //   preferredSize: AppBar().preferredSize,
        //   child: CustomeAppBar(title:companyname!=null?companyname:ApplicationLocalizations.of(context)!.translate("home")!,dashbord: true, onPress: null,from_Date: from_date,to_Date: to_date,),
        // ),

        body:Stack(
          alignment: Alignment.center,
          children: [
            RefreshIndicator(
              color: CommonColor.THEME_COLOR,
              onRefresh: () async {
                await refreshList();
                return Future.value();  // Make sure to return a future
              },
              child:SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 100),
                child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isLoaderShow?Container():Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          padding:EdgeInsets.only(left: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child:
                              vname==null?Container(): Text("${ApplicationLocalizations.of(context).translate("welcome")} $vname",style: item_heading_textStyle.copyWith(fontWeight: FontWeight.w600)),
                              ),
                              SizedBox(width: 10,),
                              langItems.length>1?  PopupMenuButton(
                                  icon: FaIcon(FontAwesomeIcons.language),
                                  onCanceled: () {

                                    getMenuData(companyID);
                                    // refresh when closed without selection
                                  },
                                  onSelected: (value)async {
                                    print("Lang $value");
                                    await AppPreferences.setLang(value.toString());
                                    await  getLangData(value.toString());
                                    setState(() {
                                      selectedlang=value.toString();
                                    });
                                    /*  if(value.toString()=="English"){
                                    print("objectdf");
                                    // changeLanguage(context,"en_IN");
                                    // _changeLanguage(context, "en_IN");
                                    await  getLangData(value.toString());

                                    await AppPreferences.setLang("en_IN");

                                  }else if (value.toString()=="ગુજરાતી"){
                                    // changeLanguage(context,"gu");
                                    // _changeLanguage(context, "gu");
                                    await  getLangData(value.toString());

                                    await AppPreferences.setLang(value.toString());
                                  }else{
                                    // changeLanguage(context,"mr");
                                    // _changeLanguage(context, "mr");
                                    await AppPreferences.setLang(value.toString());
                                  await  getLangData(value.toString());
                                  }*/

                                    getMenuData(companyID); // refresh after selection
                                    await getDashboardData();
                                  },
                                  itemBuilder: (context) =>
                                      langItems.map((item) {
                                        print(langItems);
                                        return PopupMenuItem(
                                          value: item['Code'],
                                          child: Row(
                                            children: [
                                              Text(item['Code']),
                                              SizedBox(width: 10,),
                                              selectedlang==item['Code']?Icon(Icons.check_box):Container()
                                            ],
                                          ),
                                        );
                                      }).toList()
                              ):Container()
                            ],
                          )),


                      Row(
                        children: [
                          Container(
                              width: SizeConfig.halfscreenWidth,
                              child: getFromDate()),
                          Container(alignment: Alignment.center,width: 40,child: Text("${ApplicationLocalizations.of(context).translate("to")}",textAlign: TextAlign.center,style: item_heading_textStyle.copyWith(fontWeight: FontWeight.w600),),),

                          Expanded(child: geToDate())

                          // )
                        ],
                      ),
                      SizedBox(height: 15,),


                      (MasterMenu.contains("${ApplicationLocalizations.of(context).translate("center_milk_collection")}"))||
                          (MasterMenu.contains("${ApplicationLocalizations.of(context).translate("center_milk")}"))

                          ?  GestureDetector(
                            onTap: (){

                              if (MasterMenu.contains("${ApplicationLocalizations.of(context).translate("center_milk_collection")}")){

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MilkRouteCollectionActivity(
                                  from_date:from_date,
                                  to_date:to_date,
                                  route_type:"C",
                                  // setVal: "",
                                  title: ApplicationLocalizations.of(context).translate("center_route_collection"),)));

                                }
                              else {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>
                                        MilkCollectionActivity(
                                          come:"dashboard",
                                          from_date: from_date,
                                          to_date: to_date,
                                          route_type: "C",
                                          setVal: "",
                                          title: ApplicationLocalizations.of(
                                              context).translate(
                                              "center_milk_collection"),)));
                              }
                              },
                            child: Container(
                              width: (SizeConfig.screenWidth*0.95),

                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(color: Colors.blue)
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    // width: (SizeConfig.screenWidth*0.9)/2,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                                          border: Border.all(color: Colors.blue)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              FontAwesomeIcons.droplet,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text("${ApplicationLocalizations.of(context).translate("center_milk_collection")}",style:item_heading_textStyle.copyWith(color:Colors.white,fontWeight: FontWeight.bold)),
                                        ],
                                      )
                                  ),

                                  Container(
                                    // width: (SizeConfig.screenWidth*0.9)/2,
                                    margin: EdgeInsets.only(top: 10),

                                    child: Column(
                                      children: [

                                        dashboardData==null ?Text("0.00",style: fordashboard,):
                                        center_milkQuantity==null?Container()
                                            :Text( "${ApplicationLocalizations.of(context).translate("qty")} :"
                                            " ${CommonWidget.getCurrencyFormatWithoutSymbol(double.parse(center_milkQuantity!.replaceAll(",", "")))}",textAlign: TextAlign.center,style: fordashboard,),
                                        Padding(
                                          padding:  EdgeInsets.all(5.0),
                                          child: Divider(height: 1,color: Colors.grey,),
                                        ),
                                        dashboardData==null ?Text("0.00",style: fordashboard,):
                                        center_amount==null?Container()
                                            :Text("${ApplicationLocalizations.of(context).translate("amt")} :"
                                            " ${CommonWidget.getCurrencyFormatWithoutSymbol(double.parse(center_amount!.replaceAll(",", "")))}",textAlign: TextAlign.center,style: fordashboard,),
                                        SizedBox(height: 2,),

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ):Container(),
                      (MasterMenu.contains("${ApplicationLocalizations.of(context).translate("farmer_milk_collection")}")) ?SizedBox(width: 10,):Container(),

                      (MasterMenu.contains("${ApplicationLocalizations.of(context).translate("farmer_milk_collection")}"))
                          ?
                      GestureDetector(
                            onTap: (){

                              if (MasterMenu.contains("${ApplicationLocalizations.of(context).translate("farmer_milk_collection")}")){

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MilkRouteCollectionActivity(
                                  from_date:from_date,
                                  to_date:to_date,
                                  route_type: "F",
                                  // setVal: "",
                                  title: ApplicationLocalizations.of(context).translate("farmer_route_collection"),
                                )));

                              }
                              else {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MilkCollectionActivity(
                                  from_date:from_date,
                                  to_date:to_date,
                                  route_type: "F",
                                  setVal: "",
                                  title: ApplicationLocalizations.of(context).translate("farmer_milk_collection"),
                                )));
                              }
                            },
                            child: Container(
                              width: (SizeConfig.screenWidth*0.95),

                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(color: Colors.green)
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    // width: (SizeConfig.screenWidth*0.9)/2,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                                          border: Border.all(color: Colors.green)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              FontAwesomeIcons.droplet,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text("${ApplicationLocalizations.of(context).translate("farmer_milk_collection")}",style:item_heading_textStyle.copyWith(color:Colors.white,fontWeight: FontWeight.bold)),
                                        ],
                                      )
                                  ),

                                  Container(
                                    // width: (SizeConfig.screenWidth*0.9)/2,
                                    margin: EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [

                                        dashboardData==null ?Text("0.00",style: fordashboard,):
                                        farmer_milkQuantity==null?Container():Text( "${ApplicationLocalizations.of(context).translate("qty")} :"
                                            " ${CommonWidget.getCurrencyFormatWithoutSymbol(double.parse(farmer_milkQuantity!.replaceAll(",", "")))}",textAlign: TextAlign.center
                                          ,style: fordashboard,),
                                        Padding(
                                          padding:  EdgeInsets.all(5.0),
                                          child: Divider(height: 1,color: Colors.grey,),
                                        ),
                                        dashboardData==null ?Text("0.00",style: fordashboard,):
                                        farmer_amount==null?Container():Text("${ApplicationLocalizations.of(context).translate("amt")} :"
                                            " ${CommonWidget.getCurrencyFormatWithoutSymbol(double.parse(farmer_amount!.replaceAll(",", "")))}",style: fordashboard,textAlign: TextAlign.center,),
                                        SizedBox(height: 2,),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                          :Container(),

                      SizedBox(height: 15,),


                      // Row(
                      //   children: [
                      //     GestureDetector(
                      //       onTap: (){
                      //         setState(() {
                      //           selectedMenu=ApplicationLocalizations.of(context).translate("center_milk");
                      //         });
                      //       },
                      //       child: Container(
                      //         height: 40,
                      //         width: (SizeConfig.screenWidth*0.9)/2,
                      //         decoration: BoxDecoration(
                      //           color:selectedMenu==ApplicationLocalizations.of(context).translate("center_milk")? Colors.indigo:Colors.white,
                      //           borderRadius: BorderRadius.circular(10),
                      //           border: Border.all(color: Colors.indigo)
                      //         ),
                      //         alignment: Alignment.center,
                      //         child: Text("${ApplicationLocalizations.of(context).translate("center_milk")}",style: item_heading_textStyle.copyWith(fontWeight: FontWeight.bold,color: selectedMenu==ApplicationLocalizations.of(context).translate("center_milk")?Colors.white:Colors.black87),),
                      //       ),
                      //     ),
                      //
                      //     SizedBox(width: 10,),
                      //
                      //     GestureDetector(
                      //       onTap: (){
                      //         setState(() {
                      //           selectedMenu=ApplicationLocalizations.of(context).translate("farmer_milk");
                      //         });
                      //       },
                      //       child: Container(
                      //         height: 40,
                      //         width: (SizeConfig.screenWidth*0.9)/2,
                      //         decoration: BoxDecoration(
                      //             color:selectedMenu==ApplicationLocalizations.of(context).translate("farmer_milk")? Colors.indigo:Colors.white,
                      //             borderRadius: BorderRadius.circular(10),
                      //             border: Border.all(color: Colors.indigo)
                      //         ),
                      //         alignment: Alignment.center,
                      //         child: Text("${ApplicationLocalizations.of(context).translate("farmer_milk")}",style: item_heading_textStyle.copyWith(fontWeight: FontWeight.bold,color: selectedMenu==ApplicationLocalizations.of(context).translate("farmer_milk")?Colors.white:Colors.black87),),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: 15,),


                      Divider(
                        height: 5,
                        color: Colors.indigo,
                      ),
                      // SizedBox(height: 15,),
                      Container(
                        height: 40,
                        width: (SizeConfig.screenWidth*0.9)/2,
                        decoration: BoxDecoration(
                          // color:selectedMenu==ApplicationLocalizations.of(context).translate("farmer_milk")? Colors.indigo:Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          //     border: Border.all(color: Colors.indigo)
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text("${ApplicationLocalizations.of(context).translate("center_milk")}",style: item_heading_textStyle.copyWith(fontWeight: FontWeight.bold,color: selectedMenu==ApplicationLocalizations.of(context).translate("farmer_milk")?Colors.white:Colors.black87),),
                      ),
                   // selectedMenu==ApplicationLocalizations.of(context).translate('center_milk')?
                   Row(
                     children: [
                       Expanded(child: _buildItem("${ApplicationLocalizations.of(context).translate("center_milk_collection")}",
                           (){
                           Navigator.push(context,
                               MaterialPageRoute(builder: (context) =>
                                   MilkCollectionActivity(
                                     come:"",
                                     from_date: from_date,
                                     to_date: to_date,
                                     route_type: "C",
                                     setVal: "",
                                     title: ApplicationLocalizations.of(
                                         context).translate(
                                         "center_milk_collection"),)));}

                       )),
                       SizedBox(width: 10),

                       Expanded(child: _buildItem("${ApplicationLocalizations.of(context).translate("center_route_collection")}",
                               (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>MilkRouteCollectionActivity(
                                       from_date: from_date,
                                       to_date: to_date,
                                       route_type: "C",
                                       title: ApplicationLocalizations.of(
                                           context).translate(
                                           "center_route_collection"),)));}
                       )),
                       SizedBox(width: 10),

                       Expanded(child: _buildItem("${ApplicationLocalizations.of(context).translate("center_milk_collection")} ${ApplicationLocalizations.of(context).translate("report")}",
                           (){}
                       )),
                     ],
                   ),

                      SizedBox(height: 15,),


                      Divider(
                        height: 5,
                        color: Colors.indigo,
                      ),
                      // SizedBox(height: 15,),
                      Container(
                        height: 40,
                        width: (SizeConfig.screenWidth*0.9)/2,
                        decoration: BoxDecoration(
                            // color:selectedMenu==ApplicationLocalizations.of(context).translate("farmer_milk")? Colors.indigo:Colors.white,
                            borderRadius: BorderRadius.circular(10),
                       //     border: Border.all(color: Colors.indigo)
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text("${ApplicationLocalizations.of(context).translate("farmer_milk")}",style: item_heading_textStyle.copyWith(fontWeight: FontWeight.bold,color: selectedMenu==ApplicationLocalizations.of(context).translate("farmer_milk")?Colors.white:Colors.black87),),
                      ),

                      Row(
                        children: [

                          Expanded(child: _buildItem("${ApplicationLocalizations.of(context).translate("farmer_milk_collection")}",
                                  (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>
                                        MilkCollectionActivity(
                                          come:"",
                                          from_date: from_date,
                                          to_date: to_date,
                                          route_type: "F",
                                          setVal: "",
                                          title: ApplicationLocalizations.of(
                                              context).translate(
                                              "farmer_milk_collection"),)));}
                          )),

                          SizedBox(width: 10),

                          Expanded(child: _buildItem("${ApplicationLocalizations.of(context).translate("farmer_route_collection")}",
                                  (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MilkRouteCollectionActivity(
                                  from_date: from_date,
                                  to_date: to_date,
                                  route_type: "F",
                                  title: ApplicationLocalizations.of(
                                      context).translate(
                                      "farmer_route_collection"),)));}
                          )),

                          SizedBox(width: 10),

                          Expanded(child: _buildItem("${ApplicationLocalizations.of(context).translate("farmer_milk_collection")} ${ApplicationLocalizations.of(context).translate("report")}",(){})),
                        ],
                      )


                    ],
                  ),

                ),
              ),
            ),

            Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
          ],
        )

    );
  }

  Widget _buildItem(String key,  nav) {
    return GestureDetector(
      onTap:nav,
      child: Container(
        height: 80,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          ApplicationLocalizations.of(context).translate(key),
          textAlign: TextAlign.center,
          style: item_regular_textStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  String? center_amount="0.00";
  String? center_milkQuantity="0.00";

  String? farmer_amount="0.00";
  String? farmer_milkQuantity="0.00";

  String? payment="0.00";
  String? receipt="0.00";
  String? bank_amt="0.0";
  String? cash_amt="0.0";
  String? sale="0.00";
  String? purchase="0.00";
  String? profit="0.00";
  String? outStanding="0.00";
  String? returnAmt="0.00";
  String? stock="0.00";
  formatValue(value,contorller) {
    // Convert string to double
    double numericValue = double.tryParse(value) ?? 0.0;
    // Format the number with commas and two decimal places

    if(contorller=="center qty"){
      setState(() {
        center_milkQuantity=NumberFormat("#,##0.00").format(numericValue);
      });
    }
    if(contorller=="center amt"){
      setState(() {
        center_amount=NumberFormat("#,##0.00").format(numericValue);
      });
    }
    if(contorller=="farmer qty"){
      setState(() {
        farmer_milkQuantity=NumberFormat("#,##0.00").format(numericValue);
      });
    }
    if(contorller=="farmer amt"){
      setState(() {
        farmer_amount=NumberFormat("#,##0.00").format(numericValue);
      });
    }
    // contorller  = NumberFormat("#,##0.00").format(numericValue);
    // print(contorller);
    print("formattedValueeee    $contorller $center_milkQuantity"); // Output: 1,234.00
  }

  paymentVal(value) {
    // Convert string to double
    double numericValue = double.tryParse(value) ?? 0.0;
    // Format the number with commas and two decimal places
    payment  = NumberFormat("#,##0.00").format(numericValue);
    print("formattedValueeee    $payment"); // Output: 1,234.00
  }
  receiptVal(value) {
    // Convert string to double
    double numericValue = double.tryParse(value) ?? 0.0;
    // Format the number with commas and two decimal places
    receipt  = NumberFormat("#,##0.00").format(numericValue);
    print("formattedValueeee    $receipt"); // Output: 1,234.00
  }
  bankBalVal(value) {
    // Convert string to double
    double numericValue = double.tryParse(value) ?? 0.0;
    // Format the number with commas and two decimal places
    bank_amt  = NumberFormat("#,##0.00").format(numericValue);
    print("formattedValueeee    $bank_amt"); // Output: 1,234.00
  }
  cashBalVal(value) {
    // Convert string to double
    double numericValue = double.tryParse(value) ?? 0.0;
    // Format the number with commas and two decimal places
    cash_amt  = NumberFormat("#,##0.00").format(numericValue);
    print("formattedValueeee    $cash_amt"); // Output: 1,234.00
  }
  saleVal(value) {
    // Convert string to double
    double numericValue = double.tryParse(value) ?? 0.0;
    // Format the number with commas and two decimal places
    sale  = NumberFormat("#,##0.00").format(numericValue);
    print("formattedValueeee    $sale"); // Output: 1,234.00
  }
  purchaseVal(value) {
    // Convert string to double
    double numericValue = double.tryParse(value) ?? 0.0;
    // Format the number with commas and two decimal places
    purchase  = NumberFormat("#,##0.00").format(numericValue);
    print("formattedValueeee    $purchase"); // Output: 1,234.00
  }
  profitVal(value) {
    // Convert string to double
    double numericValue = double.tryParse(value) ?? 0.0;
    // Format the number with commas and two decimal places
    profit  = NumberFormat("#,##0.00").format(numericValue);
    print("formattedValueeee    $profit"); // Output: 1,234.00
  }
  outstandingVal(value) {
    // Convert string to double
    double numericValue = double.tryParse(value) ?? 0.0;
    // Format the number with commas and two decimal places
    outStanding  = NumberFormat("#,##0.00").format(numericValue);
    print("formattedValueeee    $outStanding"); // Output: 1,234.00
  }
  returnVal(value) {
    // Convert string to double
    double numericValue = double.tryParse(value) ?? 0.0;
    // Format the number with commas and two decimal places
    returnAmt  = NumberFormat("#,##0.00").format(numericValue);
    print("formattedValueeee    $returnAmt"); // Output: 1,234.00
  }
  stockVal(value) {
    // Convert string to double
    double numericValue = double.tryParse(value) ?? 0.0;
    // Format the number with commas and two decimal places
    stock  = NumberFormat("#,##0.00").format(numericValue);
    print("formattedValueeee    $stock"); // Output: 1,234.00
  }



  Widget getFromDate() {
    return GetDateLayout(
      titleIndicator: false,
      title: ApplicationLocalizations.of(context)!.translate("date")!,
      callback: (date) {
        if (date != null) {
          // 👉 Validation
          if (date.isAfter(to_date)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${ApplicationLocalizations.of(context).translate("from_date_should_smaller")}")),
            );
            return;
          }else {
            setState(() {
              from_date = date;
            });
          }
          getDashboardData();
        }
      },
      applicablefrom: from_date,
    );
  }

  Widget geToDate() {
    return GetDateLayout(
      titleIndicator: false,
      title: ApplicationLocalizations.of(context)!.translate("date")!,
      callback: (date) {
        if (date != null) {
          // 👉 Validation
          if (date.isBefore(from_date)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${ApplicationLocalizations.of(context).translate("to_date_greater_than_from_date")}")),
            );
            return;
          }

          setState(() {
            to_date = date;
          });

          getDashboardData();
        }
      },
      applicablefrom: to_date,
    );
  }
/*
  Widget getFromDate(){
    return GetDateLayout(
        titleIndicator: false,
        title:  ApplicationLocalizations.of(context)!.translate("date")!,
        callback: (date){
            setState(() {
              from_date=date!;
            });
            getDashboardData();
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
          getDashboardData();
        },
        applicablefrom: to_date
    );
  }
*/


  _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              //width: MediaQuery.of(context).size.width * 0.9,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MenuBlocksDesign(

                            menuHeight: 80,
                            menuWidth: SizeConfig.screenWidth * 0.8 / 3,
                            borderColor: Colors.blue,
                            menuTitle: ApplicationLocalizations.of(context)!
                                .translate("center_milk")!,
                            menuIcon: FontAwesomeIcons.cow,
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SubMenu(
                                    from_date:from_date,
                                    to_date:to_date,
                                    menuTitle: ApplicationLocalizations.of(context)!.translate("center_milk")!,
                                    transactionList: [
                                      ApplicationLocalizations.of(context)!
                                          .translate("center_route_collection"),
                                      ApplicationLocalizations.of(context)!
                                          .translate("center_milk_collection"),
                                      // ApplicationLocalizations.of(context)!
                                      //     .translate("center_lab_testing"),
                                      // ApplicationLocalizations.of(context)!
                                      //     .translate("center_commission"),
                                      // ApplicationLocalizations.of(context)!
                                      //     .translate("center_deduction"),
                                      // ApplicationLocalizations.of(context)!
                                      //     .translate("center_recalculation"),
                                      // ApplicationLocalizations.of(context)!
                                      //     .translate("center_payment_posting"),
                                      // ApplicationLocalizations.of(context)!
                                      //     .translate("center_reverse_milk_payment"),
                                      // ApplicationLocalizations.of(context)!
                                      //     .translate("center_received_milk"),
                                      //

                                    ],
                                    masterList: [
                                      // ApplicationLocalizations.of(context)!.translate("commission_only"),
                                      // ApplicationLocalizations.of(context)!.translate("deduction_only"),
                                      // ApplicationLocalizations.of(context)!.translate("commission_application"),
                                      // ApplicationLocalizations.of(context)!.translate("deduction_application"),
                                      // ApplicationLocalizations.of(context)!.translate("rate_chart_application"),
                                    ],
                                    reportList: [
                                      "${ApplicationLocalizations.of(context).translate("milk_collection")}" ,
                                      "${ApplicationLocalizations.of(context).translate("routewise_milk_collection")}",
                                      // "${ApplicationLocalizations.of(context).translate("bankwise_milk_bill")}",
                                      // "${ApplicationLocalizations.of(context).translate("talukawise_milk_collection")}",
                                      // "${ApplicationLocalizations.of(context).translate("commis")}",
                                      // "${ApplicationLocalizations.of(context).translate("deduct")}",
                                      // "${ApplicationLocalizations.of(context).translate("deduction_balance")}",
                                      //"${ApplicationLocalizations.of(context).translate("milk_deduction_voucher")}",
                                      // "${ApplicationLocalizations.of(context).translate("lab_testing")}",
                                      // "${ApplicationLocalizations.of(context).translate("commission_application")}",
                                      // "${ApplicationLocalizations.of(context).translate("deduction_application")}",
                                      // "${ApplicationLocalizations.of(context).translate("rate_chart_application")}",
                                      // // "${ApplicationLocalizations.of(context).translate("milk_collection_comparison")}",
                                      // "${ApplicationLocalizations.of(context).translate("milk_dispatch")}",
                                      // "${ApplicationLocalizations.of(context).translate("milk_difference")}",
                                      // "${ApplicationLocalizations.of(context).translate("center_milk_difference")}",
                                      // "${ApplicationLocalizations.of(context).translate("service")}",
                                      //"${ApplicationLocalizations.of(context).translate("bonus")}",
                                      // "${ApplicationLocalizations.of(context).translate("milk_slip")}",
                                      // "${ApplicationLocalizations.of(context).translate("joined_list")}",
                                      // "${ApplicationLocalizations.of(context).translate("center_type_center")}",
                                      // // "${ApplicationLocalizations.of(context).translate("center")}",
                                      // "${ApplicationLocalizations.of(context).translate("farmer")}",
                                      // "${ApplicationLocalizations.of(context).translate("rate_chart")}",
                                      // "${ApplicationLocalizations.of(context).translate("tanker_milk")}",
                                    //   "${ApplicationLocalizations.of(context).translate("milk_mis_report")}",
                                    //   "${ApplicationLocalizations.of(context).translate("supervisor_milk_collection")}",
                                    //   "${ApplicationLocalizations.of(context).translate("storewise_milk_collection")}",
                                    //   "${ApplicationLocalizations.of(context).translate("tanker_bill")}",
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          MenuBlocksDesign(

                              menuHeight: 80,
                              menuWidth: SizeConfig.screenWidth * 0.8 / 3,
                              borderColor: Colors.green,
                              menuTitle: ApplicationLocalizations.of(context)
                                  .translate("farmer_milk"),
                              menuIcon: FontAwesomeIcons.cow,
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SubMenu(
                                        from_date:from_date,
                                        to_date:to_date,
                                        menuTitle:
                                        ApplicationLocalizations.of(context)
                                            .translate("farmer_milk"),
                                        transactionList: [
                                          ApplicationLocalizations.of(context)!
                                              .translate("farmer_route_collection"),
                                          ApplicationLocalizations.of(context)!
                                              .translate("farmer_milk_collection"),
                                          // ApplicationLocalizations.of(context)!
                                          //     .translate("farmer_lab_testing"),
                                          // ApplicationLocalizations.of(context)!
                                          //     .translate("farmer_commission"),
                                          // ApplicationLocalizations.of(context)!
                                          //     .translate("farmer_deduction"),
                                          // ApplicationLocalizations.of(context)!
                                          //     .translate("farmer_recalculation"),
                                          // ApplicationLocalizations.of(context)!
                                          //     .translate("farmer_payment_posting"),
                                          // ApplicationLocalizations.of(context)!
                                          //     .translate("farmer_reverse_milk_payment"),
                                          // ApplicationLocalizations.of(context)!
                                          //     .translate("farmer_received_milk"),

                                        ],
                                        masterList: [
                                        ],
                                        /*      reportList: [
                                        ],*/

                                        reportList: [
                                          "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("milk_collection")}" ,
                                          "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("routewise_milk_collection")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("bankwise_milk_bill")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("talukawise_milk_collection")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("commis")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("deduct")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("deduction_balance")}",
                                          // //"${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("milk_deduction_voucher")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("lab_testing")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("commission_application")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("deduction_application")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("rate_chart_application")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("milk_collection_comparison")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("milk_dispatch")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("milk_difference")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("center_milk_difference")}",
                                          //"${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("bonus")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("milk_slip")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("joined_list")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("center_type_center")}",
                                          // // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("center")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("${ApplicationLocalizations.of(context).translate("farmer")}")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("rate_chart")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("tanker_milk")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("milk_mis_report")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("supervisor_milk_collection")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("storewise_milk_collection")}",
                                          // "${ApplicationLocalizations.of(context).translate("farmer")} ${ApplicationLocalizations.of(context).translate("tanker_bill")}",
                                        ],
                                      );
                                    });
                              }),
                          // MenuBlocksDesign(
                          //
                          //   menuHeight: 80,
                          //   menuWidth: SizeConfig.screenWidth * 0.8 / 3,
                          //   borderColor: Colors.pink,
                          //   menuTitle: ApplicationLocalizations.of(context)
                          //       .translate("milk_sale"),
                          //   menuIcon: FontAwesomeIcons.bottleWater,
                          //   onPressed: () {
                          //     showModalBottomSheet(
                          //         context: context,
                          //         builder: (BuildContext context) {
                          //           return SubMenu(
                          //             from_date:from_date,
                          //             to_date:to_date,
                          //             menuTitle:
                          //             ApplicationLocalizations.of(context)
                          //                 .translate("milk_sale"),
                          //             transactionList: [
                          //               ApplicationLocalizations.of(context)
                          //                   .translate("dispatch_tanker_milk_test"),
                          //               ApplicationLocalizations.of(context)
                          //                   .translate("receive_tanker_milk_test"),
                          //               ApplicationLocalizations.of(context)
                          //                   .translate("tanker_bill"),
                          //
                          //             ],
                          //             masterList: [],
                          //             reportList: [],
                          //           );
                          //         });
                          //   },
                          // ),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -30,
              right: MediaQuery.of(context).size.width * 0.8 / 2,
              child: FloatingActionButton(
                onPressed: ()async {
                  setState(() {
                    menuOpen = false;
                  });

                  Navigator.pop(context);
                  // Clos
                  await getUserPermission();
                },
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: const Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    ).whenComplete(() async {
      // This triggers the reload of the current page when the bottom sheet closes
      if (mounted) {
        if (selected == 0) {
          setState(() {
            shouldReload = !shouldReload; // Toggle the flag to reload the page
          });
        }
        await getUserPermission();
        await getDashboardData();

      }
    });


  }


  getDashboardData() async {
    String companyId = await AppPreferences.getCompanyId();
    String uid = await AppPreferences.getUId();
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl = await AppPreferences.getDomainLink();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {

        setState(() {
          isLoaderShow = true;
        });
        TokenRequestModel model =
        TokenRequestModel(token: sessionToken, page: 1.toString());
        // http://localhost:4000/PendingSalaryProcess?Company_ID=VatsalyaDairy&From_Date=2021-10-22&To_Date=2024-10-22null&Dept=null&Emp_No=null
        String apiUrl =
            "${baseurl}${ApiConstants().dashboard}?Company_ID=$companyId&User=${uid}&From_Date=${DateFormat('yyyy-MM-dd').format(from_date)}&&To_Date=${DateFormat('yyyy-MM-dd').format(to_date)}";
        apiRequestHelper.callAPIsForGetAPI(context,apiUrl, model.toJson(), "",
            onSuccess: (data) async {
              print(data);
              setState(() {
                if (data != null) {

                  setState(() {
                    dashboardData=data[0];
                    if(dashboardData['Center_Milk_Quantity']==null){
                      setState(() {
                        center_milkQuantity=null;
                      });
                    }else{
                      formatValue(dashboardData['Center_Milk_Quantity'].toString(),"center qty");
                    }
                    if(dashboardData['Center_Milk_Amount']==null){
                      setState(() {
                        center_amount=null;
                      });
                    }else {
                      formatValue(dashboardData['Center_Milk_Amount'].toString(),"center amt");
                    }



                    if(dashboardData['Farmer_Milk_Quantity']==null){
                      setState(() {
                        farmer_milkQuantity=null;
                      });
                    }else{
                      formatValue(dashboardData['Farmer_Milk_Quantity'].toString(),"farmer qty");
                    }
                    if(dashboardData['Farmer_Milk_Amount']==null){
                      setState(() {
                        farmer_amount=null;
                      });
                    }else {
                      formatValue(dashboardData['Farmer_Milk_Amount'].toString(),"farmer amt");
                    }


                    print(center_milkQuantity);
                    print(center_amount);

                    print(data);
                  });
                }
                setState(() {
                  isLoaderShow = false;
                });
              });
              print("  LedgerLedger  $data ");
            }, onFailure: (error) {
              print("HErE1");

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
              print("HEr3");

              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.gotoLoginScreen(context);
            });
      });
    }
    else {
      print("HErE");
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }


  getMenuData(String companyId) async {
    String companyId = await AppPreferences.getCompanyId();
    print("jfjnj 333 $companyId");
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl = await AppPreferences.getDomainLink();
    String vcode=await AppPreferences.getVendor();
    // String lang=await AppPreferences.getLang();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        TokenRequestModel model = TokenRequestModel(token: sessionToken, page: 1.toString());
        String apiUrl = "${baseurl}${ApiConstants().language}?Company_ID=$companyId";
        print("gjgngvn   $apiUrl");
        apiRequestHelper.callAPIsForGetAPIDash(context,apiUrl, model.toJson(), "",
            onSuccess: (data) async {
              print("nvggvgbg  ${data[0]['Code']}");
              setState(() {
                if (data != null) {
                  if(langItems.length==1){
                    langItems=data;
                    selectedlang=data[0];
                    AppPreferences.setLang(data[0]['Code'].toString());
                  }
                  setState(() {
                    langItems =data;
                    Future.delayed(Duration(seconds: 1), () {
                      setState(() {
                        isLoaderShow = false; // Stop loading after delay
                      });
                    });
                    print("LANGUAGE $data");
                  });
                  // langItems.add({"Code":"Default"});
                }
                setState(() {
                  Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      isLoaderShow = false; // Stop loading after delay
                    });
                  });
                });
              });
              print("OUT");
              var l=await  AppPreferences.setLang(data[0]['Code'].toString());
              print("OUT Lang $l");

              await  getUserData();

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

  Map<String, String> _localizedStrings = {};

  getLangData(String lang) async {
    String companyId = await AppPreferences.getCompanyId();
    print("jfjnj 333 $companyId");
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl = await AppPreferences.getDomainLink();
    String vcode=await AppPreferences.getVendor();
    // print("jcjbdjbcjb  $lang");
    String lang=await AppPreferences.getLang();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        TokenRequestModel model = TokenRequestModel(token: sessionToken, page: 1.toString());
        String apiUrl = "${baseurl}${ApiConstants().languageData}?Company_ID=$companyId&${StringEn.lang}=${Uri.encodeComponent(lang)}";
        print("gjgngvn   $apiUrl");
        apiRequestHelper.callAPIsForGetLangAPI(context,apiUrl, model.toJson(), "",
            onSuccess: (data) async {
              print("nvggvgbg  $data");
              String jsonString =
              await rootBundle.loadString('assets/translations/en.json');

              Map<String, dynamic> jsonMap = json.decode(jsonString);

// 🔹 Step 1: English base map
              Map<String, String> baseMap =
              jsonMap.map((key, value) => MapEntry(key, value.toString()));

// 🔹 Step 2: API data (Gujarati)
              Map<String, dynamic> langData = data; // API response['data']

// 🔹 Step 3: Only उपलब्ध keys override कर
              langData.forEach((key, value) {
                if (value != null && value.toString().isNotEmpty) {
                  baseMap[key] = value.toString(); // override only available
                }
              });

// 🔥 Final localization map
              _localizedStrings = baseMap;
              print("hrfbnbfv  $_localizedStrings");
              setState(() {

                if (data != null) {
                  setState(() {

                    var langData = data;
                    print("fjksfbfbsfbf  $data");
                    ApplicationLocalizations.setLocalization(_localizedStrings);
                    print("fjksfbfbsfbf  $langData");
                    Future.delayed(Duration(seconds: 1), () {
                      setState(() {
                        isLoaderShow = false; // Stop loading after delay
                      });
                    });
                    print(data);
                  });
                  // langItems.add({"Code":"Default"});
                }
                setState(() {
                  Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      isLoaderShow = false; // Stop loading after delay
                    });
                  });
                });
              });
              await   getUserData();
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

  getUserData() async {
    print("Inside");
    String companyId = await AppPreferences.getCompanyId();
    print("jfjnj 333 $companyId");
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    String baseurl = await AppPreferences.getDomainLink();
    String uId=await AppPreferences.getUId();
    String lang=await AppPreferences.getLang();

    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {

        setState(() {
          isLoaderShow = true;
        });
        TokenRequestModel model = TokenRequestModel(token: sessionToken, page: 1.toString());
        String apiUrl = "${baseurl}${ApiConstants().getUserLogin}?UID=$uId&Company_ID=$companyId";
        apiRequestHelper.callAPIsForGetAPI(context,apiUrl, model.toJson(), "",
            onSuccess: (data) async {
              print("OUT PUT   $data");

              setState(() {
                if (data != null) {

                  print("Errorobject");
                  companyname=data['Company_Detail'][0]['Name'];
                  vname=data['Emp_Name']!=null?data['Emp_Name']:"";
                  if(data['Emp_Name']!=null) {
                    AppPreferences.setVendorName(data['Emp_Name']);
                    AppPreferences.setVendor(data['Emp_No']);
                  }
                  AppPreferences.setCompanyName(data['Company_Detail'][0]['Name']);
                  //AppPreferences.setCompanyId(data['Company_Detail'][0]['Code']);
                  setState(() {
                    isLoaderShow = false; // Stop loading after delay
                    print(data);
                  });
                  // langItems.add({"Code":"Default"});

                }
                setState(() {
                  Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      isLoaderShow = false; // Stop loading after delay
                    });
                  });
                });
              });
              getDashboardData();
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

  void changeLanguage(BuildContext context, String selectedLanguageCode) async {
    var _locale = await setLocale(selectedLanguageCode);
    print("_locale   $_locale");
    //MyApp.setLocale(context, _locale);
  }

  Future<void> _changeLanguage(BuildContext context, String languageCode) async {
    var newLocale =await setLocale(languageCode);
    //MyApp.setLocale(context, newLocale);
    print("fhbrvffbbs  ${languageCode}");
    getDashboardData();
    /*   Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
          (Route<dynamic> route) => false, // This removes all the routes
    );*/
  }





}
