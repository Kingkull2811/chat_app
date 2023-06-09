import 'package:badges/badges.dart';
import 'package:chat_app/screens/authenticator/fill_profile/select_student/select_student_bloc.dart';
import 'package:chat_app/screens/authenticator/fill_profile/select_student/select_student_event.dart';
import 'package:chat_app/screens/authenticator/fill_profile/select_student/select_student_state.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../network/model/student.dart';
import '../../../../utilities/enum/api_error_result.dart';
import '../../../../utilities/screen_utilities.dart';
import '../../../../utilities/utils.dart';
import '../../../../widgets/app_image.dart';
import '../view_list_student_selected.dart';

class SelectStudent extends StatefulWidget {
  final List<Student> students;

  const SelectStudent({Key? key, required this.students}) : super(key: key);

  @override
  State<SelectStudent> createState() => _SelectStudentState();
}

class _SelectStudentState extends State<SelectStudent> {
  final _searchController = TextEditingController();
  bool _isShowClear = false;
  bool _isShowAddedIcon = true;

  String studentSSID = '';
  List<Student> listStudent = [];

  late SelectStudentBloc _studentBloc;

  @override
  void initState() {
    _studentBloc = BlocProvider.of<SelectStudentBloc>(context);

    listStudent = widget.students;
    _searchController.addListener(() {
      _isShowClear = _searchController.text.isNotEmpty;
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelectStudentBloc, SelectStudentState>(
      listenWhen: (preState, curState) {
        return curState.apiError == ApiError.noError;
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
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            centerTitle: true,
            title: const Text(
              'Select Student',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop(listStudent);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
          body: state.isLoading
              ? const AnimationLoading()
              : _body(context, state),
        );
      },
    );
  }

  Widget _body(BuildContext context, SelectStudentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _searchBox(),
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
          child: InkWell(
            onTap: () {
              _navToViewListStudentSelected();
            },
            child: Badge(
              showBadge: listStudent.isNotEmpty,
              badgeContent: Text(
                listStudent.length.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              badgeStyle: const BadgeStyle(
                badgeColor: Colors.red,
                padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
              ),
              position: BadgePosition.topEnd(top: -5, end: -8),
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Text(
                  'View the list of students added',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            height: 150,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: isNullOrEmpty(studentSSID)
                ? const SizedBox.shrink()
                : state.isNotFind || isNullOrEmpty(state.studentInfo)
                    ? Center(
                        child: Text(
                          'Can\'t find student with student SSID:  $studentSSID',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    : _itemStudent(state.studentInfo!),
          ),
        )
      ],
    );
  }

  Future<void> _navToViewListStudentSelected() async {
    final List<Student>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewListStudentSelected(
          listStudent: listStudent,
        ),
      ),
    );
    if (!mounted) {
      return;
    }
    List<int?>? listIdRemove = result?.map((e) => e.id).toList();

    listStudent.removeWhere(
      (element) => listIdRemove?.contains(element.id) ?? false,
    );
    setState(() {});
  }

  Widget _itemStudent(Student student) {
    return InkWell(
      onTap: () {
        if (_isShowAddedIcon) {
          if (isNullOrEmpty(listStudent)) {
            listStudent.add(student);
          } else {
            for (var students in listStudent) {
              if (student.id != students.id) {
                listStudent.add(student);
                break;
              } else {
                listStudent.removeWhere((e) => student.id == e.id);
              }
            }
          }
        } else {
          listStudent.removeWhere((e) => student.id == e.id);
        }

        setState(() {
          _isShowAddedIcon = !_isShowAddedIcon;
        });
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 100,
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
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Student Id:',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            student.code ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          'Student Name:',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            student.name ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          'Date of birth:',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            formatDate('${student.dateOfBirth}'),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          'Class:',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            student.classResponse?.className ?? '',
                            style: const TextStyle(
                              fontSize: 14,
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
          Positioned(
            top: 6,
            right: 6,
            child: Icon(
              _isShowAddedIcon
                  ? Icons.add_circle_outline
                  : Icons.check_circle_outline,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: TextFormField(
          textInputAction: TextInputAction.done,
          controller: _searchController,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (v) {},
          onFieldSubmitted: (ssid) {
            bool ssidExists = false;

            for (var student in listStudent) {
              if (student.code == ssid.toUpperCase()) {
                ssidExists = true;
                break;
              } else {
                ssidExists = false;
              }
            }

            _studentBloc.add(SelectStudentEvent(ssid.toUpperCase()));

            setState(() {
              studentSSID = ssid;
              _isShowAddedIcon = ssidExists ? false : true;
            });
          },
          maxLines: 1,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                width: 1,
                color: Color.fromARGB(128, 130, 130, 130),
              ),
            ),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            prefixIcon: const Icon(
              Icons.search,
              size: 24,
              color: Colors.grey,
            ),
            suffixIcon: _isShowClear
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                    },
                    icon: const Icon(
                      Icons.cancel,
                      size: 20,
                      color: Colors.grey,
                    ),
                  )
                : null,
            labelText: 'Search with SSID',
            labelStyle: TextStyle(
              fontSize: 14,
              color: Theme.of(context).primaryColor,
            ),
            hintText: 'Search student with student SSID',
            hintStyle: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
