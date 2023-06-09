import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/network/response/base_response.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/screen_utilities.dart';
import 'package:chat_app/widgets/input_password_field.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../../widgets/primary_button.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confPassController = TextEditingController();

  bool _isShow = false;

  bool _isShowOld = false;
  bool _isShowNew = false;
  bool _isShowConf = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _confPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: AppColors.primaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              size: 24,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Security',
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
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _item(
                  icons: Icons.password,
                  title: 'Change password',
                  onTap: () {
                    setState(() {
                      _isShow = !_isShow;
                    });
                  },
                  isShow: _isShow,
                ),
                if (_isShow)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, right: 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _itemPass(
                              controller: _oldPassController,
                              obscureText: !_isShowOld,
                              onTapSuffix: () {
                                setState(() {
                                  _isShowOld = !_isShowOld;
                                });
                              },
                              hintText: 'Enter old password',
                              labelText: 'Old password',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter old password';
                                }
                                if (value.isNotEmpty && value.length < 6) {
                                  return 'Old password  must be at least 6 characters';
                                } else if (value.length > 40) {
                                  return 'Old password must be more than 40 characters';
                                }
                                return null;
                              },
                            ),
                            _itemPass(
                              controller: _newPassController,
                              obscureText: !_isShowNew,
                              onTapSuffix: () {
                                setState(() {
                                  _isShowNew = !_isShowNew;
                                });
                              },
                              hintText: 'Enter new password',
                              labelText: 'New password',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter new password';
                                }
                                if (value.isNotEmpty && value.length < 6) {
                                  return 'New password  must be at least 6 characters';
                                } else if (value.length > 40) {
                                  return 'New password must be more than 40 characters';
                                }
                                return null;
                              },
                            ),
                            _itemPass(
                              controller: _confPassController,
                              obscureText: !_isShowConf,
                              onTapSuffix: () {
                                setState(() {
                                  _isShowConf = !_isShowConf;
                                });
                              },
                              hintText: 'Enter confirm new password',
                              labelText: 'Confirm new password',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter new password';
                                }
                                if (value.isNotEmpty && value.length < 6) {
                                  return 'New password  must be at least 6 characters';
                                } else if (value.length > 40) {
                                  return 'Confirm new password must be less than 40 characters';
                                } else if (value != _newPassController.text) {
                                  return 'New password and confirm new password do not match';
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 16),
                              child: PrimaryButton(
                                text: 'Change password',
                                onTap: () async {
                                  await handleButton(context);
                                },
                              ),
                            ),
                          ],
                        ),
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

  Future<void> handleButton(BuildContext context) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (_formKey.currentState!.validate()) {
      if (connectivityResult == ConnectivityResult.none) {
        showMessageNoInternetDialog(this.context);
      } else {
        final response = await AuthRepository().changePassword(
          oldPass: _oldPassController.text.trim(),
          newPass: _newPassController.text.trim(),
          confPass: _confPassController.text.trim(),
        );
        if (response is BaseResponse) {
          if (response.httpStatus == 200) {
            showCupertinoMessageDialog(
              this.context,
              'Change password successfully',
              onClose: () {
                _oldPassController.clear();
                _newPassController.clear();
                _confPassController.clear();
                Navigator.pop(context);
              },
            );
          } else if (response is ExpiredTokenResponse) {
            logoutIfNeed(this.context);
          } else {
            showCupertinoMessageDialog(
              this.context,
              'Error!',
              content: response.message,
            );
          }
        } else {
          showCupertinoMessageDialog(
            this.context,
            'Error!',
            content: 'Internal_server_error',
          );
        }
      }
    }
  }

  Widget _itemPass({
    required TextEditingController controller,
    TextInputAction? action,
    bool obscureText = false,
    Function()? onTapSuffix,
    String? hintText,
    String? labelText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InputPasswordField(
        controller: controller,
        obscureText: obscureText,
        onChanged: (_) {},
        textInputAction: action ?? TextInputAction.done,
        prefixIcon: Icons.lock_outline,
        onTapSuffixIcon: onTapSuffix,
        hint: hintText,
        labelText: labelText,
        validator: validator,
      ),
    );
  }

  Widget _item({
    required IconData icons,
    required String title,
    Function()? onTap,
    bool isShow = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Icon(
                icons,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                isShow ? Icons.expand_more : Icons.navigate_next,
                size: 24,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
