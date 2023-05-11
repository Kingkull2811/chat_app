import 'package:chat_app/network/model/student.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../network/model/class_model.dart';
import '../../../../utilities/enum/api_error_result.dart';
import '../../../../utilities/utils.dart';
import '../../../../widgets/animation_loading.dart';
import '../../../../widgets/input_field_with_ontap.dart';
import 'add_student_bloc.dart';
import 'add_student_event.dart';
import 'add_student_state.dart';

class AddStudent extends StatefulWidget {
  final bool isEdit;
  final Student? student;

  const AddStudent({Key? key, this.isEdit = false, this.student})
      : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _calendarController = TextEditingController();
  final _classController = TextEditingController();
  final _semesterYearController = TextEditingController();

  bool _showClass = false;
  bool _showYear = false;

  String? imagePath = '';
  int? _classId;
  bool _isOnline = false;

  final _formKey = GlobalKey<FormState>();

  void initEdit() {
    setState(() {
      _codeController.text = widget.student?.code ?? '';
      _nameController.text = widget.student?.name ?? '';
      _calendarController.text = widget.student?.dateOfBirth ?? '';
      _classController.text = widget.student?.className ?? '';
      _semesterYearController.text =
          widget.student?.classResponse?.schoolYear ?? '';
      imagePath = widget.student?.imageUrl;
      _classId = widget.student?.classResponse?.classId;
      _isOnline = widget.isEdit ? true : false;
    });
  }

