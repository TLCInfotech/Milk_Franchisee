import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../core/localss/api_data_fetch_localization.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/app_preferance.dart';
import '../../core/common_style.dart';
import '../../core/internet_check.dart';
import '../../core/size_config.dart';
import '../core/colors.dart';
import '../data/request_helper.dart';
import 'common.dart';

class APIFileViewerFromFile extends StatefulWidget {
  final String apiUrl;
  final String extension;
  final String name;
  final String reportname;
  final  model;
  final logoImage;

  const APIFileViewerFromFile({
    super.key,
    required this.apiUrl,
    required this.extension,
    required this.name,
    required this.model,
    required this.reportname, required this.logoImage
  });

  @override
  State<APIFileViewerFromFile> createState() => _APIFileViewerState();
}

class _APIFileViewerState extends State<APIFileViewerFromFile> {
  String? localFilePath;
  String reportName="";
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  bool isLoading = false;


 // File? logo=null;
  @override
  void initState() {
    super.initState();
    setState(() {
      reportName=widget.reportname;
    });
    getData();
  }
  getData()async{
    var data= await AppPreferences.getCompanylogo();
    var cName= await AppPreferences.getCompanyName();
    print("jvbvbv  $data");
   // logo=await CommonWidget.convertBytesToFile(jsonDecode(data),cName);
    String companyId = await AppPreferences.getCompanyId();
    // setState(() {
    //   logo=logo;
    // });
    await  fetchAndSaveFile();
  }

