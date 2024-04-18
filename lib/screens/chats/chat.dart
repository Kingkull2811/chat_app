import 'package:chat_app/l10n/l10n.dart';
import 'package:chat_app/network/model/user_from_firebase.dart';
import 'package:chat_app/routes.dart';
import 'package:chat_app/screens/chats/chat_bloc.dart';
import 'package:chat_app/screens/chats/chat_event.dart';
import 'package:chat_app/screens/chats/chat_state.dart';
import 'package:chat_app/screens/chats/tab/chat_tab.dart';
import 'package:chat_app/screens/chats/tab/contact_tab.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/widgets/animation_loading.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/screen_utilities.dart';

class ChatsPage extends StatefulWidget {
  final bool toContact;

  const ChatsPage({Key? key, this.toContact = false}) : super(key: key);

  @override
  State<ChatsPage> createState() => ChatsPageState();
}

class ChatsPageState extends State<ChatsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _searchNewMessageController = TextEditingController();

  final bool isAdmin = SharedPreferencesStorage().getAdminRole() || SharedPreferencesStorage().getTeacherRole();

  late ChatsBloc _chatsBloc;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.toContact ? 1 : 0,
    );
    _chatsBloc = BlocProvider.of<ChatsBloc>(context)..add(ChatInit());
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chatsBloc.close();
    _searchNewMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsBloc, ChatsState>(
      listenWhen: (preState, curState) {
        return curState.apiError != ApiError.noError;
      },
      listener: (context, curState) {
        if (curState.apiError == ApiError.noInternetConnection) {
          showMessageNoInternetDialog(context);
        }
        if (curState.apiError == ApiError.internalServerError) {
          showCupertinoMessageDialog(context, context.l10n.error, content: context.l10n.internal_server_error);
        }
      },
      builder: (context, state) {
        return state.isLoading ? const AnimationLoading() : _body(context, state);
      },
    );
  }

  Widget _body(BuildContext context, ChatsState state) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _appBar(state.userData),
        body: TabBarView(
          controller: _tabController,
          children: [
            ChatTab(listUser: state.listUser),
            ContactTab(listUser: state.listUser),
          ],
        ),
      ),
    );
  }

  void reloadPage() {
    _chatsBloc.add(ChatInit());
  }

  PreferredSizeWidget _appBar(UserFirebaseData? userData) {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Colors.grey[50],
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
        child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 1, color: AppColors.primaryColor),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.profile);
                },
                child: AppImage(
                  isOnline: true,
                  localPathOrUrl: userData?.fileUrl,
                  boxFit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorWidget: Image.asset(
                    'assets/images/ic_account_circle.png',
                    color: Colors.grey.withOpacity(0.6),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )),
      ),
      centerTitle: true,
      title: Container(
        height: 40,
        width: 250,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey[50], border: Border.all(width: 1, color: AppColors.primaryColor)),
        child: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          indicatorWeight: 0,
          indicatorColor: Colors.black,
          indicator: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          tabs: [
            Tab(text: context.l10n.chats),
            Tab(text: context.l10n.contacts),
          ],
        ),
      ),
    );
  }
}
