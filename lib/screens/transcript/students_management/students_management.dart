import 'package:chat_app/network/model/student.dart';
import 'package:chat_app/network/repository/student_repository.dart';
import 'package:chat_app/screens/transcript/students_management/add_student/add_student.dart';
import 'package:chat_app/screens/transcript/students_management/add_student/add_student_bloc.dart';
import 'package:chat_app/screens/transcript/students_management/students_management_state.dart';
import 'package:chat_app/widgets/data_not_found.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/model/class_model.dart';
import '../../../utilities/app_constants.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/animation_loading.dart';
import '../../../widgets/app_image.dart';
import '../../../widgets/input_field_with_ontap.dart';
import 'add_student/add_student_event.dart';
import 'students_management_bloc.dart';
import 'students_management_event.dart';

class StudentsManagementPage extends StatefulWidget {
  const StudentsManagementPage({Key? key}) : super(key: key);

  @override
  State<StudentsManagementPage> createState() => _StudentsManagementPageState();
}

class _StudentsManagementPageState extends State<StudentsManagementPage> {
  late StudentsManagementBloc _studentBloc;

  final _subjectCodeController = TextEditingController();
  final _subjectNameController = TextEditingController();
  final _schoolYearController = TextEditingController();
  final _classController = TextEditingController();

  int? classIdSelected;

  @override
  void initState() {
    _studentBloc = BlocProvider.of<StudentsManagementBloc>(context)
      ..add(InitStudentsEvent());
    _schoolYearController.text = '2023-2024';
    super.initState();
  }

  @override
  void dispose() {
    _studentBloc.close();
    _schoolYearController.dispose();
    _subjectCodeController.dispose();
    _subjectNameController.dispose();
    _classController.dispose();
    super.dispose();
  }

  Future<void> _reloadPage() async {
    showLoading(context);
    await Future.delayed(const Duration(seconds: 1), () {
      _studentBloc.add(InitStudentsEvent());
      Navigator.pop(context);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentsManagementBloc, StudentManagementState>(
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
          body = _body(context, curState.listStudent, curState.listClass);
        }
        return body;
      },
    );
  }

  Widget _body(
    BuildContext context,
    List<Student>? listStudent,
    List<ClassModel>? listClass,
  ) {
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
          'Students Management',
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
                          await _navToAddStudent(isEdit: false);
                        },
                        child: Text(
                          'Add new student',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () async {
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
      ),
      body: RefreshIndicator(
        onRefresh: () async => await _reloadPage(),
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.45,
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
                    SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: InputField(
                        context: context,
                        controller: _classController,
                        readOnly: true,
                        showSuffix: true,
                        textAlign: TextAlign.center,
                        onTap: () {
                          _dialogSelectClass(listClass);
                        },
                        labelText: 'Class',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: Text(
                  'List student:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              isNullOrEmpty(listStudent)
                  ? const DataNotFoundPage(title: 'Students data not found')
                  : SizedBox(
                      height: 206 * (listStudent!.length).toDouble() + 16,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listStudent.length,
                        itemBuilder: (context, index) {
                          return _createItemStudent(
                            context,
                            listStudent[index],
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createItemStudent(BuildContext context, Student student) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () async {
          final response = await StudentRepository().getStudentByID(
            studentID: student.id!,
          );
          await _navToAddStudent(isEdit: true, student: response as Student);
        },
        child: Container(
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey.withOpacity(0.1),
            border: Border.all(
              width: 0.5,
              color: Colors.grey.withOpacity(0.4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 170,
                  width: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AppImage(
                      isOnline: true,
                      localPathOrUrl: student.imageUrl,
                      boxFit: BoxFit.cover,
                      errorWidget: Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Student SSID:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            student.code ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          'Student Name:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            student.name ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          'Date of birth:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            formatDate('${student.dateOfBirth}'),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          'Class:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            student.className ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _navToAddStudent({bool isEdit = false, Student? student}) async {
    final bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => AddStudentBloc(context)..add(InitialEvent()),
          child: AddStudent(isEdit: isEdit, student: student),
        ),
      ),
    );
    if (result) {
      await _reloadPage();
    } else {
      return;
    }
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
                  _studentBloc.add(SearchEvent(
                    searchQuery: null,
                    schoolYear: _schoolYearController.text,
                    classId: classIdSelected,
                  ));
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
                  physics: const BouncingScrollPhysics(),
                  itemCount: listClass!.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      setState(() {
                        _classController.text = '${listClass[index].className}';
                        classIdSelected = listClass[index].classId;
                        _studentBloc.add(SearchEvent(
                          searchQuery: null,
                          schoolYear: _schoolYearController.text,
                          classId: classIdSelected,
                        ));
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
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                '${listClass[index].code} - ${listClass[index].className}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ),
                          if (classIdSelected == listClass[index].classId)
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
}
