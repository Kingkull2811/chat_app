import 'package:chat_app/network/model/user_info_model.dart';
import 'package:chat_app/screens/settings/profile/profile_event.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/model/student.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/animation_loading.dart';
import 'profile_bloc.dart';
import 'profile_state.dart';

class ProfilePage extends StatefulWidget {
  final int userID;

  const ProfilePage({Key? key, required this.userID}) : super(key: key);

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(GetUserInfo(widget.userID));
    super.initState();
  }

  @override
  void dispose() {
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
          showMessageNoInternetDialog(context);
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
      body: SafeArea(
        child: Stack(
          children: [
            _userInfoView(state.userInfo),
            Positioned(
              top: 16,
              left: 10,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 24,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userInfoView(UserInfoModel? userInfo) {
    if (isNullOrEmpty(userInfo)) {
      return const Center(
        child: Text(
          'This user data could not be found',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.primaryColor,
          ),
        ),
      );
    }

    return SingleChildScrollView(
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
                  isOnline: true,
                  localPathOrUrl: userInfo!.fileUrl,
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
          itemText('Username:', '@${userInfo.username}'),
          itemText('Full name:', userInfo.fullName ?? ''),
          itemText('Email:', userInfo.email ?? ''),
          itemText('Phone number:', userInfo.phone ?? ''),
          itemText('Parent of students:', ''),
          isNullOrEmpty(userInfo.parentOf)
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    'There is no data on students who are children of this parent',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : SizedBox(
                  height: 140 * (userInfo.parentOf!.length).toDouble(),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userInfo.parentOf!.length,
                    itemBuilder: (context, index) =>
                        _studentCard(userInfo.parentOf![index]),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _studentCard(Student student) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 10),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: Colors.grey.withOpacity(0.1),
          border: Border.all(
            width: 0.5,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 130,
                width: 90,
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
                      itemTextStudent('SSID:', student.code ?? ''),
                      itemTextStudent('Name:', student.name ?? ''),
                      itemTextStudent(
                          'D.O.B:', formatDate('${student.dateOfBirth}')),
                      itemTextStudent(
                          'Class:', student.classResponse?.className ?? ''),
                      itemTextStudent('School Year:',
                          student.classResponse?.schoolYear ?? ''),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 10, 32, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primaryColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemTextStudent(String title, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.primaryColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
