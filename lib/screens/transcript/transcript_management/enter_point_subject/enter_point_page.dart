import 'package:chat_app/network/model/student.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:chat_app/widgets/data_not_found.dart';
import 'package:chat_app/widgets/input_field_with_ontap.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../network/model/learning_result_info.dart';
import '../../../../utilities/enum/api_error_result.dart';
import '../../../../utilities/screen_utilities.dart';
import '../../../../utilities/utils.dart';
import '../../../../widgets/app_image.dart';
import 'enter_point_subject_bloc.dart';
import 'enter_point_subject_event.dart';
import 'enter_point_subject_state.dart';

class EnterPointPage extends StatefulWidget {
  final Student student;
  final String schoolYear;

  const EnterPointPage({
    Key? key,
    required this.student,
    required this.schoolYear,
  }) : super(key: key);

  @override
  State<EnterPointPage> createState() => _EnterPointPageState();
}

class _EnterPointPageState extends State<EnterPointPage> {
  final _semesterController = TextEditingController();

  List<SemesterYear> listSemester = [];
  List<LearningResultInfo> listResult = [];

  int? _semesterSelected;

  late EnterPointSubjectBloc _enterPointSubjectBloc;

  bool _isEditRow = false;

  @override
  void initState() {
    _enterPointSubjectBloc = BlocProvider.of<EnterPointSubjectBloc>(context)
      ..add(InitEvent());
    listSemester = [
      SemesterYear(semester: 1, title: 'Semester 1 ${widget.schoolYear}'),
      SemesterYear(semester: 2, title: 'Semester 2 ${widget.schoolYear}'),
    ];

    super.initState();
  }

