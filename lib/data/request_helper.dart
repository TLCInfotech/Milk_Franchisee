
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:milk_fr/data/response_for_fetch.dart';
import 'package:milk_fr/data/response_for_string_dynamic.dart';
import '../../core/app_preferance.dart';
import '../common_widget/common.dart';
import '../core/localss/api_data_fetch_localization.dart';
import '../core/string_en.dart';
import 'dynamic_respose.dart';
class ApiRequestHelper {
  ApiRequestHelper._internal();


  static final ApiRequestHelper apiRequestHelper = ApiRequestHelper._internal();
  ApiRequestHelper() {}
/*
  ApiRequestHelper() {}
  Map<String, String> headers = {
    'ClientId': 'd21e2b1ca62530cc0c861e1d5b8c1336c4937924',
    'ClientKey': 'cd4df2878c9302a5efaa8f59e291e1b98331fd55',
    'ApiKey': '2633439C4CAD4293B4E4D62838DB1',
  };
*/

  void callAPIsForPostLoginAPI(context,
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(String vCode, String vName, String token, String uid,
              dynamic companydetail)
          onSuccess,
      required Function(dynamic error) onFailure,
      required Function(dynamic error) onException,
      required Function(dynamic error) sessionExpire}) async {
    //  try {
    //  headers.addAll({'session-token': sessionToken});
    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");

    print("sessionToken    ${sessionToken}");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      String token = await AppPreferences.getSessionToken();
      Response response =
          await http.post(Uri.parse(apiUrl), body: requestBody, headers: {
        'Authorization': 'Bearer $token',
      }).timeout(const Duration(seconds: 60));
      print("response    ${response.body}");
      print("response    ${response.statusCode}");

      switch (response.statusCode) {
        /*response of api status id zero when something is wrong*/
        case 400:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg!);
          print("response.data  0 400 ${apiResponse.msg}");
          // CommonWidget.showInformationDialog(context, msg);
          break;
        /*response of api status id one when get api data Successfully */
        case 200:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          print("rfhjrjrfrjrfj   ${apiResponse.token}");
          print("###########");
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          if (apiResponse.token!.isNotEmpty) {
            AppPreferences.setSessionToken(apiResponse.token!);
          }
          // print('apiResponse.session_token_key!    ${apiResponse.session_token_key!}');
          // print('apiResponse.session_token_key!    ${apiResponse.session_token_key!}');
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

          String brand = androidInfo.brand;   // Samsung, Xiaomi, Vivo
          String model = androidInfo.model;   // SM-A515F, Redmi Note 10

          print("Brand: ${brand}_${model}_${apiResponse.Machine_Name!}");
          print("Model: $model");
          AppPreferences.setDeviceId("${brand}_${model}_${apiResponse.Machine_Name!}");
          AppPreferences.setUId(apiResponse.UID!);
          AppPreferences.setMasterMenuList(jsonEncode(apiResponse.masterMenu));
          AppPreferences.setTransactionMenuList(
              jsonEncode(apiResponse.transactionMenu));
          AppPreferences.setReportMenuList(jsonEncode(apiResponse.reportMenu));
          AppPreferences.setCompanyDetail(
              jsonEncode(apiResponse.companyDetail[0]));

          print(apiResponse.companyDetail[0]);
          onSuccess(
              apiResponse.vendorCode!,
              apiResponse.vendorName.toString(),
              apiResponse.token!,
              apiResponse.UID!,
              apiResponse.companyDetail!.toList());

          break;
        /*response of api status id Two when session has expired */
        case 500:
          //  AppPreferences.clearAppPreference();
          // sessionExpire("errere");
          //  CommonWidget.gotoLoginPage(buildContext);
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onException(apiResponse.msg);
          print("onExceptionnnn77   ${apiResponse.msg}");
          break;
        case 400:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 401:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 403:
          AppPreferences.clearAppPreference();
          sessionExpire("jhhh");
          break;
        //    }
      }
    }
    on TimeoutException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_timeout")}");
    }
    on SocketException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_offline")}");
    }
    on http.ClientException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("unable_to_conect")}");
    }
    catch (e) {
      print(e);
      if (e.toString() == "Connection refused") {
        onException("${ApplicationLocalizations.of(context).translate("not_reachable")}");
      } else if (e.toString().substring(0, e.toString().indexOf(":")) ==
          "ClientException with SocketException") {
        onException("${ApplicationLocalizations.of(context).translate("contact_admin")}");
      } else
        onException(
            "⚠️" + e.toString().substring(0, e.toString().indexOf(":")));
    }
  }

  void callAPIsForGetAAPI(context,
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
      required Function(dynamic error) onFailure,
      required Function(dynamic error) onException,
      required Function(dynamic error) sessionExpire}) async {
    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");
    print("sessionToken    ${sessionToken}");
    String lang=await AppPreferences.getLang();

    try {
      String token = await AppPreferences.getSessionToken();
      Response response = await http.get(

          Uri.parse(apiUrl+"&${StringEn.lang}=${Uri.encodeComponent(lang)}"), headers: {
        'Authorization': 'Bearer $token',
      }).timeout(const Duration(seconds: 30));
      print("   jnkjfwbhjfwbhjw   ${response.statusCode}");

      switch (response.statusCode) {
        /*response of api status id zero when something is wrong*/
        case 400:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg!);
          print("response.data  0 400 ${apiResponse.msg}");
          break;
        case 200:
          try {
            // ApiResponseForFetch apiResponse = ApiResponseForFetch();
            // apiResponse = ApiResponseForFetch.fromJson(json.decode((response.body)));
            print("API");
            print("kfngnggnj   ${response.body}");
            print(json.decode((response.body))['data']);
            onSuccess(json.decode((response.body))['data']);
          } catch (e) {
            print(e);
          }
          break;
        case 500:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onException(apiResponse.msg!);
          break;
        case 404:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 401:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          print("newww  ${apiResponse.msg}");
          break;
        case 403:
          AppPreferences.clearAppPreference();
          sessionExpire("jhhh");
          break;
      }
    } on TimeoutException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_timeout")}");
    }
    on SocketException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_offline")}");
