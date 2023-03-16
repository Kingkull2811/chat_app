import 'package:flutter/material.dart';

class GroupParticipantPage extends StatelessWidget {
  GroupParticipantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
            itemCount: _item.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6,),
                  child: SizedBox(
                    height: 60,
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
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
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                );
              }
              return itemList(
                context,
                image: _item[index].image,
                title: _item[index].title,
                subtitle: _item[index].subtitle,
                isAdmin: _item[index].isAdmin,
              );
            }),
      ),
    );
  }

  Widget itemList(
    BuildContext context, {
    required String image,
    required String title,
    required String subtitle,
    bool isAdmin = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6,),
      child: SizedBox(
        height: 60,
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(image),
              ),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black,
            ),
          ),
          trailing: isAdmin
              ? Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 1.5,
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Text(
                    'Admin',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  final List<GroupItems> _item = [
    GroupItems(
      image:
          "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      title: 'title',
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
    this.isAdmin = false,
  });
}
