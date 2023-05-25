import 'package:chat_app/network/model/class_model.dart';
import 'package:chat_app/screens/transcript/class_management/class_info/class_info_bloc.dart';
import 'package:chat_app/screens/transcript/class_management/class_info/class_info_event.dart';
import 'package:chat_app/screens/transcript/class_management/class_info/class_info_state.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:chat_app/widgets/data_not_found.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../network/model/subject_model.dart';
import '../../../../theme.dart';
import '../../../../utilities/app_constants.dart';
import '../../../../utilities/enum/api_error_result.dart';
import '../../../../utilities/screen_utilities.dart';
import '../../../../utilities/utils.dart';
import '../../../../widgets/input_field_with_ontap.dart';

class ClassInfoPage extends StatefulWidget {
  final bool isEdit;
  final ClassModel? classInfoEdit;

  const ClassInfoPage({
    Key? key,
    this.isEdit = false,
    this.classInfoEdit,
  }) : super(key: key);

  @override
  State<ClassInfoPage> createState() => _ClassInfoPageState();
}

class _ClassInfoPageState extends State<ClassInfoPage> {
  List<int> listSubjectSelected = [];

  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();

  bool _showListYear = false;

  late ClassInfoBloc _cLassInfoBloc;

  final _formKey = GlobalKey<FormState>();

  void initEdit() {
    setState(() {
      _codeController.text = widget.classInfoEdit?.code ?? '';
      _nameController.text = widget.classInfoEdit?.className ?? '';
      _yearController.text = widget.classInfoEdit?.schoolYear ?? '';
      List<SubjectModel> listSubject = widget.classInfoEdit?.subjectData ?? [];
      for (var element in listSubject) {
        listSubjectSelected.add(element.subjectId!);
      }
    });
  }

  @override
  void initState() {
    _cLassInfoBloc = BlocProvider.of<ClassInfoBloc>(context)
      ..add(ClassInfoInit());
    initEdit();
    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _yearController.dispose();
    _cLassInfoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassInfoBloc, ClassInfoState>(
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
        if (curState.isAddSuccess) {
          showCupertinoMessageDialog(context, 'Add new class successfully',
              onClose: () {
            _codeController.clear();
            _nameController.clear();
            _yearController.clear();
            listSubjectSelected = [];
          });
        }
        if (curState.isUpdateSuccess) {
          showCupertinoMessageDialog(
            context,
            'Update class successfully',
            onClose: () {
              Navigator.pop(context);
            },
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
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
              title: Text(
                widget.isEdit ? 'Edit class' : 'Add new class',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            body: state.isLoading
                ? const AnimationLoading()
                : _body(context, state.listSubject),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, List<SubjectModel>? listSubject) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.isEdit)
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
                padding: EdgeInsets.only(top: widget.isEdit ? 16 : 0),
                child: InputField(
                  context: context,
                  controller: _nameController,
                  inputAction: TextInputAction.done,
                  labelText: 'Class Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter class name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: Column(
                    children: [
                      InputField(
                        context: context,
                        labelText: 'Select year',
                        controller: _yearController,
                        inputAction: TextInputAction.done,
                        readOnly: true,
                        showSuffix: true,
                        isShow: _showListYear,
                        onTap: () {
                          setState(() {
                            _showListYear = !_showListYear;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select school year';
                          }
                          return null;
                        },
                      ),
                      if (_showListYear)
                        _listSemesterYear(AppConstants.listSchoolYear),
                    ],
                  ),
                ),
              ),
              _listSubject(listSubject),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                child: widget.isEdit ? _buttonUpdate() : _buttonSave(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonUpdate() {
    return PrimaryButton(
      text: 'Update',
      onTap: () async {
        if (_codeController.text.isEmpty) {
          showCupertinoMessageDialog(
            context,
            'Please enter class code',
          );
        } else if (listSubjectSelected.isEmpty) {
          showCupertinoMessageDialog(
            context,
            'Please select the subject for class',
          );
        } else {
          if (_formKey.currentState!.validate()) {
            if (widget.classInfoEdit?.classId == null) {
              showCupertinoMessageDialog(context, 'Class not found');
            }
            final Map<String, dynamic> data = {
              "code": _codeController.text.trim(),
              "name": _nameController.text.trim(),
              "subjectIds": listSubjectSelected,
              "year": _yearController.text.trim()
            };
            _cLassInfoBloc.add(EditClassEvent(
              classId: (widget.classInfoEdit?.classId)!,
              data: data,
            ));
            // setState(() {});
          }
        }
      },
    );
  }

  Widget _buttonSave() {
    return PrimaryButton(
      text: 'Save',
      onTap: () async {
        if (listSubjectSelected.isEmpty) {
          showCupertinoMessageDialog(
            context,
            'Please select the subject for class',
          );
        } else {
          if (_formKey.currentState!.validate()) {
            final Map<String, dynamic> data = {
              // "code": _codeController.text.trim(),
              "name": _nameController.text.trim(),
              "subjectIds": listSubjectSelected,
              "year": _yearController.text.trim()
            };
            _cLassInfoBloc.add(AddClassEvent(data: data));
            // setState(() {});
          }
        }
      },
    );
  }

  Widget _listSubject(List<SubjectModel>? listSubject) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Select the subject for class',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: isNullOrEmpty(listSubject)
                  ? Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Text(
                        'Subject data not found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : Container(
                      height: 54 * listSubject!.length.toDouble() - 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listSubject.length,
                        itemBuilder: (context, index) {
                          return _createItemSubject(
                            context,
                            listSubject[index],
                          );
                        },
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createItemSubject(
    BuildContext context,
    SubjectModel subject,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 0.5,
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: Theme.of(context).primaryColor,
          ),
          child: CheckboxListTile(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            title: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                '${subject.code} - ${subject.subjectName}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            value: listSubjectSelected.contains(subject.subjectId),
            onChanged: (v) {
              if (v == true) {
                listSubjectSelected.add(subject.subjectId!);
              } else {
                listSubjectSelected.remove(subject.subjectId!);
              }
              setState(() {});
            },
            activeColor: Theme.of(context).primaryColor,
            checkColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _listSemesterYear(List<String> listSchoolYear) {
    return SizedBox(
      height: 40 + 40 * listSchoolYear.length.toDouble(),
      child: isNotNullOrEmpty(listSchoolYear)
          ? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listSchoolYear.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, top: 10),
                    child: SizedBox(
                      height: 30,
                      child: Text(
                        'Select School Year:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  );
                }
                return InkWell(
                  onTap: () {
                    setState(() {
                      _yearController.text = listSchoolYear[index - 1];
                    });
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: (_yearController.text == listSchoolYear[index - 1])
                          ? Colors.grey.withOpacity(0.25)
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              listSchoolYear[index - 1],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (_yearController.text == listSchoolYear[index - 1])
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
          : const DataNotFoundPage(title: 'List semester not found'),
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
    bool showSuffixIcon = false,
    bool showListBelow = false,
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
            suffixIcon: showSuffixIcon
                ? Icon(
                    showListBelow ? Icons.expand_more : Icons.navigate_next,
                    size: 24,
                    color: AppColors.greyLight,
                  )
                : null,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6))),
      ),
    );
  }
}