AppPreferences.clearAppPreference();
        CommonWidget.gotoLoginScreen(context);
    }
    on http.ClientException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("unable_to_conect")}");
    }
    catch (e) {
      print(e);
      if (e.toString() == "Connection refused") {
        onException("${ApplicationLocalizations.of(context).translate("not_reachable")}");
      } else if (e.toString().substring(0, e.toString().indexOf(":")) ==
          "ClientException with SocketException") {
        onException("${ApplicationLocalizations.of(context).translate("contact_admin")}");
      } else
        onException(
            "⚠️" + e.toString().substring(0, e.toString().indexOf(":")));
    }
  }

  void callAPIsForGetAPI(context,
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
      required Function(dynamic error) onFailure,
      required Function(dynamic error) onException,
      required Function(dynamic error) sessionExpire}) async {
    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");
    print("sessionToken    ${sessionToken}");
    String decodedUrl = Uri.decodeFull(apiUrl);
    // Encode the URL to ensure + becomes %20
    // Remove the '+' sign from the URL
    String lang=await AppPreferences.getLang();
    print("REQ Lang $lang");

    String encodedUrl = Uri.encodeFull(apiUrl+"&${StringEn.lang}=${Uri.encodeComponent(lang)}");
    String urlWithoutPlus =
    apiUrl.replaceAll('+', '%2b').replaceAll('%', '%25');

    print('Encoded URL: $encodedUrl');
    print("mbgmhbmhbmn  $decodedUrl   \n    $urlWithoutPlus ");
    try {
      String token = await AppPreferences.getSessionToken();
      Response response = await http.get(
          Uri.parse(urlWithoutPlus),
          headers: {
        'Authorization': 'Bearer $token',
      }).timeout(const Duration(minutes: 3));
      print("   jnkjfwbhjfwbhjw22   ${response.statusCode}");

      switch (response.statusCode) {
      /*response of api status id zero when something is wrong*/
        case 400:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg!);
          print("response.data  0 400 ${apiResponse.msg}");
          break;
        case 200:
          try {
            // ApiResponseForFetch apiResponse = ApiResponseForFetch();
            // apiResponse = ApiResponseForFetch.fromJson(json.decode((response.body)));
            print("API");
            print("kfngnggnj   ${response.body}");
            print(json.decode((response.body))['data']);
            onSuccess(json.decode((response.body))['data']);
          } catch (e) {
            print(e);
          }
          break;
        case 500:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onException(apiResponse.msg!);
          print("onExceptionnnn   ${apiResponse.msg}");
          break;
        case 404:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 401:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          print("newww  ${apiResponse.msg}");
          break;
        case 403:
          AppPreferences.clearAppPreference();
          sessionExpire("jhhh");
          break;
      }
    }
    on TimeoutException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_timeout")}");
    }
    on SocketException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_offline")}");
