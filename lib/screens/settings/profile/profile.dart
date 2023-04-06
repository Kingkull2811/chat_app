import 'package:chat_app/network/model/user_firebase.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../widgets/animation_loading.dart';
import '../../transcript/transcript.dart';
import 'profile_bloc.dart';
import 'profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool _isShow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
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
          showCupertinoMessageDialog(
            context,
            'error',
            content: 'no_internet_connection',
          );
        }
      },
      builder: (context, curState) {
        Widget body = const SizedBox.shrink();
        if (curState.isLoading) {
          body = const Scaffold(body: AnimationLoading());
        } else {
          body = _body(context, curState);
        }
        return body;
      },
    );
  }

  Widget _body(
    BuildContext context,
    ProfileState state,
  ) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.grey[50],
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Image.asset(
        //       'assets/images/ic_edit_profile.png',
        //       color: Theme.of(context).primaryColor,
        //       height: 24,
        //       width: 24,
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 32),
              child: SizedBox(
                height: 200,
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: AppImage(
                    localPathOrUrl: userData.avartarUrl,
                    boxFit: BoxFit.cover,
                    width: 200,
                    height: 200,
                    errorWidget: const Icon(
                      Icons.account_circle,
                      size: 200,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            _itemView(
              title: userData.username,
              leading: Icons.person_outline,
              trailing: false,
            ),
            _itemView(
              title: userData.email,
              leading: Icons.email_outlined,
              trailing: false,
            ),
            _itemView(
              title: userData.phone,
              leading: Icons.phone,
              trailing: false,
            ),
            _itemView(
              title: userData.role,
              leading: Icons.admin_panel_settings_outlined,
              trailing: false,
            ),
            _itemView(
              title: userData.parentOf,
              leading: Icons.group_outlined,
              trailing: true,
              onPressTrailing: () {
                setState(() {
                  _isShow = !_isShow;
                });
              },
              isShow: _isShow,
              widgetHide: _cardStudent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemView({
    String? title,
    IconData? leading,
    bool trailing = false,
    Function()? onPressTrailing,
    bool isShow = false,
    Widget? widgetHide,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[200],
            ),
            child: ListTile(
              dense: true,
              horizontalTitleGap: 10,
              // visualDensity: const VisualDensity(
              //   horizontal: 0,
              //   vertical: -2.5,
              // ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              leading: leading != null
                  ? Icon(
                      leading,
                      size: 24,
                    )
                  : const SizedBox.shrink(),
              title: Text(
                title ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              trailing: trailing
                  ? IconButton(
                      onPressed: onPressTrailing,
                      icon: Icon(
                        isShow ? Icons.expand_more : Icons.navigate_next,
                        size: 18,
                        color: Colors.black,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          isShow ? widgetHide ?? Container() : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _cardStudent() {
    //todo::
    String urlImage =
        'https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260';

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AppImage(
                  localPathOrUrl: urlImage,
                  boxFit: BoxFit.cover,
                  width: 100,
                  height: 150,
                  errorWidget: Container(
                    color: Colors.grey,
                    child: Center(
                      child: Icon(
                        Icons.person_outline,
                        size: 100,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 12),
                    child: Center(
                      child: Text(
                        'Student Card',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  _itemCard('ID', stInfo.userId.toString()),
                  _itemCard('Name', stInfo.studentName.toString()),
                  _itemCard('Class', stInfo.studentClass.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemCard(
    String title,
    String titleValue,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: SizedBox(
              width: 50,
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Text(
              ': $titleValue',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  UserFirebaseData userData = UserFirebaseData(
    userId: '001',
    username: 'Martha Craig',
    email: 'martha.craig@gmail.com',
    phone: '+84123456789',
    avartarUrl:
        'https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
    role: 'role_User',
    token: '',
    parentOf: 'SID_00000 - Student_Name',
  );
}
