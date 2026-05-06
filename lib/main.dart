import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milk_fr/presentation/dashboard_activity.dart';
import 'package:milk_fr/presentation/login/domain_link.dart';
import 'package:milk_fr/presentation/login/login_screen.dart';
import 'core/app_preferance.dart';
import 'core/colors.dart';
import 'core/localss/api_data_fetch_localization.dart';
import 'core/size_config.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApplicationLocalizations.loadFromLocal();
  //  cameras = await availableCameras();
  runApp(MyApp());
  // Rest of your code remains the same...
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Milk Collection',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      // supportedLocales: const [
      //   Locale( 'en' , '' ),
      //   Locale( 'de' , '' ),
      // ],
      //
      // localizationsDelegates: const [
      //   ApplicationLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      //
      // localeResolutionCallback: (locale, supportedLocales) {
      //   for (var supportedLocaleLanguage in supportedLocales) {
      //     if (supportedLocaleLanguage.languageCode == locale!.languageCode &&
      //         supportedLocaleLanguage.countryCode == locale.countryCode) {
      //       return supportedLocaleLanguage;
      //     }
      //   }
      //   return supportedLocales.first;
      // },

      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 0.78),
        );
      },
      routes: <String, WidgetBuilder>{
        '/loginActivity': (BuildContext context) =>    LoginScreen(),
        '/domainLinkActivity': (BuildContext context) =>    DomainLinkActivity(),
        '/dashboard': (BuildContext context) =>   HomePage(),
      },
    );
  }

}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    getDeviceID();
  }

  /*Function for get Device Id is IOS or Android */
  getDeviceID()   {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      deviceInfo.iosInfo.then((iosInfo) {
        AppPreferences.setDeviceId(iosInfo.name);
      });
    } else {
      deviceInfo.androidInfo.then((androidInfo) {
        AppPreferences.setDeviceId(androidInfo.manufacturer);
        print("ttttttttttt  ${androidInfo.id}      ${androidInfo.product}");
      });

    }

  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: CommonColor.WHITE_COLOR,
      body: getAddNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
    );
  }

  /* Widget for Add Name Layout */
  Widget getAddNameLayout(double parentHeight, double parentWidth){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image(
            height: parentWidth,
            width: parentWidth * .6,
            image: const AssetImage('assets/images/tlc.jpg'),
            //  fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }


  void navigateLogin() {
    Navigator.of(context).pushReplacementNamed('/loginActivity');
  }


  void navigateDashboard() {
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  void navigateDomainLink() {
    Navigator.of(context).pushReplacementNamed('/domainLinkActivity');
  }


  /* Timer */
  startTimer() async {
    var duration =   const Duration(seconds: 2);
    try {
      String accessToken = "1";
      String sessionToken = await AppPreferences.getSessionToken();
      String companyId = await AppPreferences.getCompanyId();
      String domainLink = await AppPreferences.getDomainLink();
      String domainLinkV = await AppPreferences.getDomainLinkVisibility();
      print(domainLinkV);
      print(companyId);
      print("Session Token: $sessionToken");

      if (sessionToken != "") {
        return Timer(duration, navigateDashboard);
      } else {
        if (domainLinkV == "1" ) {
          return Timer(duration, navigateDomainLink);
        }
        else {
          return Timer(duration,navigateLogin);
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return Timer(duration, navigateDomainLink);
  }

}