AppPreferences.clearAppPreference();
        CommonWidget.gotoLoginScreen(context);
    }
    on http.ClientException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("unable_to_conect")}");
    }
    catch (e) {
      print(e);
      if (e.toString() == "Connection refused") {
        onException("${ApplicationLocalizations.of(context).translate("not_reachable")}");
      } else if (e.toString().substring(0, e.toString().indexOf(":")) ==
          "ClientException with SocketException") {
        onException("${ApplicationLocalizations.of(context).translate("contact_admin")}");
      } else
        onException(
            "⚠️" + e.toString().substring(0, e.toString().indexOf(":")));
    }
  }


  void callAPIsForGetAPIDash(context,
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
        required Function(dynamic error) onFailure,
        required Function(dynamic error) onException,
        required Function(dynamic error) sessionExpire}) async {
    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");
    print("sessionToken    ${sessionToken}");
    String decodedUrl = Uri.decodeFull(apiUrl);
    // Encode the URL to ensure + becomes %20
    // Remove the '+' sign from the URL
    String lang=await AppPreferences.getLang();

    String encodedUrl = Uri.encodeFull(apiUrl);
    String urlWithoutPlus =
    apiUrl.replaceAll('+', '%2b').replaceAll('%', '%25');

    print('Encoded URL: $encodedUrl');
    print("mbgmhbmhbmn  $decodedUrl   \n    $urlWithoutPlus ");
    try {
      String token = await AppPreferences.getSessionToken();
      Response response = await http.get(
          Uri.parse(urlWithoutPlus),
          headers: {
            'Authorization': 'Bearer $token',
          }).timeout(const Duration(minutes: 3));
      print("   jnkjfwbhjfwbhjw22   ${response.statusCode}");

      switch (response.statusCode) {
      /*response of api status id zero when something is wrong*/
        case 400:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg!);
          print("response.data  0 400 ${apiResponse.msg}");
          break;
        case 200:
          try {
            // ApiResponseForFetch apiResponse = ApiResponseForFetch();
            // apiResponse = ApiResponseForFetch.fromJson(json.decode((response.body)));
            print("API");
            print("kfngnggnj   ${response.body}");
            print(json.decode((response.body))['data']);
            onSuccess(json.decode((response.body))['data']);
          } catch (e) {
            print(e);
          }
          break;
        case 500:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onException(apiResponse.msg!);
          print("onExceptionnnn   ${apiResponse.msg}");
          break;
        case 404:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 401:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          print("newww  ${apiResponse.msg}");
          break;
        case 403:
          AppPreferences.clearAppPreference();
          sessionExpire("jhhh");
          break;
      }
    }
    on TimeoutException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_timeout")}");
    }
    on SocketException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_offline")}");
      AppPreferences.clearAppPreference();
      CommonWidget.gotoLoginScreen(context);
    }
    on http.ClientException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("unable_to_conect")}");
    }
    catch (e) {
      print(e);
      if (e.toString() == "Connection refused") {
        onException("${ApplicationLocalizations.of(context).translate("not_reachable")}");
      } else if (e.toString().substring(0, e.toString().indexOf(":")) ==
          "ClientException with SocketException") {
        onException("${ApplicationLocalizations.of(context).translate("contact_admin")}");
      } else
        onException(
            "⚠️" + e.toString().substring(0, e.toString().indexOf(":")));
    }
  }

  void callAPIsForGetAPIWithReqBody(context,
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
      required Function(dynamic error) onFailure,
      required Function(dynamic error) onException,
      required Function(dynamic error) sessionExpire}) async {
    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");
    print("sessionToken    ${sessionToken}");
    String decodedUrl = Uri.decodeFull(apiUrl);
    // Encode the URL to ensure + becomes %20
    // Remove the '+' sign from the URL
    String lang=await AppPreferences.getLang();

    String encodedUrl = Uri.encodeFull(apiUrl);
    String urlWithoutPlus = encodedUrl.replaceAll('+', '%20');
    print('Encoded URL: $encodedUrl');
    print("mbgmhbmhbmn  $decodedUrl   \n    $urlWithoutPlus ");
    try {
      // String token =await AppPreferences.getSessionToken();
      // Response response = await http.get(
      //     Uri.parse(apiUrl),
      //     headers: {
      //       'Authorization': 'Bearer $token',
      //     }
      // );
      // print("   jnkjfwbhjfwbhjw22   ${response.statusCode}");
      final String url = 'http://61.2.227.173:4000/TxnMaintenanceSchedule?${StringEn.lang}=${Uri.encodeComponent(lang)}';

      // Define query parameters
      final Map<String, String> queryParams = {
        'Company_ID': 'Giriraj',
        'Date': '2024-11-15',
      };

      // Define headers
      final Map<String, String> headers = {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cC...',
        'token': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cC...'
      };

      // Define body data for GET request as query parameters
      final Map<String, String> bodyData = {
        'pageNumber': '1',
        'Schedule_Code': '',
        'Machine_Code': 'A/C + R/F RETURN 1',
      };

      // Convert bodyData into query parameters for the GET request
      final String bodyQueryString = Uri(queryParameters: bodyData).query;

      // Create the complete URI by adding the query parameters
      final Uri requestUrl = Uri.parse(
          '$url?${Uri(queryParameters: queryParams).query}&$bodyQueryString');

      // Make the GET request
      final response = await http
          .get(requestUrl, headers: headers)
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        /*response of api status id zero when something is wrong*/
        case 400:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg!);
          print("response.data  0 400 ${apiResponse.msg}");
          break;
        case 200:
          try {
            // ApiResponseForFetch apiResponse = ApiResponseForFetch();
            // apiResponse = ApiResponseForFetch.fromJson(json.decode((response.body)));
            print("API");
            print("kfngnggnj   ${response.body}");
            print(json.decode((response.body))['data']);
            onSuccess(json.decode((response.body))['data']);
          } catch (e) {
            print(e);
          }
          break;
        case 500:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onException(apiResponse.msg!);
          print("onExceptionnnn   ${apiResponse.msg}");
          break;
        case 404:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 401:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          print("newww  ${apiResponse.msg}");
          break;
        case 403:
          AppPreferences.clearAppPreference();
          sessionExpire("jhhh");
          break;
      }
    }
    on TimeoutException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_timeout")}");
    }
    on SocketException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_offline")}");
