import 'package:chat_app/screens/main/main_app.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:flutter/material.dart';

import '../../utilities/app_constants.dart';
import '../../widgets/custom_check_box.dart';
import '../../widgets/primary_button.dart';
import '../onboarding/onboarding_screen.dart';

class TermPolicyPage extends StatefulWidget {
  const TermPolicyPage({Key? key}) : super(key: key);

  @override
  State<TermPolicyPage> createState() => _TermPolicyPageState();
}

class _TermPolicyPageState extends State<TermPolicyPage> {
  bool _isRead = false;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Term and Policy',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, padding.top, 16, 16 + padding.bottom),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 230, 230, 230),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: const SingleChildScrollView(
                child: Text(
                  AppConstants.longText,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 16,
                right: 16,
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isRead = !_isRead;
                  });
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 21,
                      height: 21,
                      child: CustomCheckBox(
                        value: _isRead,
                        onChanged: (value) {
                          setState(() {
                            _isRead = value;
                          });
                        },
                      ),
                    ),
                    const Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Agree. I have read and understood',
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.2,
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
            const Spacer(),
            _nextButton(),
          ],
        ),
      ),
    );
  }

  Widget _nextButton() {
    return PrimaryButton(
      text: 'Next',
      isDisable: !_isRead,
      onTap: !_isRead
          ? null
          : () async {
              await SharedPreferencesStorage().setAgreeTerm(true);
              bool isFirstTimeOpenApp =
                  SharedPreferencesStorage().getFirstTimeOpen();

              if (isFirstTimeOpenApp) {
                await SharedPreferencesStorage().setFirstTimeOpen(false);
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OnBoardingPage()),
                  );
                }
              } else {
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainApp(currentTab: 0),
                    ),
                  );
                }
                // if (DatabaseService().chatKey != null) {
                //   if (mounted) {
                //     backToChat(context);
                //   }
                // } else {
                //   if (mounted) {
                //     // log('isFill: ${SharedPreferencesStorage().getFillProfileStatus()}');
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => BlocProvider<TabBloc>(
                //           create: (BuildContext context) => TabBloc(),
                //           child: MainApp(navFromStart: true),
                //         ),
                //       ),
                //     );
                //   }
                // }
              }
            },
    );
  }
}
