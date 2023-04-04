import 'package:chat_app/network/model/user_firebase.dart';
import 'package:chat_app/screens/profile/profile_bloc.dart';
import 'package:chat_app/screens/profile/profile_state.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/enum/api_error_result.dart';
import '../../utilities/screen_utilities.dart';
import '../../widgets/animation_loading.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
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
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/images/ic_edit_profile.png',
              color: Theme.of(context).primaryColor,
              height: 24,
              width: 24,
            ),
          ),
        ],
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
            _itemView(title: userData.username, leading: Icons.person_outline, trailing: false),
            _itemView(title: userData.email, leading: Icons.email_outlined, trailing: false),
            _itemView(title: userData.phone, leading: Icons.phone, trailing: false),
            _itemView(title: userData.role, leading: Icons.admin_panel_settings_outlined, trailing: false),
            _itemView(title: userData.parentOf, leading: Icons.group_outlined, trailing:  true),
          ],
        ),
      ),
    );
  }

  Widget _itemView({
    String? title,
    IconData? leading,
    bool trailing = false,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
      child: Container(
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
                  onPressed: () {},
                  icon: const Icon(
                    Icons.expand_more,
                    size: 18,
                    color: Colors.black,
                  ),
                )
              : const SizedBox.shrink(),
        ),
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