AppPreferences.clearAppPreference();
        CommonWidget.gotoLoginScreen(context);
    }
    on http.ClientException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("unable_to_conect")}");
    }
    catch (e) {
      print(e);
      if (e.toString() == "Connection refused") {
        onException("${ApplicationLocalizations.of(context).translate("not_reachable")}");
      } else if (e.toString().substring(0, e.toString().indexOf(":")) ==
          "ClientException with SocketException") {
        onException("${ApplicationLocalizations.of(context).translate("contact_admin")}");
      } else
        onException(
            "⚠️" + e.toString().substring(0, e.toString().indexOf(":")));
    }
  }

  void callAPIsForGetStringDynamicAPI(context,
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
      required Function(dynamic error) onFailure,
      required Function(dynamic error) onException,
      required Function(dynamic error) sessionExpire}) async {
    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");
    print("sessionToken    ${sessionToken}");
    try {
      String token = await AppPreferences.getSessionToken();
      String lang=await AppPreferences.getLang();

      Response response = await http.get(
          Uri.parse(apiUrl+"&${StringEn.lang}=${Uri.encodeComponent(lang)}"), headers: {
        'Authorization': 'Bearer $token',
      }).timeout(const Duration(seconds: 30));
      print("   jnkjfwbhjfwbhjw1111   ${response.statusCode}");
      switch (response.statusCode) {
        /*response of api status id zero when something is wrong*/
        case 400:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onFailure(apiResponse.msg!);
          print("response.data  0 400 ${apiResponse.msg}");
          break;
        case 200:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onSuccess(apiResponse.data);
          break;
        case 500:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onException(apiResponse.msg!);
          print("onExceptionnnn33   ${apiResponse.msg}");
          break;
        case 400:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onFailure(apiResponse.msg);
          break;

        case 401:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 403:
          AppPreferences.clearAppPreference();
          sessionExpire("jhhh");
          break;
      }
    } on TimeoutException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_timeout")}");
    }
    on SocketException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_offline")}");
