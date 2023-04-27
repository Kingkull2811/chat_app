import 'package:chat_app/network/model/news_model.dart';
import 'package:chat_app/network/repository/news_repository.dart';
import 'package:chat_app/screens/news/news_bloc.dart';
import 'package:chat_app/screens/news/news_event.dart';
import 'package:chat_app/screens/news/news_state.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:chat_app/widgets/photo_view.dart';
import 'package:chat_app/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import '../../utilities/enum/api_error_result.dart';
import '../../utilities/screen_utilities.dart';
import '../../utilities/shared_preferences_storage.dart';
import '../../widgets/animation_loading.dart';
import '../../widgets/app_image.dart';
import 'news_info/news_info.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NewsPage> createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  bool isAdmin = SharedPreferencesStorage().getAdminRole() ||
      SharedPreferencesStorage().getTeacherRole();

  @override
  void initState() {
    BlocProvider.of<NewsBloc>(context).add(GetListNewEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsBloc, NewsState>(listenWhen: (preState, curState) {
      return curState.apiError != ApiError.noError;
    }, listener: (context, curState) {
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
    }, builder: (context, curState) {
      Widget body = const SizedBox.shrink();
      if (curState.isLoading) {
        body = const AnimationLoading();
      } else {
        body = _body(context, curState);
      }

      return Scaffold(body: body);
    });
  }

  Widget _body(BuildContext context, NewsState state) {
    List<NewsModel>? listNews = state.listNews;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.grey[50],
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'News',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          isAdmin
              ? IconButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewsInfo(
                          isEdit: false,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: isNotNullOrEmpty(listNews)
          ? Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 300));
                  BlocProvider.of<NewsBloc>(this.context)
                      .add(GetListNewEvent());
                  setState(() {});
                },
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemCount: listNews?.length,
                  itemBuilder: (context, index) =>
                      _createItemNews(listNews![index]),
                ),
              ),
            )
          : _listNoItem(),
    );
  }

  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedTime = DateFormat.Hm().format(dateTime);
    String formattedDate = DateFormat('hh:mm A dd/MM/yyyy').format(dateTime);
    return '$formattedTime $formattedDate';
  }

  Widget _listNoItem() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/ic_no_content.png',
            width: 150,
            height: 150,
            color: Theme.of(context).primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 16),
            child: Text(
              'No news available',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          PrimaryButton(
            text: 'Reload',
            onTap: () {
              BlocProvider.of<NewsBloc>(context).add(GetListNewEvent());
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  Widget _createItemNews(NewsModel item) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListTile(
                      minLeadingWidth: 5,
                      leading: Transform.translate(
                        offset: const Offset(-10, 0),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(25),
                            // image: DecorationImage(
                            //   image: AssetImage(items.avtUserCreate),
                            //   fit: BoxFit.cover,
                            // ),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      title: Transform.translate(
                        offset: const Offset(-16, 0),
                        child: const Text(
                          'items.createBy??' '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      subtitle: Transform.translate(
                        offset: const Offset(-16, 0),
                        child: const Text(
                          "items.createTime??''",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isAdmin)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () async {
                          await _option(item);
                        },
                        child: const Icon(
                          Icons.more_vert,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isNotNullOrEmpty(item.title))
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  item.title!,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (isNotNullOrEmpty(item.content))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ReadMoreText(
                  item.content!,
                  trimLines: 3,
                  textAlign: TextAlign.left,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: ' show more',
                  trimExpandedText: ' show less',
                  lessStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).primaryColor,
                  ),
                  moreStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).primaryColor,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
            if (isNotNullOrEmpty(item.mediaUrl))
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoViewPage(
                          imageUrl: item.mediaUrl ?? '',
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.grey,
                      alignment: Alignment.center,
                      child: AppImage(
                        isOnline: true,
                        localPathOrUrl: item.mediaUrl,
                        boxFit: BoxFit.cover,
                        errorWidget: const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _option(NewsModel item) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsInfo(
                      isEdit: true,
                      newsInfo: item,
                    ),
                  ),
                );
              },
              child: _itemOption(
                icon: Icons.edit_note,
                title: 'Edit this news',
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                await showMessageTwoOption(
                    context, 'Do you want to delete this news?',
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    cancelLabel: 'Cancel',
                    onOk: () async {
                      await _deleteNews(item.id);
                    },
                    okLabel: 'Delete');
              },
              child: _itemOption(
                icon: Icons.delete_outline,
                title: 'Delete this news',
              ),
            ),
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
    );
  }

  Future<void> _deleteNews(int? newsId) async {
    if (newsId == null) {
      showCupertinoMessageDialog(context, 'Did not find the news');
    }
    await NewsRepository().deleteNews(newsId: newsId!);
    if (mounted) {}
    await showCupertinoMessageDialog(context, 'The news has been deleted',
        onCloseDialog: () {
      BlocProvider.of<NewsBloc>(context).add(GetListNewEvent());
      setState(() {});
      Navigator.pop(context);
    });
  }

  Widget _itemOption({
    required IconData icon,
    required String title,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 26, color: Theme.of(context).primaryColor),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
