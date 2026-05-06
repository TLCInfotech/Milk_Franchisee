import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../core/colors.dart';
import '../core/localss/api_data_fetch_localization.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../core/app_preferance.dart';
import '../../core/common_style.dart';
import '../../core/internet_check.dart';
import '../../core/size_config.dart';
import '../data/request_helper.dart';
import '../data/response_for_fetch.dart';
import 'common.dart';

class APIFileViewerForPostModel extends StatefulWidget {
  final String apiUrl;
  final String extension;
  final String name;
  final String reportname;
  final  model;
  //final logoImage;

  const APIFileViewerForPostModel({
    super.key,
    required this.apiUrl,
    required this.extension,
    required this.name,
    required this.model,
    required this.reportname,// required this.logoImage
  });

  @override
  State<APIFileViewerForPostModel> createState() => _APIFileViewerForPostModelState();
}

class _APIFileViewerForPostModelState extends State<APIFileViewerForPostModel> {
  String? localFilePath;
  String reportName="";
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  bool isLoading = false;

  Future<void> fetchAndSaveFile() async {
    setState(() => isLoading = true);
    // try {
print("gghhggh  ${widget.model}");

    if(widget.model!=null){
      print("oneeeee.....");
      InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
      if (netStatus == InternetConnectionStatus.connected) {
        AppPreferences.getDeviceId().then((deviceId) async {
          setState(() {
            isLoading = true;
          });
          var model=widget.model;
          String jsonString="";
          //try {
          Map<String, dynamic> cleanedData = {};
          model.forEach((key, value) {
            // print(value);
            if (value != null && value != "" && value.toString() != "[]") {
              cleanedData[key] = jsonDecode(jsonEncode(value));
            }
          });
          print("#########s#33ew");

          jsonString= json.encode(cleanedData);
          print("Hereeeeeeeee   ${widget.model}");
          try {

            final response = await http.post(
              Uri.parse(widget.apiUrl.toString()),
              body: jsonString, // जर JSON body पाठवायचा असेल तर jsonEncode वापर
              headers: {
                "Content-Type": "application/json",
              },
            ).timeout(const Duration(minutes: 3));
            print("   jnkjfwbhjfwbhjw22   ${response.statusCode}");

            switch (response.statusCode) {
            /*response of api status id zero when something is wrong*/
              case 400:
                ApiResponseForFetch apiResponse = ApiResponseForFetch();
                apiResponse =
                    ApiResponseForFetch.fromJson(json.decode(response.body));
                CommonWidget.errorDialog(context, apiResponse.msg.toString());
                print("response.data  0 400 ${apiResponse.msg}");
                setState(() {
                  isLoading = false;
                });
                break;
              case 200:
                try {
                  // ApiResponseForFetch apiResponse = ApiResponseForFetch();
                  // apiResponse = ApiResponseForFetch.fromJson(json.decode((response.body)));
                  final bytes = response.bodyBytes;
                  print("vbbfvb $bytes  ${response.statusCode}");
                  // // ✅ Check if it's really a PDF (first 4 bytes: %PDF)
                  // final isPdf = bytes.length > 4 &&
                  //     bytes[0] == 37 &&
                  //     bytes[1] == 80 &&
                  //     bytes[2] == 68 &&
                  //     bytes[3] == 70;
                  //
                  // if (!isPdf) {
                  //   throw Exception("Downloaded file is not a valid PDF");
                  // }

                  if(response.body.length>50) {
                    // ✅ Save PDF in temp directory
                    final dir = await getTemporaryDirectory();
                    final file = File('${dir.path}/document.pdf');
                    await file.writeAsBytes(bytes, flush: true);

                    debugPrint("PDF saved at: ${file.path}");
                    setState(() {
                      localFilePath = file.path;
                      isLoading = false;
                    });
                  }
                  else{
                    setState(() {
                      isLoading = false;

                    });
                  }

                  // ✅ इथे PDF viewer open कर
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (_) => PdfViewerScreen(path: file.path),
                  // ));

                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                  print(e);
                }
                break;
              case 500:
                ApiResponseForFetch apiResponse = ApiResponseForFetch();
                apiResponse =
                    ApiResponseForFetch.fromJson(json.decode(response.body));
                CommonWidget.errorDialog(context, apiResponse.msg.toString());
                print("onExceptionnnn   ${apiResponse.msg}");
                setState(() {
                  isLoading = false;
                });
                break;
              case 404:
                ApiResponseForFetch apiResponse = ApiResponseForFetch();
                apiResponse =
                    ApiResponseForFetch.fromJson(json.decode(response.body));
                CommonWidget.errorDialog(context, apiResponse.msg.toString());
                setState(() {
                  isLoading = false;
                });
                break;
              case 401:
                ApiResponseForFetch apiResponse = ApiResponseForFetch();
                apiResponse =
                    ApiResponseForFetch.fromJson(json.decode(response.body));
                CommonWidget.errorDialog(context, apiResponse.msg.toString());
                setState(() {
                  isLoading = false;
                });
                print("newww  ${apiResponse.msg}");
                break;
              case 403:
                AppPreferences.clearAppPreference();
                CommonWidget.errorDialog(context, "Session".toString());
                setState(() {
                  isLoading = false;
                });
                break;
            }
          }
          on TimeoutException catch (_) {
            CommonWidget.errorDialog(context,"⏳ Server timeout. Please try again.");
            setState(() {
              isLoading = false;
            });
          }
          on SocketException catch (_) {
            CommonWidget.errorDialog(context,"❌ Server is offline or internet not available.");
            setState(() {
              isLoading = false;
            });
          }
          on http.ClientException catch (_) {
            CommonWidget.errorDialog(context,"⚠️ Unable to connect to server.");
            setState(() {
              isLoading = false;
            });
          }
          catch (e) {
            print(e);
            if (e.toString() == "Connection refused") {
              CommonWidget.errorDialog(context,"⚠️ Timeout: Server not reachable within 60 seconds.");
              setState(() {
                isLoading = false;
              });
            } else if (e.toString().substring(0, e.toString().indexOf(":")) ==
                "ClientException with SocketException") {
              CommonWidget.errorDialog(context,"⚠️ Server Not Reachable!Please contact to Admin.");
              setState(() {
                isLoading = false;
              });
            } else
              CommonWidget.errorDialog(context,
                  "⚠️" + e.toString().substring(0, e.toString().indexOf(":")));
            setState(() {
              isLoading = false;
            });
          }
          // // 🔥 API Call with POST
          // final response = await http.post(
          //   Uri.parse(widget.apiUrl.toString()),
          //   body: jsonString, // जर JSON body पाठवायचा असेल तर jsonEncode वापर
          //   headers: {
          //     "Content-Type": "application/json",
          //   },
          // );
          // if (response.statusCode == 200) {
          //   final bytes = response.bodyBytes;
          //
          //   // // ✅ Check if it's really a PDF (first 4 bytes: %PDF)
          //   // final isPdf = bytes.length > 4 &&
          //   //     bytes[0] == 37 &&
          //   //     bytes[1] == 80 &&
          //   //     bytes[2] == 68 &&
          //   //     bytes[3] == 70;
          //   //
          //   // if (!isPdf) {
          //   //   throw Exception("Downloaded file is not a valid PDF");
          //   // }
          //
          //   // ✅ Save PDF in temp directory
          //   final dir = await getTemporaryDirectory();
          //   final file = File('${dir.path}/document.pdf');
          //   await file.writeAsBytes(bytes, flush: true);
          //
          //   debugPrint("PDF saved at: ${file.path}");
          //   setState(() {
          //     localFilePath = file.path;
          //     isLoading = false;
          //   });
          //
          //   debugPrint("PDF saved at:1111 ${localFilePath}");
          //   // ✅ इथे PDF viewer open कर
          //   // Navigator.push(context, MaterialPageRoute(
          //   //   builder: (_) => PdfViewerScreen(path: file.path),
          //   // ));
          //
          // }
          /*  apiRequestHelper.callAPIsForDynamicPI(context,widget.apiUrl.toString(), model, "",
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
                      throw Exception("Downloaded file is not a valid PDF");
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
                });*/
        });
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        CommonWidget.noInternetDialogNew(context);
      }
    }else {
      print("twoooo..... ");
      InternetConnectionStatus netStatus = await InternetChecker
          .checkInternet();
      if (netStatus == InternetConnectionStatus.connected) {
        AppPreferences.getDeviceId().then((deviceId) async {
          setState(() {
            isLoading = true;
          });
          var model = widget.model;
          //try {

          // 🔥 IMPORTANT: POST WITHOUT BODY
          final request = http.Request("POST", Uri.parse(widget.apiUrl));

          request.headers.addAll({
            "Accept": "application/json",
            "Content-Type": "application/json",
          });

          // ❌ BODY BILKUL NAHI BHEJNA
          // request.body = jsonEncode({"Party": [], "Item": []});

          final streamedResponse = await request.send();
          try {

            final response = await http.Response.fromStream(streamedResponse).timeout(const Duration(minutes: 3));
            print("   jnkjfwbhjfwbhjw22   ${response.statusCode}");

            switch (response.statusCode) {
            /*response of api status id zero when something is wrong*/
              case 400:
                ApiResponseForFetch apiResponse = ApiResponseForFetch();
                apiResponse =
                    ApiResponseForFetch.fromJson(json.decode(response.body));
                CommonWidget.errorDialog(context, apiResponse.msg.toString());
                print("response.data  0 400 ${apiResponse.msg}");
                setState(() {
                  isLoading = false;
                });
                break;
              case 200:
                try {
                  final bytes = response.bodyBytes;

                  // // ✅ Check if it's really a PDF (first 4 bytes: %PDF)
                  // final isPdf = bytes.length > 4 &&
                  //     bytes[0] == 37 &&
                  //     bytes[1] == 80 &&
                  //     bytes[2] == 68 &&
                  //     bytes[3] == 70;
                  //
                  // if (!isPdf) {
                  //   throw Exception("Downloaded file is not a valid PDF");
                  // }

                  // ✅ Save PDF in temp directory
                  final dir = await getTemporaryDirectory();
                  final file = File('${dir.path}/document.pdf');
                  await file.writeAsBytes(bytes, flush: true);

                  debugPrint("PDF saved at: ${file.path}");
                  setState(() {
                    localFilePath = file.path;
                    isLoading = false;
                  });
                  setState(() {
                    isLoading = false;
                  });
                  debugPrint("PDF saved at:1111 ${localFilePath}");

                } catch (e) {
                  print(e);
                  setState(() {
                    isLoading = false;
                  });
                }
                break;
              case 500:
                ApiResponseForFetch apiResponse = ApiResponseForFetch();
                apiResponse =
                    ApiResponseForFetch.fromJson(json.decode(response.body));
                CommonWidget.errorDialog(context, apiResponse.msg.toString());
                print("onExceptionnnn   ${apiResponse.msg}");
                setState(() {
                  isLoading = false;
                });
                break;
              case 404:
                ApiResponseForFetch apiResponse = ApiResponseForFetch();
                apiResponse =
                    ApiResponseForFetch.fromJson(json.decode(response.body));
                CommonWidget.errorDialog(context, apiResponse.msg.toString());
                setState(() {
                  isLoading = false;
                });
                break;
              case 401:
                ApiResponseForFetch apiResponse = ApiResponseForFetch();
                apiResponse =
                    ApiResponseForFetch.fromJson(json.decode(response.body));
                CommonWidget.errorDialog(context, apiResponse.msg.toString());
                print("newww  ${apiResponse.msg}");
                setState(() {
                  isLoading = false;
                });
                break;
              case 403:
                AppPreferences.clearAppPreference();
                CommonWidget.errorDialog(context, "Session".toString());
                setState(() {
                  isLoading = false;
                });
                break;
            }
          }
          on TimeoutException catch (_) {
            CommonWidget.errorDialog(context,"⏳ Server timeout. Please try again.");
            setState(() {
              isLoading = false;
            });
          }
          on SocketException catch (_) {
            CommonWidget.errorDialog(context,"❌ Server is offline or internet not available.");
            setState(() {
              isLoading = false;
            });
          }
          on http.ClientException catch (_) {
            CommonWidget.errorDialog(context,"⚠️ Unable to connect to server.");
            setState(() {
              isLoading = false;
            });
          }
          catch (e) {
            print(e);
            if (e.toString() == "Connection refused") {
              CommonWidget.errorDialog(context,"⚠️ Timeout: Server not reachable within 60 seconds.");
              setState(() {
                isLoading = false;
              });
            } else if (e.toString().substring(0, e.toString().indexOf(":")) ==
                "ClientException with SocketException") {
              CommonWidget.errorDialog(context,"⚠️ Server Not Reachable!Please contact to Admin.");
              setState(() {
                isLoading = false;
              });
            } else
              CommonWidget.errorDialog(context,
                  "⚠️" + e.toString().substring(0, e.toString().indexOf(":")));
            setState(() {
              isLoading = false;
            });
          }
          // final response = await http.Response.fromStream(streamedResponse);
          //
          // print("Status Code => ${response.statusCode}");
          // print("Response => ${response.body}");
          //
          // if (response.statusCode == 200) {
          //   final bytes = response.bodyBytes;
          //
          //   // // ✅ Check if it's really a PDF (first 4 bytes: %PDF)
          //   // final isPdf = bytes.length > 4 &&
          //   //     bytes[0] == 37 &&
          //   //     bytes[1] == 80 &&
          //   //     bytes[2] == 68 &&
          //   //     bytes[3] == 70;
          //   //
          //   // if (!isPdf) {
          //   //   throw Exception("Downloaded file is not a valid PDF");
          //   // }
          //
          //   // ✅ Save PDF in temp directory
          //   final dir = await getTemporaryDirectory();
          //   final file = File('${dir.path}/document.pdf');
          //   await file.writeAsBytes(bytes, flush: true);
          //
          //   debugPrint("PDF saved at: ${file.path}");
          //   setState(() {
          //     localFilePath = file.path;
          //     isLoading = false;
          //   });
          //
          //   debugPrint("PDF saved at:1111 ${localFilePath}");
          //   // ✅ इथे PDF viewer open कर
          //   // Navigator.push(context, MaterialPageRoute(
          //   //   builder: (_) => PdfViewerScreen(path: file.path),
          //   // ));
          //
          // }
          // /*  apiRequestHelper.callAPIsForDynamicPI(context,widget.apiUrl.toString(), model, "",
          //       onSuccess: (data) async {
          //     print(data);
          //         setState(() {
          //           isLoading = true;
          //         });
          //         if(data.runtimeType!=String) {
          //           final List<int> bytes = data.cast<int>();
          //           // ✅ Check if it's actually a PDF
          //           final isPdf = bytes.length > 4 &&
          //               bytes[0] == 37 &&
          //               bytes[1] == 80 &&
          //               bytes[2] == 68 &&
          //               bytes[3] == 70;
          //
          //           print(
          //               "IS PDF : ${isPdf} ${bytes[0]},${bytes[1]},${bytes[2]} ,${bytes[3]}");
          //           if (widget.extension == "pdf" && !isPdf) {
          //             throw Exception("Downloaded file is not a valid PDF");
          //           }
          //
          //           // ✅ Use temporary directory to avoid permission issues
          //           final dir = await getTemporaryDirectory();
          //           final filePath = '${dir.path}/${widget.name}.${widget
          //               .extension}';
          //
          //           final file = File(filePath);
          //           await file.writeAsBytes(bytes as List<int>, flush: true);
          //
          //           print("Saved at: $filePath, size: ${bytes.length} bytes");
          //
          //           setState(() {
          //             localFilePath = filePath;
          //           });
          //         }
          //     setState(() {
          //       isLoading = false;
          //     });
          //
          //       }, onFailure: (error) {
          //         setState(() {
          //           isLoading = false;
          //         });
          //         CommonWidget.errorDialog(context, error.toString());
          //       }, onException: (e) {
          //         setState(() {
          //           isLoading = false;
          //         });
          //         CommonWidget.errorDialog(context, e.toString());
          //       }, sessionExpire: (e) {
          //         setState(() {
          //           isLoading = false;
          //         });
          //         CommonWidget.gotoLoginScreen(context);
          //         // widget.mListener.loaderShow(false);
          //       });*/
        });
        // } else {
        //    if (mounted) {
        //      setState(() {
        //        isLoading = false;
        //      });
        //    }
        //    CommonWidget.noInternetDialogNew(context);
        //  }
      }
    }
    // }
  }