AppPreferences.clearAppPreference();
        CommonWidget.gotoLoginScreen(context);
    }
    on http.ClientException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("unable_to_conect")}");
    }
    catch (e) {
      print(e);
      if (e.toString() == "Connection refused") {
        onException("${ApplicationLocalizations.of(context).translate("not_reachable")}");
      } else if (e.toString().substring(0, e.toString().indexOf(":")) ==
          "ClientException with SocketException") {
        onException("${ApplicationLocalizations.of(context).translate("contact_admin")}");
      } else
        onException(
            "⚠️" + e.toString().substring(0, e.toString().indexOf(":")));
    }
  }

  void callAPIsForDeleteAPI(context,
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
      required Function(dynamic error) onFailure,
      required Function(dynamic error) onException,
      required Function(dynamic error) sessionExpire}) async {
    //  try {
    //  headers.addAll({'session-token': sessionToken});
    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");

    // print("sessionToken    ${sessionToken}");
    String token = await AppPreferences.getSessionToken();
    try {
      String lang=await AppPreferences.getLang();

      Response response =
          await http.delete(
              Uri.parse(apiUrl+"&${StringEn.lang}=${Uri.encodeComponent(lang)}"),
              body: requestBody, headers: {
        'Authorization': 'Bearer $token',
      }).timeout(const Duration(seconds: 30));
      print("Response0");
      print(response.statusCode);

      switch (response.statusCode) {
        /*response of api status id zero when something is wrong*/
        case 400:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onFailure(apiResponse.msg!);
          print("response.data  0 400 ${apiResponse.msg}");
          break;
        case 200:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onSuccess(apiResponse.msg!);
          print("responeseee  ${apiResponse.msg}");
          break;
        case 500:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onException(apiResponse.msg!);
          print("onExceptionnnn44   ${apiResponse.msg}");
          break;
        case 400:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 401:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 403:
          AppPreferences.clearAppPreference();
          sessionExpire("jhhh");
          break;
      }
    } on TimeoutException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_timeout")}");
    }
    on SocketException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_offline")}");
AppPreferences.clearAppPreference();
        CommonWidget.gotoLoginScreen(context);
    }
    on http.ClientException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("unable_to_conect")}");
    }
    catch (e) {
      print(e);
      if (e.toString() == "Connection refused") {
        onException("${ApplicationLocalizations.of(context).translate("not_reachable")}");
      } else if (e.toString().substring(0, e.toString().indexOf(":")) ==
          "ClientException with SocketException") {
        onException("${ApplicationLocalizations.of(context).translate("contact_admin")}");
      } else
        onException(
            "⚠️" + e.toString().substring(0, e.toString().indexOf(":")));
    }
  }

  void callAPIsForPutAPI(context,
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
      required Function(dynamic error) onFailure,
      required Function(dynamic error) onException,
      required Function(dynamic error) sessionExpire}) async {
    String token = await AppPreferences.getSessionToken();
    String jsonString = "";
    print("fbbvbv   nne");
    Map<String, dynamic> cleanedData = {};

    print("ijffgfj  $cleanedData");
    requestBody.forEach((key, value) {
      // print(value);
      if (value != null && value != "" && value.toString() != "[]") {
        cleanedData[key] = jsonDecode(jsonEncode(value));
      }
    });
    print("#########s#33ew");

    jsonString = json.encode(cleanedData);
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(json.decode(json.encode(cleanedData)));
    debugPrint("prettyprint   $prettyprint");

    try {
      String lang=await AppPreferences.getLang();

      Response response =
          await http.put(Uri.parse(apiUrl+"&${StringEn.lang}=${Uri.encodeComponent(lang)}"), body: jsonString, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }).timeout(const Duration(minutes: 2));
      print("responseeee   ${response.statusCode} $token  $response");
      switch (response.statusCode) {
        /*response of api status id zero when something is wrong*/
        case 400:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));

          onFailure(apiResponse.msg!);
          print("response.data  0 400 ${apiResponse.msg}");

          // CommonWidget.showInformationDialog(context, msg);
          break;
        /*response of api status id one when get api data Successfully */
        case 200:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();

          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));

          onSuccess(apiResponse.msg!);

          break;
        /*response of api status id Two when session has expired */
        case 500:
          //  AppPreferences.clearAppPreference();
          // sessionExpire("errere");
          //  CommonWidget.gotoLoginPage(buildContext);
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onException(apiResponse.msg);
          print("onException    ${apiResponse.msg}");
          break;
        case 404:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          // AppPreferences.clearAppPreference();
          // sessionExpire("errere");
          onFailure(apiResponse.msg);
          //  CommonWidget.gotoLoginPage(buildContext);
          break;
        case 401:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 403:
          AppPreferences.clearAppPreference();
          sessionExpire("jhhh");
          break;
      }
    }on TimeoutException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_timeout")}");
    }
    on SocketException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_offline")}");