  @override
  void initState() {
    BlocProvider.of<AddStudentBloc>(context).add(InitialEvent());
    initEdit();
    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _calendarController.dispose();
    _classController.dispose();
    _semesterYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddStudentBloc, AddStudentState>(
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
        return GestureDetector(
          onTap: () => clearFocus(context),
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              elevation: 0.5,
              backgroundColor: Theme.of(context).primaryColor,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              centerTitle: true,
              title: Text(
                widget.isEdit ? 'Edit student' : 'Add a new student',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            body: curState.isLoading
                ? const AnimationLoading()
                : _body(context, curState),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, AddStudentState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: InputField(
                  context: context,
                  controller: _codeController,
                  inputAction: TextInputAction.next,
                  prefixIcon: Icons.badge_outlined,
                  labelText: 'Student SSID',
                  hintText: 'Enter student SSID',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'SSID can\'t be empty';
                    } else if (!RegExp(r'^SSID\d{4}$')
                        .hasMatch(value.toUpperCase())) {
                      return 'Please enter SSID like SSID**** with * is the number';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: InputField(
                  context: context,
                  controller: _nameController,
                  inputAction: TextInputAction.next,
                  prefixIcon: Icons.badge_outlined,
                  labelText: 'Student name',
                  hintText: 'Enter student name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the student\'s name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: InputField(
                  context: context,
                  readOnly: true,
                  controller: _calendarController,
                  inputAction: TextInputAction.next,
                  prefixIcon: Icons.calendar_month,
                  labelText: 'Date of birth',
                  hintText: 'yyyy/MM/dd',
                  showSuffix: true,
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime(1990, 01, 01),
                      maxTime: DateTime(2030, 12, 31),
                      onConfirm: (date) {
                        setState(() {
                          _calendarController.text =
                              DateFormat('yyyy-MM-dd', 'en').format(date);
                        });
                      },
                      currentTime: DateTime.now(),
                      locale: LocaleType.en,
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter date of birth';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: InputField(
                  context: context,
                  readOnly: true,
                  controller: _classController,
                  inputAction: TextInputAction.next,
                  iconPath: 'assets/images/ic_presentation.png',
                  labelText: 'Class',
                  hintText: 'Select Class',
                  showSuffix: true,
                  isShow: _showClass,
                  onTap: () {
                    setState(() {
                      _showClass = !_showClass;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select class';
                    }
                    return null;
                  },
                ),
              ),
              if (_showClass) _listItemClass(state.listClass),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: InputField(
                  context: context,
                  readOnly: true,
                  controller: _semesterYearController,
                  inputAction: TextInputAction.next,
                  // icon: Icons.badge_outlined,
                  iconPath: 'assets/images/ic_semester.png',
                  labelText: 'Semester',
                  hintText: 'Select Semester',
                  showSuffix: true,
                  isShow: _showYear,
                  onTap: () {
                    setState(() {
                      _showYear = !_showYear;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select semester year';
                    }
                    return null;
                  },
                ),
              ),
              if (_showYear) _listSemesterYear(AppConstants.listSemesterYear),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Student Image',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              _image(),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 16),
                child: Container(
                  alignment: Alignment.center,
                  child: widget.isEdit
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: PrimaryButton(
                                isWarning: true,
                                text: 'Delete',
                                onTap: () async {},
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: PrimaryButton(
                                text: 'Update',
                                onTap: () async {
                                  if (imagePath == null) {
                                    showCupertinoMessageDialog(
                                        context, 'Please add student image');
                                  } else {
                                    if (_formKey.currentState!.validate()) {
                                      await _buttonUpdate();
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      : PrimaryButton(
                          text: 'Save',
                          onTap: () async {
                            if (imagePath == null) {
                              showCupertinoMessageDialog(
                                  context, 'Please add student image');
                            } else {
                              if (_formKey.currentState!.validate()) {
                                await _buttonAdd();
                              }
                            }
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buttonAdd() async {
    //todo::
    print('add student');
    // final response = StudentRepository().addStudent(
    //   studentName: _nameController.text.trim(),
    //   classId: _classId!,
    //   dob: _calendarController.text.trim(),
    //   semesterYear: _semesterYearController.text.trim(),
    //   imageUrl: await FirebaseService().uploadImageToStorage(
    //       titleName: 'image_news', image: File(imagePath!)),
    // );
  }

  Future<void> _buttonUpdate() async {
    //todo::
    print('add student');
    // final response = StudentRepository().addStudent(
    //   studentName: _nameController.text.trim(),
    //   classId: _classId!,
    //   dob: _calendarController.text.trim(),
    //   semesterYear: _semesterYearController.text.trim(),
    //   imageUrl: await FirebaseService().uploadImageToStorage(
    //       titleName: 'image_news', image: File(imagePath!)),
    // );
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
                      // _showYear = !_showYear;
                      _semesterYearController.text = listSemesterYear[index];
                    });
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: (_semesterYearController.text ==
                              listSemesterYear[index])
                          ? Colors.grey.withOpacity(0.25)
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
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
                          if (_semesterYearController.text ==
                              listSemesterYear[index])
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

  Widget _listItemClass(List<ClassModel>? listClass) {
    return Container(
      height: 40 * (listClass?.length.toDouble() ?? 0 + 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: isNotNullOrEmpty(listClass)
          ? ListView.builder(
              itemCount: listClass!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _classId = listClass[index].classId;
                      // _showClass = !_showClass;
                      _classController.text = listClass[index].className ?? '';
                    });
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: (_classId == listClass[index].classId)
                          ? Colors.grey.withOpacity(0.25)
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              '${listClass[index].className}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (_classId == listClass[index].classId)
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
                'List class not found',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
    );
  }

  Widget _image() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: AppImage(
                  isOnline: _isOnline,
                  localPathOrUrl: imagePath ?? 'http://',
                  boxFit: BoxFit.cover,
                  errorWidget: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).primaryColor,
                        )),
                    child: InkWell(
                      onTap: () async {
                        await showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return CupertinoActionSheet(
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    imagePath = await pickPhoto(
                                      ImageSource.camera,
                                    );
                                    setState(() {
                                      _isOnline = false;
                                    });
                                  },
                                  child: Text(
                                    'Take a photo from camera',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                CupertinoActionSheetAction(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    imagePath = await pickPhoto(
                                      ImageSource.gallery,
                                    );
                                    setState(() {
                                      _isOnline = false;
                                    });
                                  },
                                  child: Text(
                                    'Choose a photo from gallery',
                                    style: TextStyle(
                                      fontSize: 16,
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
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 36,
                              color: Theme.of(context).primaryColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                'Add a student image',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            isNotNullOrEmpty(imagePath)
                ? Positioned(
                    top: -2,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          imagePath = '';
                          _isOnline = false;
                        });
                      },
                      child: const Icon(
                        Icons.cancel_outlined,
                        size: 24,
                        color: Colors.red,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
