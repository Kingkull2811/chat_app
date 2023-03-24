import 'package:chat_app/widgets/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import 'add_news/add_news.dart';

class NewsPage extends StatefulWidget {
  final bool needReload;

  const NewsPage({
    Key? key,
    this.needReload = false,
  }) : super(key: key);

  @override
  State<NewsPage> createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  bool isAdmin = false;

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
                        builder: (context) => const AddNewsPage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit_note,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _itemNews.length,
            itemBuilder: (context, index) => _createItemNews(_itemNews[index])),
      ),
    );
  }

  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedTime = DateFormat.Hm().format(dateTime);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return '$formattedTime $formattedDate';
  }

  Widget _createItemNews(News items) {
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
                      image: DecorationImage(
                        image: AssetImage(items.avtUserCreate),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                title: Transform.translate(
                  offset: const Offset(-16, 0),
                  child: Text(
                    items.userCreate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                subtitle: Transform.translate(
                  offset: const Offset(-16, 0),
                  child: Text(
                    formatTimestamp(items.timeCreate),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ReadMoreText(
                items.titleNews,
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
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PhotoViewPage(imageUrl: items.imageNews),
                    ),
                  );
                },
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(items.imageNews),
                      fit: BoxFit.cover,
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
}

List<News> _itemNews = [
  News(
    userCreate: 'Martha Craig',
    avtUserCreate: 'assets/images/image_profile_1.png',
    timeCreate: '2023-03-23T11:05:43.475',
    titleNews:
        'What is Lorem Ipsum?\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    imageNews:
        "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  ),
  News(
    userCreate: 'Joshua Lawrence',
    avtUserCreate: 'assets/images/image_profile_2.png',
    timeCreate: '2023-03-22T11:05:43.475',
    titleNews:
        'What is Lorem Ipsum?\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    imageNews:
        "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  ),
  News(
    userCreate: 'Joshua Lawrence',
    avtUserCreate: 'assets/images/image_profile_2.png',
    timeCreate: '2023-03-22T11:05:43.475',
    titleNews:
        'What is Lorem Ipsum?\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    imageNews:
        "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  ),
  News(
    userCreate: 'Joshua Lawrence',
    avtUserCreate: 'assets/images/image_profile_2.png',
    timeCreate: '2023-03-22T11:05:43.475',
    titleNews:
        'What is Lorem Ipsum?\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    imageNews:
        "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  ),
  News(
    userCreate: 'Joshua Lawrence',
    avtUserCreate: 'assets/images/image_profile_2.png',
    timeCreate: '2023-03-22T11:05:43.475',
    titleNews:
        'What is Lorem Ipsum?\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    imageNews:
        "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  ),
];

//demo
class News {
  final String userCreate;
  final String avtUserCreate;
  final String timeCreate;
  final String titleNews;
  final String imageNews;

  News({
    required this.userCreate,
    required this.avtUserCreate,
    required this.timeCreate,
    required this.titleNews,
    required this.imageNews,
  });
}