AppPreferences.clearAppPreference();
        CommonWidget.gotoLoginScreen(context);
    }
    on http.ClientException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("unable_to_conect")}");
    } catch (e) {
      print(e);
      if (e.toString() == "Connection refused") {
        onException("${ApplicationLocalizations.of(context).translate("not_reachable")}");
      } else if (e.toString().substring(0, e.toString().indexOf(":")) ==
          "ClientException with SocketException") {
        onException("${ApplicationLocalizations.of(context).translate("contact_admin")}");
      } else
        onException(
            "⚠️" + e.toString().substring(0, e.toString().indexOf(":")));
    }
  }

  void callAPIsForDynamicPI(context,
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
      required Function(dynamic error) onFailure,
      required Function(dynamic error) onException,
      required Function(dynamic error) sessionExpire}) async {
    //  try {
    //  headers.addAll({'session-token': sessionToken});
    print("apiUrl    $apiUrl");
    String jsonString = "";
    try {
      Map<String, dynamic> cleanedData = {};

      print("ijffgfj  $cleanedData");
      requestBody.forEach((key, value) {
        // print(value);
        if (value != null && value != "" && value.toString() != "[]") {
          cleanedData[key] = jsonDecode(jsonEncode(value));
        }
      });
      print("#########s#33ew");

      jsonString = json.encode(cleanedData);
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String prettyprint =
          encoder.convert(json.decode(json.encode(cleanedData)));
      debugPrint("prettyprint   $prettyprint");

      String token = await AppPreferences.getSessionToken();
      String lang=await AppPreferences.getLang();

      Response response = await http
          .post(
            Uri.parse(apiUrl+"&${StringEn.lang}=${Uri.encodeComponent(lang)}"),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            //   headers: {'Content-Type': 'application/json'},
            body: jsonString,
          )
          .timeout(const Duration(minutes: 2));
      print("###################\n${response.statusCode}");
      switch (response.statusCode) {
        /*response of api status id zero when something is wrong*/
        case 400:
          ApiResponseForFetchDynamic apiResponse = ApiResponseForFetchDynamic();

          apiResponse =
              ApiResponseForFetchDynamic.fromJson(json.decode(response.body));

          onFailure(apiResponse.msg!);
          print("response.data  0 400 ${apiResponse.msg}");

          // CommonWidget.showInformationDialog(context, msg);
          break;
        /*response of api status id one when get api data Successfully */
        case 200:
          ApiResponseForFetchDynamic apiResponse = ApiResponseForFetchDynamic();
          apiResponse =
              ApiResponseForFetchDynamic.fromJson(json.decode(response.body));
          if (apiResponse.data != null) {
            onSuccess(apiResponse.data!);
          } else {
            onSuccess(apiResponse.msg!);
          }

          break;
        /*response of api status id Two when session has expired */
        case 500:
          ApiResponseForFetchDynamic apiResponse = ApiResponseForFetchDynamic();
          apiResponse =
              ApiResponseForFetchDynamic.fromJson(json.decode(response.body));
          print("@@@@@@@@@@@@@@@ ${apiResponse.msg}");
          onException(apiResponse.msg);
          print("onExceptionnnn55   ${apiResponse.msg}");
          break;
        case 400:
          ApiResponseForFetchDynamic apiResponse = ApiResponseForFetchDynamic();
          apiResponse =
              ApiResponseForFetchDynamic.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 401:
          ApiResponseForFetchDynamic apiResponse = ApiResponseForFetchDynamic();
          apiResponse =
              ApiResponseForFetchDynamic.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 404:
          ApiResponseForFetchDynamic apiResponse = ApiResponseForFetchDynamic();
          apiResponse =
              ApiResponseForFetchDynamic.fromJson(json.decode(response.body));

          onFailure(apiResponse.msg);
          // AppPreferences.clearAppPreference();
          // sessionExpire("gdgdgd");
          break;
        case 403:
          AppPreferences.clearAppPreference();
          sessionExpire("jhhh");
          break;
        // }
      }
    }on TimeoutException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_timeout")}");
    }
    on SocketException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_offline")}");
