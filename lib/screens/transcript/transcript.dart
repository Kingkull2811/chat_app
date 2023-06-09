import 'package:chat_app/screens/transcript/class_management/class_management.dart';
import 'package:chat_app/screens/transcript/students_management/students_management.dart';
import 'package:chat_app/screens/transcript/students_management/students_management_bloc.dart';
import 'package:chat_app/screens/transcript/students_management/students_management_event.dart';
import 'package:chat_app/screens/transcript/subject_management/subject_management.dart';
import 'package:chat_app/screens/transcript/subject_management/subject_management_bloc.dart';
import 'package:chat_app/screens/transcript/subject_management/subject_management_event.dart';
import 'package:chat_app/screens/transcript/transcript_bloc.dart';
import 'package:chat_app/screens/transcript/transcript_event.dart';
import 'package:chat_app/screens/transcript/transcript_management/enter_point_subject/enter_point_page.dart';
import 'package:chat_app/screens/transcript/transcript_management/transcript_management.dart';
import 'package:chat_app/screens/transcript/transcript_management/transcript_management_bloc.dart';
import 'package:chat_app/screens/transcript/transcript_state.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:chat_app/widgets/data_not_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../network/model/learning_result_info.dart';
import '../../network/model/student.dart';
import '../../theme.dart';
import '../../utilities/screen_utilities.dart';
import '../../utilities/utils.dart';
import '../../widgets/animation_loading.dart';
import '../../widgets/input_field_with_ontap.dart';
import 'class_management/class_management_bloc.dart';

class TranscriptPage extends StatefulWidget {
  const TranscriptPage({Key? key}) : super(key: key);

  @override
  State<TranscriptPage> createState() => TranscriptPageState();
}

class TranscriptPageState extends State<TranscriptPage> {
  final bool _isUser = SharedPreferencesStorage().getUserRole();

  late TranscriptBloc _transcriptBloc;

  final _semesterController = TextEditingController();

  @override
  void initState() {
    if (_isUser) {
      _transcriptBloc = BlocProvider.of<TranscriptBloc>(context)
        ..add(GetTranscriptByUserID());
    }
    super.initState();
  }

