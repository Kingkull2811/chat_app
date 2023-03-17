import 'package:chat_app/screens/chats/group_participants/dialog_add_member.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GroupParticipantPage extends StatefulWidget {
  const GroupParticipantPage({Key? key}) : super(key: key);

  @override
  State<GroupParticipantPage> createState() => _GroupParticipantPageState();
}

class _GroupParticipantPageState extends State<GroupParticipantPage> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  bool isAdded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.grey[50],
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
            size: 24,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Group participants',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: _item.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return InkWell(
                onTap: () async {
                  await showDialog(
                    barrierColor: Colors.grey[500],
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => DialogAddMember(
                      searchController: _searchController,
                      focusNode: _focusNode,
                      items: _item,
                    ),

                    // _dialogAddMember(context),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey[200],
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.person_add_alt_outlined,
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                      title: const Text(
                        'Add new member to group',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
            }
            return itemList(context, _item[index - 1]);
          },
        ),
      ),
    );
  }

  Widget itemList(BuildContext context, GroupItems items) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(items.image),
                ),
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).primaryColor,
                )),
          ),
          title: Text(
            items.title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            items.subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black,
            ),
          ),
          trailing: Container(
            height: 30,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 1.5,
                style: BorderStyle.solid,
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: Center(
              child: Text(
                items.isAdmin ? 'Admin' : 'Member',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final List<GroupItems> _item = [
    GroupItems(
      image:
          "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      title: 'Admin',
      subtitle: 'https://images.pexels.com/photos',
      isAdmin: true,
    ),
    GroupItems(
      image:
          "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      title: 'title',
      subtitle: 'https://images.pexels.com/photos',
      isAdmin: false,
    ),
    GroupItems(
      image:
          "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      title: 'title',
      subtitle: 'https://images.pexels.com/photos',
      isAdmin: false,
    ),
    GroupItems(
      image:
          "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      title: 'title',
      subtitle: 'https://images.pexels.com/photos',
      isAdmin: false,
    ),
    GroupItems(
      image:
          "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      title: 'title',
      subtitle: 'https://images.pexels.com/photos',
      isAdmin: false,
    ),
    GroupItems(
      image:
          "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      title: 'title',
      subtitle: 'https://images.pexels.com/photos',
      isAdmin: false,
    ),
    GroupItems(
      image:
          "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      title: 'title',
      subtitle: 'https://images.pexels.com/photos',
      isAdmin: false,
    ),
    GroupItems(
      image:
          "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      title: 'title',
      subtitle: 'https://images.pexels.com/photos',
      isAdmin: false,
    ),
    GroupItems(
      image:
          "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      title: 'title',
      subtitle: 'https://images.pexels.com/photos',
      isAdmin: false,
    ),
    GroupItems(
      image:
          "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      title: 'title',
      subtitle: 'https://images.pexels.com/photos',
      isAdmin: false,
    ),
  ];
}

class GroupItems {
  final String image;
  final String title;
  final String subtitle;
  final bool isAdmin;

  GroupItems({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.isAdmin,
  });
}
