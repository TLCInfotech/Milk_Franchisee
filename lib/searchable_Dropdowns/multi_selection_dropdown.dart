import 'package:flutter/material.dart';


import '../common_widget/common.dart';
import '../core/app_preferance.dart';
import '../core/colors.dart';
import '../core/common_style.dart';
import '../core/localss/api_data_fetch_localization.dart';
import '../core/size_config.dart';
import '../data/commonRequest/get_toakn_request.dart';
import '../data/request_helper.dart';

class MultiSelectDropdown extends StatefulWidget {
  final String title;
  final String apiUrl;
  final sourceDB;
  final String nameField;
  final String idField;
  final bool mandatory;
  final List selectedItems;
  final Function(List) onSelectionChanged;

  const MultiSelectDropdown({
    super.key,
    required this.title,
    required this.apiUrl,
    this.sourceDB,
    required this.nameField,
    required this.idField,
    required this.selectedItems,
    required this.onSelectionChanged,
    this.mandatory = false,
  });

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  final ApiRequestHelper api = ApiRequestHelper();

  List<Map<String, dynamic>> dataList = [];
  List selectedItemsLocal = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedItemsLocal = List.from(widget.selectedItems);
    _fetchData();
  }

  Future<void> _fetchData() async {
    String companyId = await AppPreferences.getCompanyId();
    String baseurl = await AppPreferences.getDomainLink();
    String sessionToken = await AppPreferences.getSessionToken();

    final url = "$baseurl${widget.apiUrl}Company_ID=$companyId";
    TokenRequestModel model = TokenRequestModel(token: sessionToken);
print(url);
    api.callAPIsForGetAPI(context,
      url,
      model.toJson(),
      "",
      onSuccess: (response) {
        setState(() {
          dataList =
          response != null ? List<Map<String, dynamic>>.from(response) : [];
          isLoading = false;
        });
      },
      onFailure: (error) {
        CommonWidget.errorDialog(context, error);
        setState(() => isLoading = false);
      },
      onException: (e) {
        CommonWidget.errorDialog(context, e);
        setState(() => isLoading = false);
      },
      sessionExpire: (_) => setState(() => isLoading = false),
    );
  }

  void _openMultiSelectDialog() async {
    List tempSelected = List.from(selectedItemsLocal);
    String search = "";

    final List? result = await showDialog<List>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            /// 🔍 SEARCH FILTER
            final filtered = dataList.where((item) {
              return item[widget.nameField]
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase());
            }).toList();

            /// ✅ SELECTED FIRST
            final selectedList = filtered
                .where((e) => tempSelected.contains(e[widget.idField]))
                .toList();

            final unSelectedList = filtered
                .where((e) => !tempSelected.contains(e[widget.idField]))
                .toList();

            final finalList = [...selectedList, ...unSelectedList];

            return AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Text(widget.title),
              content: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * .9,
                child: Column(
                  children: [
                    /// 🔍 SEARCH
                    TextField(
                      decoration:  InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText:ApplicationLocalizations.of(context).translate("search"),
                      ),
                      onChanged: (v) {
                        setStateDialog(() {
                          search = v;
                        });
                      },
                    ),

                    /// 🏷 SELECTED TEXT BOX
                    if (tempSelected.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border:
                                Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  tempSelected
                                      .map((id) {
                                    final item = dataList.firstWhere(
                                          (e) => e[widget.idField] == id,
                                      orElse: () => {},
                                    );
                                    return item.isNotEmpty
                                        ? item[widget.nameField].toString()
                                        : "";
                                  })
                                      .where((e) => e.isNotEmpty)
                                      .join(", "),
                                  style: item_heading_textStyle.copyWith(
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    const Divider(),

                    /// 📋 LIST OR EMPTY UI
                    Expanded(
                      child: finalList.isEmpty
                          ?  Center(
                        child: Text(
                          "${ApplicationLocalizations.of(context).translate("no_record_found")}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                          : ListView.builder(
                        itemCount: finalList.length,
                        itemBuilder: (context, index) {
                          final item = finalList[index];
                          final value = item[widget.idField];
                          final checked =
                          tempSelected.contains(value);

                          return CheckboxListTile(
                            value: checked,
                            title: Text(
                                item[widget.nameField].toString()),
                            onChanged: (v) {
                              setStateDialog(() {
                                if (v == true) {
                                  tempSelected.add(value);
                                } else {
                                  tempSelected.remove(value);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    setStateDialog(() {
                      tempSelected.clear();
                    });
                  },
                  child: const Text("Unselect All",
                      style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, widget.selectedItems);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, tempSelected);
                  },
                  child:  Text("${ApplicationLocalizations.of(context).translate("apply")}"),
                ),
              ],
            );
          },
        );
      },
    );

    /// ✅ RESULT
    if (result != null) {
      setState(() => selectedItemsLocal = result);
      widget.onSelectionChanged(selectedItemsLocal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = dataList
        .where((e) => selectedItemsLocal.contains(e[widget.idField]))
        .map((e) => e[widget.nameField].toString())
        .join(", ");

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.mandatory
              ? RichText(
            text: TextSpan(
              text: widget.title,
              style: item_heading_textStyle.copyWith(
                  color: Colors.black),
              children: const [
                TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          )
              : Text(widget.title,
              style: item_heading_textStyle.copyWith(
                  color: Colors.black)),
          const SizedBox(height: 6),

          InkWell(
            onTap: isLoading ? null : _openMultiSelectDialog,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth * .03,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: CommonColor.WHITE_COLOR,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(.1),
                  )
                ],
              ),
              child: isLoading
                  ? const Center(
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child:
                  CircularProgressIndicator(strokeWidth: 2),
                ),
              )
                  : Text(
                displayText.isEmpty
                    ? "Select ${widget.title}"
                    : displayText,
                style: displayText.isEmpty
                    ? item_heading_textStyle
                    .copyWith(color: Colors.grey)
                    : item_heading_textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
