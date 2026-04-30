

import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static SharedPreferences? prefs;


  /*set deviceId value in SharedPreferences*/
  static Future<String> getLang() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    print("HI FD ${prefs.getString("en_In")}");
    if(prefs.getString("en_IN")==null){
      return "";
    }
    else
      return prefs.getString("en_IN")??"";
  }

  /*get deviceId value form SharedPreferences*/
  static setLang(String en_IN) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    print("$en_IN");
    prefs.setString("en_IN", en_IN);
  }


  static Future<String> getVendor() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("vendor") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setVendor(String list) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    prefs.setString("vendor", list);
  }


  /*set deviceId value in SharedPreferences*/
  static Future<String> getVendorName() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("vendorName") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setVendorName(String list) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    prefs.setString("vendorName", list);
  }


/*set deviceId value in SharedPreferences*/
  static Future<String> getCompanylogo() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("Companylogo") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setCompanylogo(String list) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    prefs.setString("Companylogo", list);
  }



  /*set deviceId value in SharedPreferences*/
  static Future<String> getMasterMenuList() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("masterMenu") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setMasterMenuList(String list) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    prefs.setString("masterMenu", list);
  }


  /*set deviceId value in SharedPreferences*/
  static Future<String> getTransactionMenuList() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("transactionMenu") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setTransactionMenuList(String list) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    prefs.setString("transactionMenu", list);
  }

  /*set deviceId value in SharedPreferences*/
  static Future<String> getReportMenuList() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("reportMenu") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setReportMenuList(String list) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    prefs.setString("reportMenu", list);
  }



  static Future<SharedPreferences> getInstance() async {
    return await SharedPreferences.getInstance();
  }



  /*set getDeviceType value in SharedPreferences*/
  static Future<String> getPushKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("pushKey") ?? '0';
  }

/*get setDeviceType value form SharedPreferences*/
  static setPushKey(String pushKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("pushKey   $pushKey");
    prefs.setString("pushKey", pushKey);
  }

  /*set deviceId value in SharedPreferences*/
  static Future<String> getDeviceId() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("deviceId") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setDeviceId(String deviceId) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    print("deviceId   $deviceId");
    prefs.setString("deviceId", deviceId);
  }

  /*set deviceId value in SharedPreferences*/
  static Future<String> getUId() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("uId") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setUId(String uId) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    print("uId   $uId");
    prefs.setString("uId", uId);
  }
  /*set deviceId value in SharedPreferences*/
  static Future<String> getCompanyId() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("cId") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setCompanyId(String cId) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    print("cId   $cId");
    prefs.setString("cId", cId);
  }


  /*set deviceId value in SharedPreferences*/
  static Future<String> getDomainLinkVisibility() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("dLink") ?? "1";
  }

  /*get devidomainLinkceId value form SharedPreferences*/
  static setDomainLinkVisibility(String dLink) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    print("cId   $dLink");
    prefs.setString("dLink", dLink);
  }

  static Future<String> getCompanyDetail() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("companyDetail") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setCompanyDetail(String companydetail) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    print("cId   $companydetail");
    prefs.setString("companyDetail", companydetail);
  }

  /*set deviceId value in SharedPreferences*/
  static Future<String> getCompanyIdList() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("cIdList") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setFilterForSaleOrder(String companydetail) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    print("cId   $companydetail");
    prefs.setString("saleorderFilter", companydetail);
  }

  /*set deviceId value in SharedPreferences*/
  static Future<String> getFilterForSaleOrder() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("saleorderFilter") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setFilterForSaleInvoice(String companydetail) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    print("cId   $companydetail");
    prefs.setString("saleinvoiceFilter", companydetail);
  }

  /*set deviceId value in SharedPreferences*/
  static Future<String> getFilterForSaleInvoice() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("saleinvoiceFilter") ?? "";
  }

  /*get deviceId value form SharedPreferences*/
  static setCompanyIdList(String cId) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    print("cId   $cId");
    prefs.setString("cIdList", cId);
  }

  /*set getAppVersion value in SharedPreferences*/
  static Future<String> getSessionToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("sessionToken") ?? "";
  }

/*get setUserEmail value form SharedPreferences*/
  static setSessionToken(String sessionToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sessionToken", sessionToken);
  }
  /*set getAppVersion value in SharedPreferences*/
  static Future<String> getEstQty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("estQty") ?? "";
  }

/*get setUserEmail value form SharedPreferences*/
  static setEstQty(String estQty) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("estQty", estQty);
  }
  /*set getAppVersion value in SharedPreferences*/
  static Future<String> getRatio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("ratioQty") ?? "";
  }

/*get setUserEmail value form SharedPreferences*/
  static setRatio(String ratioQty) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("ratioQty", ratioQty);
  }

  /*set getAppVersion value in SharedPreferences*/
  static Future<String> getDomainLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("domainLink") ?? "";
  }

/*get setUserEmail value form SharedPreferences*/
  static setDomainLink(String domainLink) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("domainLink", domainLink);
  }
  /*set getAppVersion value in SharedPreferences*/
  static Future<String> getDateLayout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("date") ?? "";
  }

/*get setUserEmail value form SharedPreferences*/
  static setDateLayout(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("date", date);
  }


  /*set companyName value in SharedPreferences*/
  static Future<String> getCompanyName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("companyName") ?? "";
  }

/*get companyName value form SharedPreferences*/
  static setCompanyName(String companyName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("companyName", companyName);
  }

  /*set companyName value in SharedPreferences*/
  static Future<String> getCompanyUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("companyUrl") ?? "";
  }

/*get companyName value form SharedPreferences*/
  static setCompanyUrl(String companyUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("companyUrl", companyUrl);
  }

  /*set companyName value in SharedPreferences*/
  static Future<String> getPunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("punch") ?? "1";
  }

/*get companyName value form SharedPreferences*/
  static setPunch(String punch) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("punch", punch);
  }




/*get companyName value form SharedPreferences*//*

     static setCompanyUrl(File file) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('file_path', file.path);
  }

 static getCompanyUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return   prefs.getString('file_path');

  }*/

  static clearAppPreference() async {
    prefs = await getInstance();
    prefs!.remove("sessionToken");
    prefs!.remove("Companylogo");
    prefs!.remove("saleorderFilter");
    prefs!.remove("saleinvoiceFilter");
  }


  static clearLogOut() async {
    prefs = await getInstance();
    prefs!.remove("sessionToken");
    prefs!.remove("Companylogo");
    prefs!.remove("saleinvoiceFilter");
    prefs!.remove("saleorderFilter");
  }

  static dateClear()async{
    prefs = await getInstance();
    prefs!.remove("date");
  }
  static ratioClear()async{
    prefs = await getInstance();
    prefs!.remove("ratioQty");
    prefs!.remove("estQty");
  }
}
