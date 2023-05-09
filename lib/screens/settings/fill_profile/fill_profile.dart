import 'dart:io';

import 'package:badges/badges.dart';
import 'package:chat_app/network/model/student_firebase.dart';
import 'package:chat_app/network/model/user_info_model.dart';
import 'package:chat_app/screens/settings/fill_profile/fill_profile_bloc.dart';
import 'package:chat_app/screens/settings/fill_profile/fill_profile_event.dart';
import 'package:chat_app/screens/settings/fill_profile/fill_profile_state.dart';
import 'package:chat_app/screens/settings/fill_profile/view_list_student_selected.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../network/model/student.dart';
import '../../../services/firebase_services.dart';
import '../../../theme.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/animation_loading.dart';
import '../../../widgets/primary_button.dart';
import '../../main/main_app.dart';

class FillProfilePage extends StatefulWidget {
  final UserInfoModel userInfo;

  const FillProfilePage({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<FillProfilePage> createState() => _FillProfilePageState();
}

class _FillProfilePageState extends State<FillProfilePage> {
  late FillProfileBloc _fillProfileBloc;

  final bool isUserRoll = SharedPreferencesStorage().getUserRole();

  final _searchController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  String? username;
  String? email;
  String? phone;
  String? fullName;
  bool _isShow = false;
  bool _isShowClear = false;

  bool _isOnline = true;

  String? _image;
  String studentSSID = '';

  bool _isSelectId = false;
  List<Student> listStudent = [];
  Map<int, bool> studentIdSelected = {};
  Map<String, dynamic> studentFirebase = StudentFirebase().toFirestore();

  @override
  void initState() {
    _fillProfileBloc = BlocProvider.of<FillProfileBloc>(context);
    _fillProfileBloc.add(FillInit());
    _image = widget.userInfo.fileUrl;
    _searchController.addListener(() {
      _isShowClear = _searchController.text.isNotEmpty;
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _fillProfileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BlocConsumer<FillProfileBloc, FillProfileState>(
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
          if (curState.fillSuccess) {
            showCupertinoMessageDialog(
              context,
              'Your profile has been successfully updated',
              onCloseDialog: () {
                _navigateToMainPage();
              },
            );
          }
          if (curState.isNotFind) {
            showCupertinoMessageDialog(
              context,
              'Error!',
              content: 'Can\'t find student with student SSID:  $studentSSID',
            );
          }
          if (curState.userData == null) {
            logoutIfNeed(context);
          }
        },
        builder: (context, state) {
          Widget body = const SizedBox.shrink();
          if (state.isLoading) {
            body = const Scaffold(body: AnimationLoading());
          } else {
            body = _body(context, state);
          }
          return body;
        },
      ),
    );
  }

  Widget _body(BuildContext context, FillProfileState state) {
    // studentIdSelected = {state.studentInfo?.id ?? 0: false};

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Fill Your Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _imageAvt(context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: inputTextWithLabel(
                    context,
                    controller: _usernameController,
                    readOnly: true,
                    initText: widget.userInfo.username,
                    labelText: 'Username',
                    prefixIcon: Icons.person_outline,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: inputTextWithLabel(
                    context,
                    controller: _nameController,
                    readOnly: false,
                    initText: widget.userInfo.fullName,
                    labelText: 'Full name',
                    hintText: 'Enter full name',
                    prefixIcon: Icons.contacts_outlined,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: inputTextWithLabel(
                    context,
                    controller: _emailController,
                    readOnly: true,
                    initText: widget.userInfo.email,
                    labelText: 'Email',
                    prefixIcon: Icons.email_outlined,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: inputTextWithLabel(
                    context,
                    controller: _phoneController,
                    readOnly: false,
                    initText: widget.userInfo.phone,
                    labelText: 'Phone number',
                    hintText: 'Enter phone number',
                    prefixIcon: Icons.phone,
                    maxText: 10,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                if (isUserRoll) _selectStudent(state),
                Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 32),
                  child: PrimaryButton(
                    text: 'Save',
                    onTap: () async =>
                        await onTapButton(context, widget.userInfo),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onTapButton(
    BuildContext context,
    UserInfoModel? userInfo,
  ) async {
    if (_nameController.text.isEmpty && mounted) {
      showCupertinoMessageDialog(context, 'Full name cannot be empty');
    } else if (_phoneController.text.isEmpty) {
      showCupertinoMessageDialog(context, 'Phone number cannot be empty');
    } else if (isNullOrEmpty(_image)) {
      showCupertinoMessageDialog(context, 'Image avartar cannot be empty');
    } else {
      List<int?> listStudentIdSelected = listStudent.map((e) => e.id).toList();

      final Map<String, dynamic> userData = {
        "fileUrl": _isOnline
            ? userInfo?.fileUrl
            : await getUrlImage(file: File(_image!)),
        "fullName": _nameController.text.trim(),
        "isFillProfileKey": true,
        "phone": _phoneController.text.trim(),
        "studentIds": listStudentIdSelected
      };
      _fillProfileBloc.add(FillProfile(
        userId: SharedPreferencesStorage().getUserId(),
        userData: userData,
      ));
    }
  }

  void _navigateToMainPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainApp(currentTab: 0)),
    );
  }

  Widget _selectStudent(FillProfileState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        height: _isShow ? 344 : 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.withOpacity(_isShow ? 0.2 : 0.05),
        ),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                setState(() {
                  _isShow = !_isShow;
                });
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.withOpacity(0.05),
                  border: Border.all(
                    width: 1,
                    color: const Color.fromARGB(128, 130, 130, 130),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, right: 16),
                      child: Icon(
                        Icons.group,
                        size: 24,
                        color: AppColors.greyLight,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Student\'s Parent',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Icon(
                        _isShow ? Icons.expand_more : Icons.navigate_next,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isShow) _searchBox(),
            if (_isShow)
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                child: InkWell(
                  onTap: () {
                    _navToViewListStudentSelected();
                  },
                  child: Badge(
                    showBadge: true,
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
            if (_isShow)
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
                      ? const SizedBox()
                      : isNullOrEmpty(state.studentInfo)
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
              ),
          ],
        ),
      ),
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
    studentIdSelected.forEach((key, value) {
      if (listIdRemove?.contains(key) ?? false) {
        studentIdSelected[key] = false;
      }
    });

    listStudent.removeWhere(
      (element) => listIdRemove?.contains(element.id) ?? false,
    );
    setState(() {});
  }

  Widget _itemStudent(Student student) {
    _isSelectId = studentIdSelected[student.id] ?? false;
    return InkWell(
      onTap: () {
        if (_isSelectId) {
          listStudent.add(student);
        } else {
          listStudent.remove(student);
        }
        setState(() {
          studentIdSelected[student.id!] = !_isSelectId;
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
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.1),
                  ),
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
              _isSelectId
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

  String formatDate(String value) {
    return DateFormat('dd-MM-yyyy').format(DateTime.tryParse(value)!);
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
          onFieldSubmitted: (v) {
            _fillProfileBloc.add(SearchStudentBySSID(studentSSID: v));
            setState(() {
              studentSSID = v;
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

  Widget _imageAvt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 0),
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: AppImage(
                isOnline: _isOnline,
                // localPathOrUrl: _isOnline ? userData?.fileUrl : _image,
                localPathOrUrl: _image,
                height: 200,
                width: 200,
                boxFit: BoxFit.cover,
                errorWidget: Image.asset(
                  'assets/images/ic_account_circle.png',
                  color: Colors.grey.withOpacity(0.6),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: InkWell(
                onTap: () async => await showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return CupertinoActionSheet(
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          onPressed: () async {
                            Navigator.pop(context);

                            final imagePicked = await pickPhoto(
                              ImageSource.camera,
                            );

                            setState(() {
                              _image = imagePicked;
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

                            final imagePicked =
                                await pickPhoto(ImageSource.gallery);

                            setState(() {
                              _image = imagePicked;
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
                        )
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
                ),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Icon(
                    Icons.add_a_photo_outlined,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///upload image to firebase storage or cloudinary.com for get url
  Future<String> getUrlImage({required File file}) async {
    return await FirebaseService().uploadImageToStorage(
      titleName: 'image_userid_${SharedPreferencesStorage().getUserId()}',
      image: file,
    );
  }
}
