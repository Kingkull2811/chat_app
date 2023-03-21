import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String imageUrl;
  final String name;
  final bool isAdmin;
  final Function()? onTapSee;
  final Function()? onTapRemoveMember;

  const InfoDialog({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.isAdmin,
    this.onTapSee,
    this.onTapRemoveMember,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageUrl),
              ),
              border: Border.all(
                width: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              padding: const EdgeInsets.only(left: 16, top: 0, right: 2.5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18)),
              alignment: AlignmentDirectional.centerStart,
              child: GestureDetector(
                onTap: onTapSee,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'See profile $name',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 24,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),
            isAdmin
                ? const SizedBox.shrink()
                : Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 16, right: 2.5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18)),
                    alignment: AlignmentDirectional.centerStart,
                    child: GestureDetector(
                      onTap: onTapRemoveMember,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Remove $name from group',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.group_remove_outlined,
                              size: 24,
                              color: Colors.black,
                            ),
                          )
                        ],
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