  @override
  void dispose() {
    _semesterController.dispose();
    super.dispose();
    if (_isUser) _transcriptBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          _isUser ? 'Transcript' : 'Manage',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          if (_isUser)
            IconButton(
              onPressed: () async {},
              icon: const Icon(
                Icons.info_outline,
                size: 24,
                color: Colors.white,
              ),
            ),
        ],
      ),
      body: _isUser ? _userView() : _teacherView(),
    );
  }

  Widget _userView() {
    return BlocConsumer<TranscriptBloc, TranscriptState>(
      listenWhen: (preState, curState) {
        return curState.apiError != ApiError.noError;
      },
      listener: (context, curState) {
        if (curState.apiError == ApiError.internalServerError) {
          showCupertinoMessageDialog(
            context,
            'error',
            content: 'internal_server_error',
          );
        }
        if (curState.apiError == ApiError.noInternetConnection) {
          showMessageNoInternetDialog(context);
        }
      },
      builder: (context, curState) {
        return curState.isLoading
            ? const AnimationLoading()
            : _listTranscript(curState);
      },
    );
  }

  Widget _teacherView() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _itemManage(
              title: 'Class Management',
              onTap: () {
                _navToClassManagement();
              },
            ),
            _itemManage(
              title: 'Subjects Management',
              onTap: () {
                _navToSubjectManagement();
              },
            ),
            _itemManage(
              title: 'Students Management',
              onTap: () {
                _navToStudentManagement();
              },
            ),
            _itemManage(
              title: 'Transcript Management',
              onTap: () {
                _navToTranscriptManagement();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _listTranscript(TranscriptState state) {
    if (isNullOrEmpty(state.listStudent)) {
      return const DataNotFoundPage(
        title: 'There is no data on students who are children of this parent',
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: state.listStudent!.length,
      itemBuilder: (context, index) => _itemTranScript(
        state,
        state.listStudent![index],
      ),
    );
  }

  Widget _itemTranScript(TranscriptState state, Student student) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.1),
              border: Border.all(
                width: 0.5,
                color: AppColors.greyLight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 130,
                    width: 80,
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
                          _itemText('SSID:', student.code ?? '-'),
                          _itemText('Name:', student.name ?? '-'),
                          _itemText(
                              'D.O.B:', formatDate('${student.dateOfBirth}')),
                          _itemText('Class:', student.className ?? '-'),
                          _itemText('School year:',
                              student.classResponse?.schoolYear ?? '-'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.1),
                border: Border.all(
                  width: 0.5,
                  color: AppColors.greyLight,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                        'GPA 1: ${(student.hk1SubjectMediumScore?.toStringAsFixed(3)) ?? '---'}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                        'GPA 2:  ${(student.hk2SubjectMediumScore?.toStringAsFixed(3)) ?? '---'}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                        'GPA year:  ${(student.mediumScore?.toStringAsFixed(3)) ?? '---'}'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(48, 16, 48, 0),
            child: InputField(
              context: context,
              controller: _semesterController,
              textAlign: TextAlign.center,
              readOnly: true,
              showSuffix: true,
              labelText: 'Semester',
              hintText: 'Select Semester',
              onTap: () {
                final listSemester = [
                  SemesterYear(
                    semester: 1,
                    title: 'Semester 1 ${student.classResponse?.schoolYear}',
                  ),
                  SemesterYear(
                    semester: 2,
                    title: 'Semester 2 ${student.classResponse?.schoolYear}',
                  ),
                ];
                _dialogSelectSemester(
                  listSemester: listSemester,
                  studentID: student.id!,
                  year: student.classResponse?.schoolYear ?? '',
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: _transcript(state.learningResult ?? []),
          ),
        ],
      ),
    );
  }

  Widget _transcript(List<LearningResultInfo> listLearningInfo) {
    final columns = [
      'Subject name',
      'Oral Test',
      '15m Test',
      '45m Test',
      'Final Exam',
      'Semester GPA',
    ];

    List<DataColumn> getColumns(List<String> columns) =>
        columns.map((String columns) {
          return DataColumn(
            label: Text(
              columns,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          );
        }).toList();

    List<DataRow> getRows(List<LearningResultInfo> data) =>
        data.map((LearningResultInfo data) {
          final cells = [
            data.subjectName,
            data.oralTestScore,
            data.m15TestScore,
            data.m45TestScore,
            data.semesterTestScore,
            data.semesterSummaryScore,
          ];

          return DataRow(
            cells: modelBuilder(cells, (index, cell) {
              return DataCell(
                Center(child: Text(cell == null ? '-' : cell.toString())),
                showEditIcon: false,
              );
            }),
          );
        }).toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: DataTable(
          horizontalMargin: 10,
          // sortColumnIndex: 0,
          columnSpacing: 16,
          headingTextStyle: TextStyle(
            fontSize: 16,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
          dataRowHeight: 50,
          columns: getColumns(columns),
          rows: getRows(listLearningInfo),
        ),
      ),
    );
  }

  _dialogSelectSemester({
    required List<SemesterYear> listSemester,
    required int studentID,
    required String year,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Select semester',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          height: 40 * listSemester.length.toDouble(),
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listSemester.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                _onTapSelectSemester(
                  semester: listSemester[index],
                  studentID: studentID,
                  year: year,
                );
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: (listSemester[index].title == _semesterController.text)
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
                          listSemester[index].title,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    if (listSemester[index].title == _semesterController.text)
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
    ).whenComplete(() async {
      await Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {});
      });
    });
  }

  _onTapSelectSemester({
    required SemesterYear semester,
    required int studentID,
    required String year,
  }) {
    _transcriptBloc.add(GetLearningResult(
      studentId: studentID,
      term: semester.semester,
      year: year,
    ));
    setState(() {
      _semesterController.text = semester.title;
    });
    Navigator.pop(context);
  }

  Widget _itemText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.primaryColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemManage({String? title, Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.withOpacity(0.2),
        ),
        child: InkWell(
          overlayColor: const MaterialStatePropertyAll(Colors.white),
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 6, 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.navigate_next,
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _navToClassManagement() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider<ClassManagementBloc>(
            create: (context) => ClassManagementBloc(context),
            child: const ClassManagement(),
          ),
        ),
      );

  _navToSubjectManagement() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider<SubjectManagementBloc>(
            create: (context) => SubjectManagementBloc(context)
              ..add(
                InitSubjectEvent(),
              ),
            child: const SubjectManagementPage(),
          ),
        ),
      );

  _navToStudentManagement() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider<StudentsManagementBloc>(
            create: (context) => StudentsManagementBloc(context)
              ..add(
                InitStudentsEvent(),
              ),
            child: const StudentsManagementPage(),
          ),
        ),
      );

  _navToTranscriptManagement() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider<TranscriptManagementBloc>(
            create: (context) => TranscriptManagementBloc(context),
            child: const TranscriptManagementPage(),
          ),
        ),
      );
}
