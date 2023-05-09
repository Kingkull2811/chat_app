import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../network/model/student.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/app_image.dart';

class ViewListStudentSelected extends StatefulWidget {
  final List<Student>? listStudent;

  const ViewListStudentSelected({
    Key? key,
    required this.listStudent,
  }) : super(key: key);

  @override
  State<ViewListStudentSelected> createState() =>
      _ViewListStudentSelectedState();
}

class _ViewListStudentSelectedState extends State<ViewListStudentSelected> {
  List<Student> listStudentRemove = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, listStudentRemove);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'List students added',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: isNullOrEmpty(widget.listStudent)
          ? Center(
              child: Text(
                'No students have been added to the list yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          : ListView.builder(
              itemCount: widget.listStudent!.length,
              itemBuilder: (context, index) => _itemListStudent(
                context,
                widget.listStudent![index],
              ),
            ),
    );
  }

  Widget _itemListStudent(BuildContext context, Student student) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
          child: Container(
            width: MediaQuery.of(context).size.width - 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Student Id:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              student.code ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            'Student Name:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              student.name ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            'Date of birth:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              formatDate('${student.dateOfBirth}'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            'Class:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              student.classResponse?.className ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: InkWell(
            onTap: () {
              setState(() {
                listStudentRemove.add(student);
                widget.listStudent?.remove(student);
              });
            },
            child: Icon(
              Icons.cancel,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  String formatDate(String value) {
    return DateFormat('dd-MM-yyyy').format(DateTime.tryParse(value)!);
  }
}
