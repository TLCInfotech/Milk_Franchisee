import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../core/localss/api_data_fetch_localization.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';

// तुझे imports
import '../../core/app_preferance.dart';
import '../../core/common_style.dart';
import '../../core/internet_check.dart';
import '../../core/size_config.dart';
import '../core/colors.dart';
import '../data/commonRequest/get_toakn_request.dart';
import '../data/request_helper.dart';
import 'common.dart';

class APIFileViewer extends StatefulWidget {
  final String apiUrl;
  final String extension;
  final String name;
  final String reportname;
  final dynamic model;
  final dynamic logoImage;

  const APIFileViewer({
    super.key,
    required this.apiUrl,
    required this.extension,
    required this.name,
    required this.model,
    required this.reportname,
    this.logoImage,
  });

  @override
  State<APIFileViewer> createState() => APIFileViewerState();
}

class APIFileViewerState extends State<APIFileViewer> {
  String? localFilePath;
  String reportName = "";
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  bool isLoading = false;
  File? logo;

  @override
  void initState() {
    super.initState();
    reportName = widget.reportname;
   getData(widget.apiUrl);
  }

  Future<void> getData(apiurl) async {
    var data = await AppPreferences.getCompanylogo();
    var cName = await AppPreferences.getCompanyName();
    logo = await CommonWidget.convertBytesToFile(jsonDecode(data), cName);
    await fetchAndSaveFile(apiurl);
    setState(() {}); // UI refresh
  }

  Future<void> fetchAndSaveFile(apiurl) async {
    setState(() => isLoading = true);
    try {
      if (widget.model == null) {
        await getPDFData(apiurl);
      } else {
        await _fetchWithModel();
      }
    } catch (e) {
      debugPrint("Error in fetchAndSaveFile: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> getPDFData(apiurl) async {
    String sessionToken = await AppPreferences.getSessionToken();
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected) {
      TokenRequestModel model =
      TokenRequestModel(token: sessionToken, page: "1");
      apiRequestHelper.callAPIsForGetAPI(context,
        apiurl,
        model.toJson(),
        "",
        onSuccess: (data) async {
          if (data != null) {
            try {
              final List<int> bytes = List<int>.from(data);
              await _saveFile(bytes);
            } catch (e) {
              debugPrint("Error decoding file: $e");
            }
          }
        },
        onFailure: (error) {
          CommonWidget.errorDialog(context, error.toString());
        },
        onException: (e) {
          CommonWidget.errorDialog(context, e.toString());
        },
        sessionExpire: (e) {
          CommonWidget.gotoLoginScreen(context);
        },
      );
    } else {
      CommonWidget.noInternetDialogNew(context);
    }
  }

  Future<void> _fetchWithModel() async {
    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected) {
      apiRequestHelper.callAPIsForDynamicPI(context,
        widget.apiUrl,
        widget.model,
        "",
        onSuccess: (data) async {
          if (data != null && data is List<int>) {
            await _saveFile(data);
          }
        },
        onFailure: (error) {
          CommonWidget.errorDialog(context, error.toString());
        },
        onException: (e) {
          CommonWidget.errorDialog(context, e.toString());
        },
        sessionExpire: (e) {
          CommonWidget.gotoLoginScreen(context);
        },
      );
    } else {
      CommonWidget.noInternetDialogNew(context);
    }
  }

  Future<void> _saveFile(List<int> bytes) async {
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/${widget.name}.${widget.extension}';
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      localFilePath = filePath;
    });
  }

  void _shareFile() {
    if (localFilePath != null) {
      Share.shareXFiles(
        [XFile(localFilePath!)],
        text: "Here is your file: ${widget.reportname}",
      );
    }
  }

  Widget _buildViewer() {
    if (localFilePath == null) {
      return const Center(child: Text("No file loaded"));
    }

    if (widget.extension == "pdf") {
      return SfPdfViewer.file(File(localFilePath!));
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
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: AppBar(
              leadingWidth: 0,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const FaIcon(Icons.arrow_back),
                  ),
                  if (logo != null)
                    Container(
                      height: SizeConfig.screenHeight * .05,
                      width: SizeConfig.screenHeight * .05,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        image: DecorationImage(
                          image: FileImage(logo!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "${widget.reportname} Report",
                        style: appbar_text_style,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                if (localFilePath != null)
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: _shareFile,
                  ),
              ],
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ),
      ),
      backgroundColor: CommonColor.BACKGROUND_COLOR,
      body: Stack(
        children: [
          localFilePath != null
              ? _buildViewer()
              : const Center(child: Text("")),
          if (isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
