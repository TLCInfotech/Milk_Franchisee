import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:intl/intl.dart';
import '../core/app_preferance.dart';
import '../core/colors.dart';
import '../core/common_style.dart';
import '../core/size_config.dart';
import '../dialog/ErrorOccuredDialog.dart';
import '../dialog/exit_app_dialog.dart';
import '../dialog/no_internet_dialog.dart';
import '../presentation/login/login_screen.dart';

class CommonWidget {


  /*static Future<Uint8List?> CompressImageSize(File file) async {
    final compressedBytes1 = await FlutterImageCompress.compressWithFile(
      file.path,
      quality: 30,     // 👈 Lower = smaller file (30–40 is good balance)
      minWidth: 600,   // 👈 resize (width)
      minHeight: 600,  // 👈 resize (height)
      format: CompressFormat.jpeg,
    );
    print(compressedBytes1?.length);
    return compressedBytes1;
  }*/



  static getCurrencyFormat(var amount) {
    return NumberFormat.currency(
      locale: 'en_IN', // For Indian currency format
      symbol: '₹', // Optional symbol
      decimalDigits: 2, // Two decimal places
    ).format(amount);
  }
  static getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      child: Text(
        "$title",
        style: page_heading_textStyle,
      ),
    );
  }

  static String formatDecimalPlaces(double value) {
    return value.toStringAsFixed(2);
  }

  /*Function for clear local data and goto loginPage*/
  static snackBarLay(BuildContext context, String title) {
    var snackBar = SnackBar(content: Text(title));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static getCurrencyFormatWithoutSymbol(var amount) {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '',
      name: "",
      decimalDigits: 2,
    ).format(amount);
  }

  static getDateLayout(DateTime dateNew) {
    return DateFormat('dd-MM-yyyy').format(dateNew);
  }

  static getDateTimeLayout(DateTime dateNew) {
    return DateFormat('dd-MM-yyyy HH:mm a').format(dateNew);
  }

  static startDate(BuildContext context, DateTime? date, DateTime? enDate,
      DateTime? firstDate) async {
    print(enDate);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: firstDate == null ? DateTime(1978, 12, 31) : firstDate,
      lastDate: enDate == null ? DateTime(2050, 12, 31) : enDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CommonColor.THEME_COLOR, // <-- SEE HERE
              onPrimary: CommonColor.WHITE_COLOR, // <-- SEE HERE
              onSurface: CommonColor.BLACK_COLOR, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  //  primary: CommonColor.BLACK_COLOR, // button text color
                  ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      print(formattedDate);
      return picked;
    } else {
      return null;
    }
  }

  static convertBytesToFile(data, cName) async {
    List<int> img = [];
    img = (data).whereType<int>().toList();
    Uint8List imageInUnit8List = Uint8List.fromList(img);
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/$cName.png').create();
    print("nngvgnvngv  $file");
    file.writeAsBytesSync(imageInUnit8List);
    return file;
  }

  static previousDate(BuildContext context, date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date as DateTime,
      firstDate: DateTime(1970),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CommonColor.THEME_COLOR, // <-- SEE HERE
              onPrimary: CommonColor.WHITE_COLOR, // <-- SEE HERE
              onSurface: CommonColor.BLACK_COLOR, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  //   primary: CommonColor.BLACK_COLOR, // button text color
                  ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      print(formattedDate);
      return picked;
    } else {
      return null;
    }
  }

  static getCommonPadding(double padding, Color colors) {
    return Container(
      height: padding,
      color: colors,
    );
  }

  static showExitDialog(BuildContext context, String message, isDialogType) {
    if (context != null) {
      showGeneralDialog(
          barrierColor: Colors.black.withOpacity(0.5),
          transitionBuilder: (context, a1, a2, widget) {
            final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: ExitAppDialog(
                  isDialogType: isDialogType,
                ),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 200),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation2, animation1) {
            return Container();
          });
    }
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ExitAppDialog(
    //   isDialogType: isDialogType, // Or whatever type you need
    // )));
    /*  showCupertinoDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ExitAppDialog(
              isDialogType: isDialogType, // Or whatever type you need
            );
          },
        );
      },
    );*/
  }

  static String errorDialog(BuildContext context, String message) {
    if (context != null) {
      showGeneralDialog(
          barrierColor: Colors.black.withOpacity(0.5),
          transitionBuilder: (context, a1, a2, widget) {
            final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: ErrorOccuredDialog(
                    message: message,
                    onCallBack: (value) {
                      print("INSIDE");
                      return "yes";
                    }),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 200),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation2, animation1) {
            return Container();
          });
    }
    return "null";
  }


  /*static pickDocumentFromfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'],
    );

    if (result != null) {
      print(result.files.first.name);
      PlatformFile file = result.files.first;
      Uint8List? fileBytes = result.files.first.bytes;

      final bytes = fileBytes?.length;
      print(" BYTES : $bytes");

      final kb = bytes! / 1024;

      final mb = kb! / 1024;

      if(mb<= 10){

        String fileName = result.files.first.name;

        print("FILENAE: $fileName");

        String bs4str = base64.encode(fileBytes!);

        File _file = File((result.files.single.path)as String);

        return _file;
      }
      else
      {
        // Fluttertoast.showToast(msg: "File Should be of size <= 10MB",toastLength: Toast.LENGTH_SHORT);
        return null;
      }
    }
  }*/



  static noInternetDialogNew(BuildContext context) {
    /*if (context != null) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
            NoInternetConformationDialog(isFor: "",),
      ),
      );
    }*/
    if (context != null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => NoInternetConformationDialog());
    }
  }

  static isLoader(bool isLoaderShows) {
    return Visibility(
      visible: isLoaderShows,
      child: Container(
        height: SizeConfig.safeUsedHeight,
        width: SizeConfig.screenWidth,
        color: Colors.transparent,
        child: const Padding(
          padding: EdgeInsets.all(160.0),
          child: Image(
            image: AssetImage("assets/images/rounded_blocks.gif"),
            // color: CommonColor.THEME_COLOR,
          ),
        ),
      ),
    );
  }

  /*Function for clear local data and goto loginPage*/
  static gotoLoginScreen(BuildContext context) {
    AppPreferences.clearAppPreference();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  /*static getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return "${ApplicationLocalizations.of(context).translate("location_service_disable")}";
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return "Location permissions are denied";
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return "Location permissions are permanently denied, we cannot request permissions.";
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }*/

  static Future<String> savePdfToFile(Uint8List pdfData, String name) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.pdf');
    await file.writeAsBytes(pdfData);
    return file.path;
  }

 /* static Future<void> openPdf(dynamic pdfData, String name, context) async {
    final List<dynamic> dynamicList = pdfData; // your decoded JSON byte array
    final List<int> intList = dynamicList.cast<int>();
    final Uint8List pdfBytes = Uint8List.fromList(intList);
    final path = await savePdfToFile(pdfBytes, name);
    final file = File(path);

    if (await file.exists()) {
      final result = await OpenFile.open(file.path);
      print("HERE ==>${result.type}");

      if (result.type.toString() == "ResultType.noAppToOpen"||
          result.type.toString() == "ResultType.fileNotFound"||
          result.type.toString() == "ResultType.permissionDenied"||
          result.type.toString() == "ResultType.error"
      ) {
        CommonWidget.errorDialog(context, "${result.type} ${result.message}");
      }
      // final result = await OpenFilex.open(file.path);
      print('Open result: ${result.message}');
    } else {
      print('File not found');
    }
  }*/

}