  getPDFDataToByte() async {

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus != InternetConnectionStatus.connected) {
      CommonWidget.noInternetDialogNew(context);
      return;
    }

    final apiUrl = widget.apiUrl;

    print(apiUrl);
    // Direct GET request for bytes
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
      throw Exception("Failed to load PDF: ${response.statusCode}");
    }

  }

  void _shareFile() {
    if (localFilePath != null) {
      Share.shareXFiles(
        [XFile(localFilePath!)],
        text: "Here is your file: MIS Report",
      );
    }
  }

  @override
  void initState() {
    super.initState();
    print("hgghhghg  ${widget.apiUrl}");
    setState(() {
      reportName=widget.reportname;
    });
    fetchAndSaveFile();
  }

  Widget _buildViewer() {
    print("object her $localFilePath");
    if (widget.extension == "pdf") {
      print("FILE $localFilePath");
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
    print("LOCAL : $localFilePath");
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: SafeArea(
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
                  /*  Container(
                    height: SizeConfig.screenHeight * .05,
                    width: SizeConfig.screenHeight * .05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        image: DecorationImage(
                          image:
                          FileImage(File(widget.logoImage)),
                          fit: BoxFit.cover,
                        )),
                  ),*/

                  Expanded(
                    child: Center(
                      child: Text(
                        "${widget.reportname}",
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

      backgroundColor: CommonColor.BACKGROUND_COLOR,

      body: isLoading
          ?  Center(child: CircularProgressIndicator())
          : (localFilePath==null || localFilePath=="null")
          ?
      Center(child: Text("${ApplicationLocalizations.of(context).translate("no_record_found")}",style: item_regular_textStyle,))
          : _buildViewer(),
    );
  }
}