AppPreferences.clearAppPreference();
        CommonWidget.gotoLoginScreen(context);
    }
    on http.ClientException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("unable_to_conect")}");
    }
    catch (e) {
      print(e);
      if (e.toString() == "Connection refused") {
        onException("${ApplicationLocalizations.of(context).translate("not_reachable")}");
      } else if (e.toString().substring(0, e.toString().indexOf(":")) ==
          "ClientException with SocketException") {
        onException("${ApplicationLocalizations.of(context).translate("contact_admin")}");
      } else
        onException(
            "⚠️" + e.toString().substring(0, e.toString().indexOf(":")));
    }
  }

  void callAPIsForPostMsgAPI(context,
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
      required Function(dynamic error) onFailure,
      required Function(dynamic error) onException,
      required Function(dynamic error) sessionExpire}) async {
    //  try {
    //  headers.addAll({'session-token': sessionToken});
    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");

    print("sessionToken    ${sessionToken}");

    try {
      String lang=await AppPreferences.getLang();

      String token = await AppPreferences.getSessionToken();
      Response response =
          await http.post(
              Uri.parse(apiUrl+"&${StringEn.lang}=${Uri.encodeComponent(lang)}"), body: requestBody, headers: {
        'Authorization': 'Bearer $token',
      });
      print("RESPONSE =>>>>>> ${response.body}");
      switch (response.statusCode) {
        /*response of api status id zero when something is wrong*/
        case 400:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();

          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));

          onFailure(apiResponse.msg!);
          print("response.data  0 400 ${apiResponse.msg}");

          // CommonWidget.showInformationDialog(context, msg);
          break;
        /*response of api status id one when get api data Successfully */
        case 200:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onSuccess(apiResponse.msg!);

          break;
        /*response of api status id Two when session has expired */
        case 500:
          //  AppPreferences.clearAppPreference();
          // sessionExpire("errere");
          //  CommonWidget.gotoLoginPage(buildContext);
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onException(apiResponse.msg);
          print("onExceptionnnn22   ${apiResponse.msg}");
          break;
        case 400:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 401:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        /*    case 403:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));

          onFailure(apiResponse.message);
          // AppPreferences.clearAppPreference();
          // sessionExpire("gdgdgd");
          break;*/
        case 403:
          AppPreferences.clearAppPreference();
          sessionExpire("jhhh");
          break;
        //    }
      }
    }
    on TimeoutException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_timeout")}");
    }
    on SocketException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_offline")}");
