import 'package:chat_app/l10n/l10n.dart';
import 'package:chat_app/network/model/student.dart';
import 'package:chat_app/screens/transcript/transcript_management/enter_point_subject/enter_point_subject_bloc.dart';
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
import '../../../widgets/app_image.dart';
import 'enter_point_subject/enter_point_page.dart';
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
          showCupertinoMessageDialog(context, context.l10n.error, content: context.l10n.internal_server_error);
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
                  color: Colors.white
                ),
              ),
              centerTitle: true,
              title:  Text(
                context.l10n.transcriptManage,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: _searchBox(context),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
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
                            _dialogSelectSchoolYear(
                                AppConstants.listSchoolYear);
                          },
                          labelText: context.l10n.schoolY,
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
                            _dialogSelectClass(curState.listClass);
                          },
                          labelText: context.l10n.classTitle,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: InkWell(
                    onTap: () async {
                      _onTapButtonSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child:  Text(
                        context.l10n.search,
                        textAlign: TextAlign.center,
                        style:const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(child: _body(context, curState)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, TranscriptManagementState state) {
    return RefreshIndicator(
      onRefresh: () async => await _reloadPage(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: state.isLoading
              ? const AnimationLoading()
              : _listStudentView(state.listStudent),
        ),
      ),
    );
  }

  void _onTapButtonSearch() {
    _transcriptBloc.add(SearchEvent(
      searchQuery: _searchController.text.trim(),
      schoolYear: _schoolYearController.text,
      classId: classIdSelected,
    ));
  }

  Widget _listStudentView(List<Student>? listStudent) {
    if (isNullOrEmpty(listStudent)) {
      return  DataNotFoundPage(title: context.l10n.noStu);
    }
    return SizedBox(
      height: 170 * listStudent!.length.toDouble(),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: listStudent.length,
        itemBuilder: (context, index) => _createItemStudent(listStudent[index]),
      ),
    );
  }

  _reloadPage() {
    _transcriptBloc.add(SearchEvent(
      searchQuery: _searchController.text.trim(),
      schoolYear: _schoolYearController.text,
      classId: classIdSelected,
    ));
    setState(() {});
  }

  Future _navToEnterPointPage(Student student) async {
    final bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => EnterPointSubjectBloc(context),
          child: EnterPointPage(
            student: student,
            schoolYear: _schoolYearController.text.trim(),
          ),
        ),
      ),
    );
    if (result) {
      _reloadPage();
    } else {
      return;
    }
  }

  Widget _createItemStudent(Student student) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () async {
          await _navToEnterPointPage(student);
        },
        child: Container(
          height: 150,
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _itemText(
                                title: '${context.l10n.stuSSID}:',
                                value: student.code ?? '',
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: _itemText(
                                title: context.l10n.classTitle,
                                value: student.className ?? '',
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: _itemText(
                                  title: context.l10n.student_name,
                                  value: student.name ?? '',
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: _itemText(
                                  title: context.l10n.dob,
                                  value: formatDate('${student.dateOfBirth}'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 9, 0, 0),
                          child: _itemPoint(
                            title: context.l10n.oneGPA,
                            value: student.hk1SubjectMediumScore
                                    ?.toStringAsFixed(3) ??
                                '___',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: _itemPoint(
                            title: context.l10n.twoGPA,
                            value: student.hk2SubjectMediumScore
                                    ?.toStringAsFixed(3) ??
                                '___',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: _itemPoint(
                            title: context.l10n.yGPA,
                            value: student.mediumScore?.toStringAsFixed(3) ??
                                '___',
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

  Widget _itemText({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _itemPoint({required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
      ],
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
            context.l10n.selectSY,
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
                  _transcriptBloc.add(SearchEvent(
                    searchQuery: _searchController.text,
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
            context.l10n.selClass,
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
              ?  DataNotFoundPage(title: context.l10n.noClass)
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: listClass!.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      setState(() {
                        _classController.text = '${listClass[index].className}';
                        classIdSelected = listClass[index].classId;
                        _transcriptBloc.add(SearchEvent(
                          searchQuery: _searchController.text,
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
            } else {
              _transcriptBloc.add(SearchEvent(
                searchQuery: _searchController.text,
                schoolYear: _schoolYearController.text,
                classId: classIdSelected,
              ));
            }
          },
          decoration: InputDecoration(
            hintText: context.l10n.searchStu,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0)
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
                color: Theme.of(context).primaryColor
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(
                width: 1,
                color: Color.fromARGB(128, 130, 130, 130)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
