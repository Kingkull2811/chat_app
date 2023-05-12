import 'package:chat_app/network/model/student.dart';
import 'package:chat_app/screens/transcript/transcript_management/transcript_management_event.dart';
import 'package:chat_app/screens/transcript/transcript_management/transcript_management_state.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:chat_app/widgets/data_not_found.dart';
import 'package:chat_app/widgets/input_field_with_ontap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/model/class_model.dart';
import '../../../utilities/app_constants.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../widgets/animation_loading.dart';
import '../../../widgets/primary_button.dart';
import 'transcript_management_bloc.dart';

class TranscriptManagementPage extends StatefulWidget {
  const TranscriptManagementPage({Key? key}) : super(key: key);

  @override
  State<TranscriptManagementPage> createState() =>
      _TranscriptManagementPageState();
}

class _TranscriptManagementPageState extends State<TranscriptManagementPage> {
  late TranscriptManagementBloc _transcriptBloc;

  final _schoolYearController = TextEditingController();
  final _classController = TextEditingController();

  String _yearSelected = '2023-2024';
  String _classSelected = '';
  int? classIdSelected;

  final _searchController = TextEditingController();

  bool _showSearchResult = false;

  @override
  void initState() {
    _transcriptBloc = BlocProvider.of<TranscriptManagementBloc>(context)
      ..add(InitTranscriptEvent());
    _schoolYearController.text = '2023-2024';
    super.initState();
  }

  @override
  void dispose() {
    _transcriptBloc.close();
    _schoolYearController.dispose();
    _classController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TranscriptManagementBloc, TranscriptManagementState>(
      listenWhen: (preState, curState) {
        return curState.apiError != ApiError.noError;
      },
      listener: (context, curState) {
        if (curState.apiError == ApiError.internalServerError) {
          showCupertinoMessageDialog(
            context,
            'Error!',
            content: 'Internal_server_error',
          );
        }
        if (curState.apiError == ApiError.noInternetConnection) {
          showMessageNoInternetDialog(context);
        }
      },
      builder: (context, curState) {
        Widget body = const SizedBox.shrink();
        if (curState.isLoading) {
          body = const Scaffold(body: AnimationLoading());
        } else {
          body = _body(context, curState);
        }
        return body;
      },
    );
  }

