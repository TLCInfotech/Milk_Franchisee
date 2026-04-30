
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../common_widget/common.dart';
import '../../core/app_preferance.dart';
import '../../core/colors.dart';
import '../../core/common_style.dart';
import '../../core/internet_check.dart';
import '../../core/localss/api_data_fetch_localization.dart';
import '../../core/size_config.dart';
import '../../data/commonRequest/get_toakn_request.dart';
import '../../data/constant.dart';
import '../../data/login/login_request_model.dart';
import '../../data/request_helper.dart';
import '../dashboard_activity.dart';
import 'domain_link.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  List companyIDList=[];
  var selectedCompanyID=null;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  bool isLoaderShow=false;
  var dataArr;
  var dataArrM;
  var dataArrR;

  var singleRecord;
  List MasterMenu=[];
  List TransactionMenu=[];
  List ReportMenu=[];

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getLocalData();
    super.initState();

  }

  getLocalData()async {
     var cidList=await AppPreferences.getCompanyIdList();
     if(cidList!=""&&  cidList!=null) {
       setState(() {
         companyIDList = jsonDecode(cidList);
         selectedCompanyID = companyIDList[0];
         AppPreferences.setDomainLink("${selectedCompanyID['domainLink']}");
       });
     }
     print(companyIDList);
     String lastcompany=await AppPreferences.getCompanyId();
     setState(() {
       if(lastcompany!=null&&lastcompany!=""){
         // var index=companyIDList.indexWhere((element) => element['company'].toString()==lastcompany.toString());

           var index=null;
          for(var i=0;i<=companyIDList.length;i++){
            print("${companyIDList[i]['company']} \t $lastcompany");
            if(companyIDList[i]['company']==lastcompany){
              index=i;
              break;
            }
          }
         print(index);
         selectedCompanyID = companyIDList[index];
         print("jbvbvbv   $selectedCompanyID");
         AppPreferences.setDomainLink("${companyIDList[index]['domainLink']}");
       }
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.THEME_COLOR,
      body:  Stack(
        children: [

          Container(
              padding: EdgeInsets.all((SizeConfig.screenWidth) * 0.04),
                      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //getImageLayout(  SizeConfig.screenHeight, SizeConfig.screenWidth),
            Center(
              child: ClipOval(
                child: Image(
                  height: (SizeConfig.screenHeight) * 0.15, // 10% of screen height
                  width: ((SizeConfig.screenHeight)) * 0.15,  // 10% of screen height
                  image: const AssetImage('assets/images/splash.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 30,),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: '${ApplicationLocalizations.of(context).translate("username")}',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: '${ApplicationLocalizations.of(context).translate("password")}',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 45,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: DropdownButton<dynamic>(
                hint: Text("${ApplicationLocalizations.of(context).translate("company_id")}"),
                underline: SizedBox(),
                isExpanded: true,
                value:selectedCompanyID,
                onChanged: (newValue)async {
                  setState(() {
                    selectedCompanyID=newValue;
                    print("jnvjvngv  ${newValue['domainLink']}  $selectedCompanyID  $companyIDList");
                  });
                 await AppPreferences.setDomainLink(newValue['domainLink']);

                },
                items: companyIDList.map((dynamic cid) {
                  return DropdownMenuItem<dynamic>(
                    value: cid,
                    child: Text(cid['company'].toString(), style: item_regular_textStyle),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle login action
                String username = _usernameController.text;
                String password = _passwordController.text;
                callLogin();
                print('Username: $username, Password: $password');
              },
              child: Text('${ApplicationLocalizations.of(context).translate("login")}',style: subHeading_withBold.copyWith(color: CommonColor.THEME_COLOR),),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(SizeConfig.screenWidth*0.8 ,53),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: CommonColor.WHITE_COLOR,
                foregroundColor: CommonColor.THEME_COLOR ,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),

          ],
                      )),
           // Image(
           //   height: (SizeConfig.screenHeight) * 0.2,  // 10% of screen height
           //   width: SizeConfig.screenWidth,
           //   fit: BoxFit.cover,
           //   image: AssetImage("assets/images/loginimage.jpg"),
           // ),
          Positioned(
              top: 40,
              right: 10 ,
              child: GestureDetector(
                  onTap: ()async{
                  await
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DomainLinkActivity(
                  )));
                  setState(() {
                    getLocalData();
                  });
                  },
                  child: Icon(Icons.settings,color: Colors.white,size: 25,)))
        ],
      ),
    );
  }

  /* widget for user name layout */
  Widget getImageLayout(double parentHeight,double parentWidth){
    return   Center(
      child: Image(
        height: parentWidth,
        width: parentWidth * .6,
        image: const AssetImage('assets/images/tlc.jpg'),
        //  fit: BoxFit.cover,
      ),
    );
  }
  callLogin() async {
    String baseurl=await AppPreferences.getDomainLink();
    String coml=await AppPreferences.getCompanylogo();
    print("jgjjgj  $baseurl");
    String userName = _usernameController.text.trim();
    String passwordText = _passwordController.text.trim();
    String pushKey = await AppPreferences.getPushKey();
    print("jjfjfhjfhjf  $pushKey");
    String companyId = await AppPreferences.getCompanyId();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected){
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow=true;
        });

        LoginRequestModel model = LoginRequestModel(
          Password: passwordText,
          UID: userName,
          Machine_Name: deviceId,
            Modifier:deviceId
          // modifire: "myMachine",
        );
        print(baseurl);
        String apiUrl = baseurl + ApiConstants().login+"?Company_ID=${selectedCompanyID['company']}";
        print("fnmnfn  $apiUrl");
        apiRequestHelper.callAPIsForPostLoginAPI(context,apiUrl, model.toJson(), "",
            onSuccess:(vCode,vName,token,uid,companydetail)async{
              setState(() {
                isLoaderShow=false;
              });
              // var company=companydetail[0];
              // print("^^^^^^^^^^^^^^");
              // print(companydetail);
              print("^^^^^^^^^^^^^^ $vName");
              //
              // print(company[0]);

              AppPreferences.setSessionToken(token);
              AppPreferences.setVendor(vCode);
              AppPreferences.setCompanyDetail(jsonEncode(companydetail));
              AppPreferences.setCompanyId(selectedCompanyID['company'].toString().trim());
           AppPreferences.setDomainLink("${selectedCompanyID['domainLink']}".trim());
              if (companydetail != null &&
                  companydetail.isNotEmpty &&
                  companydetail[0] != null) {

                // 🔹 Name check
                var name = companydetail[0]['Name'];
                if (name != null && name.toString().trim().isNotEmpty) {
                  AppPreferences.setCompanyName(name.toString());
                }

                // 🔹 Photo check
                var photo = companydetail[0]['Photo'];
                if (photo != null && photo['data'] != null) {
                  var photoData = photo['data'].toString();
                  if (photoData.trim().isNotEmpty) {
                    AppPreferences.setCompanylogo(photoData);
                  }
                }
              }

              if(vName==null||vName=="null") {
                print("HERE1");
                AppPreferences.setVendorName(uid);

              }
              else{
                print("HERE");
                AppPreferences.setVendorName(vName);


              }
              AppPreferences.setUId(uid);
              getUserPermission();
              print("################333");

              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            }, onFailure: (error) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              setState(() {
                isLoaderShow=false;
              });
              CommonWidget.errorDialog(context, e.toString());

            },sessionExpire: (e) {
              setState(() {
                isLoaderShow=false;
              });
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
              );
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
        print("dashboardddd   $apiUrl  ");
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
                getLocal();
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
  getLocal()async{
    // int workingDays = await AppPreferences.getWorkingDays();
    // print("workingDayyyyyy  $workingDays");
    // if(workingDays>-1) {
    //   workingDay=workingDays+1;
    //   print("workingDayyyyyy  $workingDay");
    //   viewWorkDDate = today.subtract(Duration(days: workingDay));
    //   print("workingDayyyyyy 11   ${viewWorkDDate}");
    // }else{
    //   viewWorkDDate = today.subtract(Duration(days: 50000));
    //   print("workingDayyyyyy 222  $viewWorkDDate");
    // }
    // companyId=await AppPreferences.getCompanyId();
    // setState(() {
    // });
    var menu =await (AppPreferences.getMasterMenuList());
    // var tr =await (AppPreferences.getTransactionMenuList());
    // var re =await (AppPreferences.getReportMenuList());
    print("singleRecorddddd1 rrrr  $menu");
    setState(() {
      // dataArr=tr;
      dataArrM=menu;
      // dataArrR=re;
    });

    setState(() {
      MasterMenu=  (jsonDecode(menu)).map((i) => i['Form']).toList();
      print(MasterMenu);
      // TransactionMenu=  (jsonDecode(tr)).map((i) => i['Form_ID']).toList();
      // ReportMenu=  (jsonDecode(tr)).map((i) => i['Form_ID']).toList();
    });


  }

}