  Widget _buildViewer() {
    if (widget.extension == "pdf") {
      print("FILE $localFilePath");
      if (widget.extension == "pdf") {
        if (localFilePath != null) {
          return SfPdfViewer.file(File(localFilePath!));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      } else {
        return Center(child: Text("${ApplicationLocalizations.of(context).translate("preview_not_supported_for")}"));
      }
    } else if (widget.extension == "txt") {
      return FutureBuilder<String>(
        future: File(localFilePath!).readAsString(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Text(snapshot.data ?? ""),
          );
        },
      );
    } else {
      return Center(
        child: Text(
          "${ApplicationLocalizations.of(context).translate("preview_not_supported_for")} .${widget.extension}\n${ApplicationLocalizations.of(context).translate("tap_the_download_button_to_export")}",
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: SafeArea(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)),
            color: Colors.transparent,
            // color: Colors.red,
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: AppBar(
              leadingWidth: 0,
              automaticallyImplyLeading: false,
              title: Container(
                width: SizeConfig.screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const FaIcon(Icons.arrow_back),
                    ),
                   /* Container(
                      height: SizeConfig.screenHeight * .05,
                      width: SizeConfig.screenHeight * .05,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          image: DecorationImage(
                            image:AssetImage(widget.logoImage),
                           // image: FileImage(logo!),
                            fit: BoxFit.cover,
                          )),
                    ),*/

                    Expanded(
                      child: Center(
                        child: Text(
                          "${widget.reportname} ${ApplicationLocalizations.of(context).translate("report")}",
                          style: appbar_text_style,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                if (localFilePath != null)
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: _shareFile,
                  ),
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),

      backgroundColor: CommonColor.BACKGROUND_COLOR,

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localFilePath != null
          ? _buildViewer()
          :  Center(child: Text("${ApplicationLocalizations.of(context).translate("no_file_loaded")}")),
    );
  }


  Future<void> fetchAndSaveFile() async {
    setState(() => isLoading = true);
    try {

      if(widget.model==null) {
        // final response = await http.get(Uri.parse(widget.apiUrl));
        // if (response.statusCode == 200) {
        //   final data = json.decode(response.body);
        //
        //   final List<int> bytes = data['data'].cast<int>();
        //   // ✅ Check if it's actually a PDF
        //   final isPdf = bytes.length > 4 &&
        //       bytes[0] == 37 &&
        //       bytes[1] == 80 &&
        //       bytes[2] == 68 &&
        //       bytes[3] == 70;
        //
        //   print(
        //       "IS PDF : ${isPdf} ${bytes[0]},${bytes[1]},${bytes[2]} ,${bytes[3]}");
        //   if (widget.extension == "pdf" && !isPdf) {
        //     throw Exception("Downloaded file is not a valid PDF");
        //   }
        //
        //   // ✅ Use temporary directory to avoid permission issues
        //   final dir = await getTemporaryDirectory();
        //   final filePath = '${dir.path}/${widget.name}.${widget.extension}';
        //
        //   final file = File(filePath);
        //   await file.writeAsBytes(bytes as List<int>, flush: true);
        //
        //   print("Saved at: $filePath, size: ${bytes.length} bytes");
        //
        //   setState(() {
        //     localFilePath = filePath;
        //   });
        // } else {
        //   throw Exception("Failed with status: ${response.statusCode}");
        // }
        await getPDFDataToByte();
      }
      else if(widget.model!=null){
        InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
        if (netStatus == InternetConnectionStatus.connected) {
          AppPreferences.getDeviceId().then((deviceId) {
            setState(() {
              isLoading = true;
            });
            var model=widget.model;

            print("Here");

            apiRequestHelper.callAPIsForDynamicPI(context,widget.apiUrl.toString(), model, "",
                onSuccess: (data) async {
                  print(data);
                  setState(() {
                    isLoading = true;
                  });
                  if(data.runtimeType!=String) {
                    final List<int> bytes = data.cast<int>();
                    // ✅ Check if it's actually a PDF
                    final isPdf = bytes.length > 4 &&
                        bytes[0] == 37 &&
                        bytes[1] == 80 &&
                        bytes[2] == 68 &&
                        bytes[3] == 70;

                    print(
                        "IS PDF : ${isPdf} ${bytes[0]},${bytes[1]},${bytes[2]} ,${bytes[3]}");
                    if (widget.extension == "pdf" && !isPdf) {
                      throw Exception("${ApplicationLocalizations.of(context).translate("file_not_pdf")}");
                    }

                    // ✅ Use temporary directory to avoid permission issues
                    final dir = await getTemporaryDirectory();
                    final filePath = '${dir.path}/${widget.name}.${widget
                        .extension}';

                    final file = File(filePath);
                    await file.writeAsBytes(bytes as List<int>, flush: true);

                    print("Saved at: $filePath, size: ${bytes.length} bytes");

                    setState(() {
                      localFilePath = filePath;
                    });
                  }
                  setState(() {
                    isLoading = false;
                  });

                }, onFailure: (error) {
                  setState(() {
                    isLoading = false;
                  });
                  CommonWidget.errorDialog(context, error.toString());
                }, onException: (e) {
                  setState(() {
                    isLoading = false;
                  });
                  CommonWidget.errorDialog(context, e.toString());
                }, sessionExpire: (e) {
                  setState(() {
                    isLoading = false;
                  });
                  CommonWidget.gotoLoginScreen(context);
                  // widget.mListener.loaderShow(false);
                });
          });
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          CommonWidget.noInternetDialogNew(context);
        }
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  getPDFDataToByte() async {

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus != InternetConnectionStatus.connected) {
      CommonWidget.noInternetDialogNew(context);
      return;
    }

    try {
      final apiUrl = widget.apiUrl;

      print(apiUrl);
      // Direct GET request for bytes
      try {
        print("Fetching PDF from: ${widget.apiUrl}");
        final response = await http.get(Uri.parse(widget.apiUrl));

        if (response.statusCode == 200) {
          // 🔥 Get raw bytes
          final bytes = response.bodyBytes;
          print("PDF saved at: ${ response.bodyBytes}");
          // ✅ Save PDF to temp directory
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/document.pdf');
          await file.writeAsBytes(bytes, flush: true);

          print("PDF saved at: ${file.path}");

          setState(() {
            localFilePath = file.path;
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);

          throw Exception("${ApplicationLocalizations.of(context).translate("fail_to_load_pdf")}: ${response.statusCode}");
        }
      } catch (e) {
        print("Error fetching PDF: $e");
        setState(() => isLoading = false);
      }

    } catch (e) {
      setState(() => isLoading = false);

      CommonWidget.errorDialog(context, e.toString());
    }
  }

  void _shareFile() {
    if (localFilePath != null) {
      Share.shareXFiles(
        [XFile(localFilePath!)],
        text: "${ApplicationLocalizations.of(context).translate("here_is_ur_file")}",
      );
    }
  }
}