  Widget _body(BuildContext context, TranscriptManagementState state) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Theme.of(context).primaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Transcript Management',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       showCupertinoModalPopup(
        //         context: context,
        //         builder: (context) {
        //           return CupertinoActionSheet(
        //             actions: <Widget>[
        //               CupertinoActionSheetAction(
        //                 onPressed: () async {
        //                   Navigator.pop(context);
        //                   await showModalBottomSheet(
        //                     context: context,
        //                     isScrollControlled: true,
        //                     backgroundColor: Colors.transparent,
        //                     builder: (context) => _formSubjectInfo(context),
        //                   ).whenComplete(() {
        //                     _transcriptBloc.add(InitTranscriptEvent());
        //                     setState(() {
        //                       _subjectCodeController.clear();
        //                       _subjectNameController.clear();
        //                     });
        //                   });
        //                 },
        //                 child: Text(
        //                   'Add new subject',
        //                   style: TextStyle(
        //                     fontSize: 18,
        //                     color: Theme.of(context).primaryColor,
        //                   ),
        //                 ),
        //               ),
        //             ],
        //             cancelButton: CupertinoActionSheetAction(
        //               onPressed: () async {
        //                 Navigator.pop(context);
        //               },
        //               child: Text(
        //                 'Cancel',
        //                 style: TextStyle(
        //                   fontSize: 16,
        //                   color: Colors.black.withOpacity(0.7),
        //                 ),
        //               ),
        //             ),
        //           );
        //         },
        //       );
        //     },
        //     icon: const Icon(
        //       Icons.more_vert_outlined,
        //       size: 24,
        //       color: Colors.white,
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _searchBox(context),
              Padding(
                padding: EdgeInsets.fromLTRB(48, 0, 48, 16),
                child: SizedBox(
                  height: 40,
                  child: InputField(
                    context: context,
                    controller: _schoolYearController,
                    readOnly: true,
                    showSuffix: true,
                    textAlign: TextAlign.center,
                    onTap: () {
                      _dialogSelectSchoolYear(AppConstants.listSchoolYear);
                    },
                    labelText: 'School Year',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(48, 0, 48, 16),
                child: SizedBox(
                  height: 40,
                  child: InputField(
                    context: context,
                    controller: _classController,
                    readOnly: true,
                    showSuffix: true,
                    textAlign: TextAlign.center,
                    onTap: () {
                      _dialogSelectClass(state.listClass);
                    },
                    labelText: 'Class',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Container(
                    height: 40,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      'Search',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _dialogSelectSchoolYear(List<String> schoolYear) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Select School Year',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          height: 40 * schoolYear.length.toDouble(),
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: schoolYear.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                setState(() {
                  _schoolYearController.text = schoolYear[index];
                });
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: (schoolYear[index] == _schoolYearController.text)
                      ? Colors.grey.withOpacity(0.3)
                      : Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          schoolYear[index],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    if (schoolYear[index] == _schoolYearController.text)
                      const Padding(
                        padding: EdgeInsets.only(left: 10, right: 16),
                        child: Icon(
                          Icons.check,
                          size: 24,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _dialogSelectClass(List<ClassModel>? listClass) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Select Class',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 200,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: isNullOrEmpty(listClass)
              ? const DataNotFoundPage(title: 'Class data not found')
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: listClass!.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      setState(() {
                        _classController.text =
                            '${listClass[index].code} - ${listClass[index].className}';
                        classIdSelected = listClass[index].classId;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: classIdSelected == listClass[index].classId
                            ? Colors.grey.withOpacity(0.2)
                            : Colors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                '${listClass[index].code} - ${listClass[index].className}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ),
                          if (classIdSelected == listClass[index].classId)
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 16),
                              child: Icon(
                                Icons.check,
                                size: 24,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _searchBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SizedBox(
        height: 40,
        child: TextField(
          onTap: () {
            setState(() {
              _showSearchResult = !_showSearchResult;
            });
          },
          controller: _searchController,
          onSubmitted: (_) {
            if (_searchController.text.isEmpty) {
              setState(() {
                _showSearchResult = false;
              });
            }
          },
          decoration: InputDecoration(
            hintText: 'Search student ...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(
                width: 1,
                color: Color.fromARGB(128, 130, 130, 130),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formSubjectInfo(
    BuildContext context, {
    bool isEdit = false,
    Student? student,
  }) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.white,
            ),
          ),
          title: Text(
            isEdit ? 'Edit subject' : 'Add new subject',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (isEdit)
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: _inputText(
                    context,
                    controller: _schoolYearController,
                    inputAction: TextInputAction.done,
                    labelText: 'Subject Code',
                    initText: isEdit ? '${student?.code}' : '',
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(top: isEdit ? 16 : 32),
                child: _inputText(
                  context,
                  controller: _classController,
                  inputAction: TextInputAction.done,
                  labelText: 'Subject Name',
                  initText: isEdit ? '${student?.name}' : '',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: PrimaryButton(
                  text: isEdit ? 'Update' : 'Save',
                  onTap: () {
                    if (_schoolYearController.text.isEmpty && isEdit) {
                      showCupertinoMessageDialog(
                          context, 'Subject Code can\'t be empty');
                    } else if (_classController.text.isEmpty) {
                      showCupertinoMessageDialog(
                          context, 'Subject Name can\'t be empty');
                    } else {
                      final Map<String, dynamic> data = {
                        "code": _schoolYearController.text.trim(),
                        "name": _classController.text.trim()
                      };
                      isEdit
                          ? _transcriptBloc.add(
                              EditTranscriptEvent(
                                subjectId: (student?.id)!,
                                data: data,
                              ),
                            )
                          : _transcriptBloc.add(AddTranscriptEvent(data: data));
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputText(
    BuildContext context, {
    TextEditingController? controller,
    TextInputAction? inputAction,
    String? initText,
    String? labelText,
    String? hintText,
    Function()? onTap,
    bool readOnly = false,
  }) {
    if (initText != null) {
      controller?.text = initText;
      controller?.selection = TextSelection(
        baseOffset: 0,
        extentOffset: initText.length,
      );
    }
    return SizedBox(
      height: 50,
      child: TextFormField(
        onTap: onTap,
        readOnly: readOnly,
        controller: controller,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: inputAction ?? TextInputAction.done,
        onFieldSubmitted: (value) {},
        onChanged: (_) {},
        keyboardType: TextInputType.text,
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 26, 26, 26),
        ),
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            contentPadding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
            filled: true,
            fillColor: const Color.fromARGB(102, 230, 230, 230),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                width: 1,
                color: Color.fromARGB(128, 130, 130, 130),
              ),
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6))),
      ),
    );
  }
}
