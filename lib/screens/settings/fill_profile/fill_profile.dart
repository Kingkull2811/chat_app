import 'dart:io';

import 'package:chat_app/network/model/user_info_model.dart';
import 'package:chat_app/screens/settings/fill_profile/fill_profile_bloc.dart';
import 'package:chat_app/screens/settings/fill_profile/fill_profile_event.dart';
import 'package:chat_app/screens/settings/fill_profile/fill_profile_state.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:chat_app/widgets/search_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/firebase_services.dart';
import '../../../theme.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/animation_loading.dart';
import '../../../widgets/input_field.dart';
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
  String studentParent = 'Student\'s Parent';
  bool _isShow = false;

  bool _isOnline = true;

  String? _image;

  @override
  void initState() {
    _fillProfileBloc = BlocProvider.of<FillProfileBloc>(context);
    _fillProfileBloc.add(FillInit());
    _image = widget.userInfo.fileUrl;
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.grey[50],
          centerTitle: true,
          title: const Text(
            'Fill Your Profile',
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
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _imageAvt(context),
                _itemTextInput(
                  controller: _usernameController,
                  enable: false,
                  initText: widget.userInfo.username,
                  prefixIcon: Icons.person_outline,
                ),
                _fullNameInputField(
                  context,
                  controller: _nameController,
                  initText: widget.userInfo.fullName,
                ),
                _itemTextInput(
                  enable: false,
                  controller: _emailController,
                  initText: widget.userInfo.email,
                  prefixIcon: Icons.email_outlined,
                ),
                _itemTextInput(
                  enable: true,
                  controller: _phoneController,
                  prefixIcon: Icons.phone,
                  initText: widget.userInfo.phone,
                  hint: 'Phone number',
                  keyboardType: TextInputType.phone,
                  maxText: 10,
                ),
                if (isUserRoll) _selectStudent(),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 32),
                  child: PrimaryButton(
                    text: 'Save',
                    onTap: () async {
                      showLoading(context);
                      await onTapButton(context, widget.userInfo);
                    },
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
      final Map<String, dynamic> userData = {
        "fileUrl": _isOnline
            ? userInfo?.fileUrl
            : await getUrlImage(file: File(_image!)),
        "fullName": _nameController.text.trim(),
        "isFillProfileKey": true,
        "phone": _phoneController.text.trim(),
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

  Widget _selectStudent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        height: _isShow ? 300 : 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.withOpacity(0.05),
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
                    Expanded(
                      child: Text(
                        studentParent,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Icon(
                        _isShow ? Icons.expand_more : Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isShow) SearchBox(controller: _searchController),
          ],
        ),
      ),
    );
  }

  Widget _fullNameInputField(
    BuildContext context, {
    required TextEditingController controller,
    String? initText,
  }) {
    if (initText != null) {
      controller.text = initText;
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: initText.length,
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SizedBox(
        height: 50,
        child: TextField(
          controller: controller,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.next,
          onSubmitted: (value) {},
          onChanged: (_) {},
          keyboardType: TextInputType.text,
          style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 26, 26, 26),
              height: 1.35),
          decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.contacts_outlined,
                size: 24,
                color: AppColors.greyLight,
              ),
              prefixIconColor: AppColors.greyLight,
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
              hintText: 'Full Name',
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6))),
        ),
      ),
    );
  }

  Widget _itemTextInput({
    required TextEditingController controller,
    Function(String)? onChanged,
    TextInputAction? textInputAction,
    bool enable = true,
    String? initText,
    IconData? prefixIcon,
    String? hint,
    TextInputType? keyboardType,
    int? maxText,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SizedBox(
        height: 50,
        child: Input(
          enable: enable,
          textInputAction: textInputAction ?? TextInputAction.next,
          controller: controller,
          onChanged: onChanged,
          initText: initText,
          prefixIcon: prefixIcon,
          hint: hint,
          keyboardType: keyboardType,
          maxText: maxText,
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
