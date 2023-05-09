import 'package:chat_app/network/model/class_model.dart';
import 'package:chat_app/screens/transcript/class_management/class_management_state.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:chat_app/widgets/data_not_found.dart';
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

  late ClassManagementBloc _classManagementBloc;

  @override
  void initState() {
    _classManagementBloc = BlocProvider.of<ClassManagementBloc>(context)
      ..add(InitClassEvent());
    super.initState();
  }

  @override
  void dispose() {
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
      return const DataNotFoundPage(title: 'Class data not found');
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
                                onOk: () async {
                                  Navigator.pop(context);
                                  if (classInfo.classId == null) {
                                    showCupertinoMessageDialog(
                                      context,
                                      'Error!',
                                      content: 'Clas not found',
                                    );
                                  }

                                  _classManagementBloc.add(DeleteClassEvent(
                                    classId: classInfo.classId ?? 0,
                                  ));
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
                          // Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider<ClassInfoBloc>(
                                create: (context) => ClassInfoBloc(context),
                                child: const ClassInfoPage(isEdit: false),
                              ),
                            ),
                          );
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