AppPreferences.clearAppPreference();
        CommonWidget.gotoLoginScreen(context);
    }
    on http.ClientException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("unable_to_conect")}");
    }
    catch (e) {
      print(e);
      if (e.toString().substring(0, e.toString().indexOf(":")) ==
          "ClientException with SocketException") {
        onException("Server Not Reachable!Please contact to Admin.");
      } else
        onException(e.toString().substring(0, e.toString().indexOf(":")));
    }
  }

  void callAPIsForPostDownlodPDfAPI(context,
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
      required Function(dynamic error) onFailure,
      required Function(dynamic error) onException,
      required Function(dynamic error) sessionExpire}) async {
    //  try {
    //  headers.addAll({'session-token': sessionToken});
    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");

    print("sessionToken    ${sessionToken}");

    try {
      String lang=await AppPreferences.getLang();

      String token = await AppPreferences.getSessionToken();
      /*  Response response = await http.post(
          Uri.parse(apiUrl),
          body: requestBody,
          headers: {
            'Authorization': 'Bearer $token',
          }
      );*/

      Response response = await http.get(Uri.parse(apiUrl+"&${StringEn.lang}=${Uri.encodeComponent(lang)}"), headers: {
        'Authorization': 'Bearer $token',
      }).timeout(const Duration(seconds: 30));
      switch (response.statusCode) {
        /*response of api status id zero when something is wrong*/
        case 400:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();

          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));

          onFailure(apiResponse.msg!);
          print("response.data  0 400 ${apiResponse.msg}");

          // CommonWidget.showInformationDialog(context, msg);
          break;
        /*response of api status id one when get api data Successfully */
        case 200:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          print("ggjgfngngjn  ${apiResponse.data!}");
          if (apiResponse.data != "") {
            onSuccess(apiResponse.data!);
          } else {
            onSuccess(apiResponse.msg!);
          }

          break;
        /*response of api status id Two when session has expired */
        case 500:
          //  AppPreferences.clearAppPreference();
          // sessionExpire("errere");
          //  CommonWidget.gotoLoginPage(buildContext);
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onException(apiResponse.msg);
          print("onExceptionnnn66   ${apiResponse.msg}");
          break;
        case 400:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 401:
          ApiResponseForFetchStringDynamic apiResponse =
              ApiResponseForFetchStringDynamic();
          apiResponse = ApiResponseForFetchStringDynamic.fromJson(
              json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        /*    case 403:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));

          onFailure(apiResponse.message);
          // AppPreferences.clearAppPreference();
          // sessionExpire("gdgdgd");
          break;*/
        case 403:
          AppPreferences.clearAppPreference();
          sessionExpire("jhhh");
          break;
        //    }
      }
    }on TimeoutException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_timeout")}");
    }
    on SocketException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_offline")}");
        AppPreferences.clearAppPreference();
        CommonWidget.gotoLoginScreen(context);
    }
    on http.ClientException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("unable_to_conect")}");
    } catch (e) {
      print(e);
      if (e.toString() == "Connection refused") {
        onException("${ApplicationLocalizations.of(context).translate("not_reachable")}");
      } else if (e.toString().substring(0, e.toString().indexOf(":")) ==
          "ClientException with SocketException") {
        onException("${ApplicationLocalizations.of(context).translate("contact_admin")}");
      } else
        onException(
            "⚠️" + e.toString().substring(0, e.toString().indexOf(":")));
    }
  }
  void callAPIsForGetLangAPI(context,
      String apiUrl, dynamic requestBody, String sessionToken,
      {required Function(dynamic data) onSuccess,
        required Function(dynamic error) onFailure,
        required Function(dynamic error) onException,
        required Function(dynamic error) sessionExpire}) async {

    print("apiUrl    $apiUrl");
    print("requestBody    $requestBody");
    print("sessionToken    ${sessionToken}");
    String decodedUrl = Uri.decodeFull(apiUrl);
    print("jjfc   $apiUrl");
    // Encode the URL to ensure + becomes %20
    // Remove the '+' sign from the URL


    try {
      String token =await AppPreferences.getSessionToken();
      Response response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            'Authorization': 'Bearer $token',
          }
      );
      print("   jnkjfwbhjfwbhjw22   ${response.statusCode}");

      switch (response.statusCode) {
      /*response of api status id zero when something is wrong*/
        case 400:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse = ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg!);
          print("response.data  0 400 ${apiResponse.msg}");
          break;
        case 200:
          try {
            // ApiResponseForFetch apiResponse = ApiResponseForFetch();
            // apiResponse = ApiResponseForFetch.fromJson(json.decode((response.body)));
            print("API");
            print("kfngnggnj   ${response.body}");
            print(json.decode((response.body))['data']);
            onSuccess(json.decode((response.body))['data']);

          }
          catch(e){
            print(e);
          }
          break;
        case 500:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onException(apiResponse.msg!);
          print("onExceptionnnn   ${apiResponse.msg}");
          break;
        case 404:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          break;
        case 401:
          ApiResponseForFetch apiResponse = ApiResponseForFetch();
          apiResponse =
              ApiResponseForFetch.fromJson(json.decode(response.body));
          onFailure(apiResponse.msg);
          print("newww  ${apiResponse.msg}");
          break;
        case 403:
          AppPreferences.clearAppPreference();
          sessionExpire("jhhh");
          break;
      }
    } on TimeoutException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_timeout")}");
    }
    on SocketException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("server_offline")}");
      AppPreferences.clearAppPreference();
      CommonWidget.gotoLoginScreen(context);
    }
    on http.ClientException catch (_) {
      onException("${ApplicationLocalizations.of(context).translate("unable_to_conect")}");
    }
    catch (e) {
      print(e);

      if (e.toString() == "Connection refused") {
        onException("${ApplicationLocalizations.of(context).translate("not_reachable")}");
      } else if (e.toString().substring(0, e.toString().indexOf(":")) ==
          "ClientException with SocketException") {
        onException("${ApplicationLocalizations.of(context).translate("contact_admin")}");
      } else
        onException(
            "⚠️" + e.toString().substring(0, e.toString().indexOf(":")));
    }
  }
}
