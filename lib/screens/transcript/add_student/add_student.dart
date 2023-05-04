import 'package:chat_app/screens/transcript/add_student/add_student_bloc.dart';
import 'package:chat_app/screens/transcript/add_student/add_student_state.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../network/model/class_model.dart';
import '../../../theme.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/animation_loading.dart';
import 'add_student_event.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _nameController = TextEditingController();
  final _calendarController = TextEditingController();
  final _classController = TextEditingController();
  final _semesterYearController = TextEditingController();

  bool _showClass = false;
  bool _showYear = false;

  String? imagePath;
  int? _classId;

  @override
  void initState() {
    BlocProvider.of<AddStudentBloc>(context).add(InitialEvent());
    super.initState();
  }

  @override
  void dispose() {
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

  Widget _body(BuildContext context, AddStudentState state) {
    return GestureDetector(
      onTap: () => clearFocus(context),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.grey[50],
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Icon(
                Icons.arrow_back_ios,
                size: 24,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Add a new student',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: _inputText(
                            context,
                            controller: _nameController,
                            inputAction: TextInputAction.next,
                            icon: Icons.badge_outlined,
                            labelText: 'Student name',
                            hintText: 'Enter student name',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: _inputText(
                            context,
                            // readOnly: true,
                            controller: _calendarController,
                            inputAction: TextInputAction.next,
                            icon: Icons.calendar_month,
                            labelText: 'Date of birth',
                            hintText: 'yyyy/MM/dd',
                            onTapSuffix: () async {
                              DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime(1990, 01, 01),
                                maxTime: DateTime(2030, 12, 31),
                                onConfirm: (date) {
                                  setState(() {
                                    _calendarController.text =
                                        DateFormat('yyyy-MM-dd', 'en')
                                            .format(date);
                                  });
                                },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en,
                              );
                            },
                            showSuffix: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: _inputText(
                            context,
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
                          ),
                        ),
                        if (_showClass) _listItemClass(state.listClass),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: _inputText(
                            context,
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
                          ),
                        ),
                        if (_showYear) _listSemesterYear(listSemesterYear),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
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
                            child: PrimaryButton(
                              text: 'Add',
                              onTap: () async {
                                await _buttonAdd();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _buttonAdd() async {
    if (_classId == null) {
      showCupertinoMessageDialog(context, 'Please select class');
    }
    if (imagePath == null) {
      showCupertinoMessageDialog(context, 'Student image can\'t be empty');
    }
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: AppImage(
                  isOnline: false,
                  localPathOrUrl: imagePath,
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
                        showCupertinoModalPopup(
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
                                    setState(() {});
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
                                    setState(() {});
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
                            )
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
                    top: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          imagePath = '';
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

  Widget _inputText(
    BuildContext context, {
    TextEditingController? controller,
    TextInputAction? inputAction,
    String? initText,
    String? labelText,
    String? hintText,
    IconData? icon,
    bool showSuffix = false,
    bool isShow = false,
    Function()? onTap,
    Function()? onTapSuffix,
    bool readOnly = false,
    String? iconPath,
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
            prefixIcon: isNotNullOrEmpty(icon)
                ? Icon(icon, size: 24, color: AppColors.greyLight)
                : isNotNullOrEmpty(iconPath)
                    ? Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Image.asset(
                          '$iconPath',
                          height: 24,
                          width: 24,
                          fit: BoxFit.cover,
                          color: AppColors.greyLight,
                        ),
                      )
                    : null,
            prefixIconColor: AppColors.greyLight,
            suffixIcon: showSuffix
                ? InkWell(
                    onTap: onTapSuffix,
                    child: Icon(
                      isShow ? Icons.expand_more : Icons.navigate_next,
                      size: 24,
                      color: AppColors.greyLight,
                    ),
                  )
                : null,
            suffixIconColor: AppColors.greyLight,
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

  List<String> listSemesterYear = [
    'semester 1 2021-2022',
    'semester 2 2021-2022',
    'semester 1 2022-2023',
    'semester 2 2022-2023',
    'semester 1 2023-2024',
    'semester 2 2023-2024',
  ];
}