  @override
  void dispose() {
    _semesterController.dispose();
    _enterPointSubjectBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EnterPointSubjectBloc, EnterPointSubjectState>(
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
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
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
                'Enter point',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              actions: [
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    setState(() {
                      listResult = curState.listLearningInfo ?? [];
                      _isEditRow = !_isEditRow;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.edit_note_outlined,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            body: _body(context, curState),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, EnterPointSubjectState state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Text(
                'Enter point subject for student:',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            _studentItem(widget.student),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Text(
                'Select semester:',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 0, 60, 16),
              child: SizedBox(
                height: 40,
                child: InputField(
                  context: context,
                  controller: _semesterController,
                  textAlign: TextAlign.center,
                  readOnly: true,
                  showSuffix: true,
                  labelText: 'Semester',
                  hintText: 'Select Semester',
                  onTap: () {
                    _dialogSelectSemester(listSemester);
                  },
                ),
              ),
            ),
            state.isLoading
                ? const AnimationLoading()
                : _listEnterPoint(state.listLearningInfo),
            if (isNotNullOrEmpty(state.listLearningInfo))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Container(
                  alignment: Alignment.center,
                  child: PrimaryButton(
                    text: 'Save',
                    onTap: () async {
                      if (listResult.isNotEmpty) {
                        _enterPointSubjectBloc.add(UpdatePointEvent(
                          listResult: listResult,
                          schoolYear: widget.schoolYear,
                          studentID: widget.student.id!,
                        ));
                        setState(() {
                          if (_isEditRow) {
                            _isEditRow = !_isEditRow;
                          }
                        });
                      } else {
                        showCupertinoMessageDialog(
                            this.context, 'No change in the transcript yet.');
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _listEnterPoint(List<LearningResultInfo>? listLearningInfo) {
    if (_semesterController.text.isEmpty) {
      return Center(
        child: Text(
          'Please select semester to show list subject point.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).primaryColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    if (isNullOrEmpty(listLearningInfo)) {
      return Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: DataNotFoundPage(
          title: "Student achievement data ${widget.student.name} not found.",
        ),
      );
    }
    return _cardLearningInfo(listLearningInfo!);
  }

  Widget _cardLearningInfo(List<LearningResultInfo> listLearningInfo) {
    if (listResult.isEmpty) {
      listResult = listLearningInfo;
    }

    final columns = [
      'Subject',
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
                Center(
                  child: Text(cell == null ? '-' : cell.toString()),
                ),
                showEditIcon: index == 0 || index == 5 ? false : _isEditRow,
                onTap: () async {
                  switch (index) {
                    case 1:
                      return _isEditRow ? await editOralPoint(data) : null;
                    case 2:
                      return _isEditRow ? await editM15Point(data) : null;
                    case 3:
                      return _isEditRow ? await editM45Point(data) : null;
                    case 4:
                      return _isEditRow ? await editFinalExam(data) : null;
                    case 5:
                      return;
                  }
                },
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
          rows: getRows(listResult),
        ),
      ),
    );
  }

  Future editOralPoint(LearningResultInfo dataEdit) async {
    String result = await showTextDialog(
          context,
          title: 'Change Oral Test Point',
          value: (dataEdit.oralTestScore ?? '').toString(),
        ) ??
        '';

    double? oral = double.tryParse(result);

    listResult = listResult.map((result) {
      return (result == dataEdit)
          ? result.copyWith(
              oralTestScore: oral ?? dataEdit.oralTestScore,
              semesterSummaryScore: matchGPA(
                oral ?? dataEdit.oralTestScore,
                result.m15TestScore,
                result.m45TestScore,
                result.semesterTestScore,
              ),
            )
          : result;
    }).toList();

    setState(() {});
  }

  Future editM15Point(LearningResultInfo dataEdit) async {
    String m15Input = await showTextDialog<String>(
          context,
          title: 'Change 15 Minutes Test Point',
          value: (dataEdit.m15TestScore ?? '').toString(),
        ) ??
        '';
    double? m15 = double.tryParse(m15Input);

    listResult = listResult.map((result) {
      return (result == dataEdit)
          ? result.copyWith(
              m15TestScore: m15 ?? dataEdit.m15TestScore,
              semesterSummaryScore: matchGPA(
                result.oralTestScore,
                m15 ?? dataEdit.m15TestScore,
                result.m45TestScore,
                result.semesterTestScore,
              ),
            )
          : result;
    }).toList();

    setState(() {});
  }

  Future editM45Point(LearningResultInfo dataEdit) async {
    String result = await showTextDialog(
          context,
          title: 'Change 45 Minutes Test Point',
          value: (dataEdit.m45TestScore ?? '').toString(),
        ) ??
        '';
    double? m45 = double.tryParse(result);

    listResult = listResult.map((result) {
      return (result == dataEdit)
          ? result.copyWith(
              m45TestScore: m45 ?? dataEdit.m45TestScore,
              semesterSummaryScore: matchGPA(
                result.oralTestScore,
                result.m15TestScore,
                m45 ?? dataEdit.m45TestScore,
                result.semesterTestScore,
              ),
            )
          : result;
    }).toList();

    setState(() {});
  }

  Future editFinalExam(LearningResultInfo dataEdit) async {
    String result = await showTextDialog(
          context,
          title: 'Change Final Exam Test Point',
          value: (dataEdit.semesterTestScore ?? '').toString(),
        ) ??
        '';
    double? finalE = double.tryParse(result);

    listResult = listResult.map((result) {
      return (result == dataEdit)
          ? result.copyWith(
              semesterTestScore: finalE ?? dataEdit.semesterTestScore,
              semesterSummaryScore: matchGPA(
                result.oralTestScore,
                result.m15TestScore,
                result.m45TestScore,
                finalE ?? dataEdit.semesterTestScore,
              ),
            )
          : result;
    }).toList();

    setState(() {});
  }

  _onTapSelectSemester(SemesterYear semester) {
    setState(() {
      _semesterController.text = semester.title;
      _semesterSelected == semester.semester;
      listResult.clear();
    });
    _enterPointSubjectBloc.add(GetListSubjectEvent(
      studentId: widget.student.id!,
      semester: semester.semester,
      schoolYear: widget.schoolYear,
    ));

    Navigator.pop(context);
  }

  _dialogSelectSemester(List<SemesterYear> listSemester) {
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
                if (listResult.isNotEmpty) {
                  showMessageTwoOption(
                    context,
                    'Save changes?',
                    content:
                        'The transcript has been changed, do you want to save this changes?',
                    barrierDismiss: true,
                    okLabel: "Save",
                    cancelLabel: 'Not save',
                    onCancel: () {
                      //push data to server
                      _onTapSelectSemester(listSemester[index]);
                    },
                    onOk: () {
                      _onTapSelectSemester(listSemester[index]);
                    },
                  );
                } else {
                  _onTapSelectSemester(listSemester[index]);
                }
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
    );
  }

  Widget _studentItem(Student student) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        height: 120,
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
                height: 100,
                width: 70,
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
                      _itemText(
                        title: 'Student SSID:',
                        value: student.code ?? '',
                      ),
                      _itemText(
                        title: 'Class:',
                        value: student.className ?? '',
                      ),
                      _itemText(
                        title: 'Student Name:',
                        value: student.name ?? '',
                      ),
                      _itemText(
                        title: 'Date of birth:',
                        value: formatDate('${student.dateOfBirth}'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemText({required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class SemesterYear {
  final int semester;
  final String title;

  SemesterYear({required this.semester, required this.title});

  @override
  String toString() {
    return 'SemesterYear{semester: $semester, title: $title}';
  }
}
