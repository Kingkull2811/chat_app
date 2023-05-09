import 'package:chat_app/network/model/class_model.dart';
import 'package:chat_app/screens/transcript/class_management/class_management_state.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/model/subject_model.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../widgets/animation_loading.dart';
import 'class_info/class_info.dart';
import 'class_info/class_info_bloc.dart';
import 'class_info/class_info_event.dart';
import 'class_management_bloc.dart';
import 'class_management_event.dart';

class ClassManagement extends StatefulWidget {
  const ClassManagement({Key? key}) : super(key: key);

  @override
  State<ClassManagement> createState() => _ClassManagementState();
}

class _ClassManagementState extends State<ClassManagement> {
  final Map<int, bool> _showInfo = {};
  final Map<int, bool> _isChecked = {};
  List<int> listSubjectSelected = [];

  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();

  late ClassManagementBloc _classManagementBloc;

  @override
  void initState() {
    _classManagementBloc = BlocProvider.of<ClassManagementBloc>(context)
      ..add(InitClassEvent());
    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _yearController.dispose();
    _classManagementBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassManagementBloc, ClassManagementState>(
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
        return Scaffold(
          appBar: _appBar(curState.listSubject),
          body: curState.isLoading
              ? const AnimationLoading()
              : _body(context, curState.listClass),
        );
      },
    );
  }

  Widget _body(BuildContext context, List<ClassModel>? listClass) {
    if (isNullOrEmpty(listClass)) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/image_wrong.png',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Class data not found',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: listClass!.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: Text(
              'List subject:',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        }
        return _createItemClass(index, listClass[index - 1]);
      },
    );
  }

  Widget _selectSubjectInClass(List<SubjectModel>? listSubject) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: GestureDetector(
        onTap: () => clearFocus(context),
        child: Scaffold(
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
            title: const Text(
              'Add new class',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: _inputText(
                      context,
                      controller: _codeController,
                      inputAction: TextInputAction.done,
                      labelText: 'Class Code',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _inputText(
                      context,
                      controller: _nameController,
                      inputAction: TextInputAction.done,
                      labelText: 'Class Name',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _inputText(
                      context,
                      readOnly: true,
                      controller: _yearController,
                      inputAction: TextInputAction.done,
                      labelText: 'Select year',
                    ),
                  ),
                  _listSemesterYear(AppConstants.listSemesterYear),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select subject in class',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: isNullOrEmpty(listSubject)
                        ? Center(
                            child: Text(
                              'Subject data not found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: listSubject!.length,
                            itemBuilder: (context, index) {
                              final isChecked = _isChecked[index] ?? false;

                              return SizedBox(
                                height: 50,
                                child: CheckboxListTile(
                                  value: isChecked,
                                  onChanged: (v) {
                                    if (v == true) {
                                      listSubjectSelected.add(
                                        listSubject[index].subjectId!,
                                      );
                                    } else {
                                      listSubjectSelected.remove(
                                        listSubject[index].subjectId!,
                                      );
                                    }
                                    setState(() {
                                      _isChecked[index] = v ?? false;
                                    });
                                  },
                                  title: Text(
                                    '${listSubject[index].code} - ${listSubject[index].subjectName}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listSemesterYear(List<String> listSemesterYear) {
    return Container(
      height: 40 * listSemesterYear.length.toDouble(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: isNotNullOrEmpty(listSemesterYear)
          ? ListView.builder(
              itemCount: listSemesterYear.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _yearController.text = listSemesterYear[index];
                    });
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: (_yearController.text == listSemesterYear[index])
                          ? Colors.grey.withOpacity(0.25)
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              listSemesterYear[index],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (_yearController.text == listSemesterYear[index])
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'List semester not found',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
    );
  }

  Widget _createItemClass(int index, ClassModel classInfo) {
    final isShowInfo = _showInfo[index] ?? false;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  setState(() {
                    _showInfo[index] = !isShowInfo;
                  });
                },
                onLongPress: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return CupertinoActionSheet(
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            onPressed: () {
                              _navToEditClass(classInfo);
                            },
                            child: Text(
                              'Edit class',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              showMessageTwoOption(
                                context,
                                'Do you want to delete this class?',
                                okLabel: 'Delete',
                                onOk: () {
                                  Navigator.pop(context);
                                  _classManagementBloc.add(InitClassEvent());
                                  setState(() {});
                                },
                              );
                            },
                            child: const Text(
                              'Delete class',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Class code: ${classInfo.code} - Year: ${classInfo.schoolYear}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Class name: ${classInfo.className}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Icon(
                        isShowInfo ? Icons.expand_more : Icons.navigate_next,
                        size: 24,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isShowInfo) _createItemSubject(classInfo.subjectData)
          ],
        ),
      ),
    );
  }

  void _navToEditClass(ClassModel classInfo) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider<ClassInfoBloc>(
            create: (context) => ClassInfoBloc(context)..add(ClassInfoInit()),
            child: ClassInfoPage(
              isEdit: true,
              classInfoEdit: classInfo,
            ),
          ),
        ),
      );

  Widget _createItemSubject(List<SubjectModel>? listSubject) {
    if (isNullOrEmpty(listSubject)) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'no subject data',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        height: 36 + 30 * listSubject!.length.toDouble(),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: listSubject.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _createItem('Serial', 'Subject code', 'Subject name');
            }
            return _createItem(
              (index - 1).toString(),
              listSubject[index - 1].code ?? '',
              listSubject[index - 1].subjectName ?? '',
            );
          },
        ),
      ),
    );
  }

  Widget _createItem(String serial, String code, String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                serial,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                code,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ],
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

  PreferredSizeWidget _appBar(List<SubjectModel>? listSubject) => AppBar(
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
          'Class Management',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return CupertinoActionSheet(
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        onPressed: () async {
                          Navigator.pop(context);
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) =>
                                _selectSubjectInClass(listSubject),
                          ).whenComplete(() {
                            setState(() {});
                          });
                        },
                        child: Text(
                          'Add new class',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.more_vert_outlined,
              size: 24,
              color: Colors.white,
            ),
          ),
        ],
      );
}
