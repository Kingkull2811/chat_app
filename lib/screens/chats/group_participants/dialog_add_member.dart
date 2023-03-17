import 'package:chat_app/utilities/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'group_participants.dart';

class DialogAddMember extends StatefulWidget {
  final TextEditingController searchController;
  final FocusNode focusNode;
  final List<GroupItems> items;

   const DialogAddMember({Key? key, required this.searchController, required this.focusNode, required this.items}) : super(key: key);

  @override
  State<DialogAddMember> createState() => _DialogAddMemberState();
}

class _DialogAddMemberState extends State<DialogAddMember> {
  bool isAdded = false;

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Add new member to group',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(fontSize: 16),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.cancel_outlined,
              size: 24,
              color: AppConstants().red700,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: Column(
          children: [
            SizedBox(
              height: 35,
              child: TextField(
                controller: widget.searchController,
                onSubmitted: (_) => widget.focusNode.requestFocus(),
                maxLines: 1,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                  prefixIconColor: Theme.of(context).primaryColor,
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 6.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color.fromARGB(128, 130, 130, 130),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[300],
                          ),
                          child: ListTile(
                            dense: true,
                            horizontalTitleGap: 10,
                            visualDensity: const VisualDensity(
                              horizontal: 0,
                              vertical: -2.5,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget.items[index].image),
                                ),
                              ),
                            ),
                            title: Text(
                              widget.items[index].title,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: SizedBox(
                              width: 100,
                              child: Text(
                                'email & phone number',
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {
                                //add member to group
                                if (kDebugMode) {
                                  print('add to group: $isAdded');
                                }
                                setState(() {
                                  isAdded = !isAdded;
                                });
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: isAdded
                                      ? Colors.transparent
                                      : Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: isAdded
                                    ? Icon(
                                  Icons.task_alt,
                                  size: 20,
                                  color: AppConstants().green600,
                                )
                                    : const Icon(
                                  Icons.person_add_alt_outlined,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
