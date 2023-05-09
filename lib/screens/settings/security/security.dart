import 'package:chat_app/network/repository/auth_repository.dart';
import 'package:chat_app/network/response/base_response.dart';
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
          backgroundColor: Colors.grey[50],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              size: 24,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Security',
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
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, right: 16),
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
                          ),
                          _itemPass(
                            controller: _confPassController,
                            obscureText: !_isShowConf,
                            onTapSuffix: () {
                              setState(() {
                                _isShowConf = !_isShowConf;
                              });
                            },
                            hintText: 'Enter confirm password',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 16),
                            child: PrimaryButton(
                              text: 'Change password',
                              onTap: () async {},
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

  Future<void> handleButton(BuildContext context) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if ((_oldPassController.text.isEmpty ||
            _newPassController.text.isEmpty ||
            _confPassController.text.isEmpty) &&
        mounted) {
      showCupertinoMessageDialog(context, "Password must not be empty");
    } else if (_newPassController.text != _confPassController.text) {
      showCupertinoMessageDialog(
        context,
        'The new password and confirm password must be the same',
      );
    } else if (_oldPassController.text == _newPassController.text ||
        _oldPassController.text == _confPassController.text) {
      showCupertinoMessageDialog(
          context, 'The old password and the new password must be different');
    } else if (connectivityResult == ConnectivityResult.none) {
      showMessageNoInternetDialog(context);
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
            onCloseDialog: () {
              _oldPassController.clear();
              _newPassController.clear();
              _confPassController.clear();
              Navigator.pop(context);
            },
          );
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

  Widget _itemPass({
    required TextEditingController controller,
    TextInputAction? action,
    bool obscureText = false,
    Function()? onTapSuffix,
    String? hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 60,
        child: InputPasswordField(
          controller: controller,
          obscureText: obscureText,
          onChanged: (_) {},
          textInputAction: action ?? TextInputAction.done,
          prefixIcon: Icons.lock_outline,
          onTapSuffixIcon: onTapSuffix,
          hint: hintText,
        ),
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
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
