import 'package:chat_app/network/model/student.dart';
import 'package:chat_app/screens/transcript/students_management/add_student/add_student.dart';
import 'package:chat_app/screens/transcript/students_management/add_student/add_student_bloc.dart';
import 'package:chat_app/screens/transcript/students_management/students_management_state.dart';
import 'package:chat_app/widgets/data_not_found.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/animation_loading.dart';
import '../../../widgets/app_image.dart';
import 'add_student/add_student_event.dart';
import 'students_management_bloc.dart';
import 'students_management_event.dart';

class StudentsManagementPage extends StatefulWidget {
  const StudentsManagementPage({Key? key}) : super(key: key);

  @override
  State<StudentsManagementPage> createState() => _StudentsManagementPageState();
}

class _StudentsManagementPageState extends State<StudentsManagementPage> {
  late StudentsManagementBloc _subjectBloc;

  final _subjectCodeController = TextEditingController();
  final _subjectNameController = TextEditingController();

  @override
  void initState() {
    _subjectBloc = BlocProvider.of<StudentsManagementBloc>(context)
      ..add(InitStudentsEvent());
    super.initState();
  }

  @override
  void dispose() {
    _subjectBloc.close();
    _subjectCodeController.dispose();
    _subjectNameController.dispose();
    super.dispose();
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
          body = _body(context, curState.listStudent);
        }
        return body;
      },
    );
  }

  Widget _body(BuildContext context, List<Student>? listStudent) {
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
                          _navToAddStudent(isEdit: false);
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
      body: isNullOrEmpty(listStudent)
          ? const DataNotFoundPage(title: 'Students data not found')
          : RefreshIndicator(
              onRefresh: () async {
                _subjectBloc.add(InitStudentsEvent());
                // setState(() {});
              },
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: listStudent!.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                      child: Text(
                        'List student:',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  }
                  return _createItemStudent(context, listStudent[index - 1]);
                },
              ),
            ),
    );
  }

  Widget _createItemStudent(BuildContext context, Student student) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          _navToAddStudent(isEdit: true, student: student);
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
                            student.classResponse?.className ?? '',
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
                // Icon(
                //   Icons.navigate_next,
                //   size: 24,
                //   color: Theme.of(context).primaryColor,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _navToAddStudent({bool isEdit = false, Student? student}) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AddStudentBloc(context)..add(InitialEvent()),
            child: AddStudent(isEdit: isEdit, student: student),
          ),
        ),
      );

  String formatDate(String value) {
    return DateFormat('dd-MM-yyyy').format(DateTime.tryParse(value)!);
  }
}
