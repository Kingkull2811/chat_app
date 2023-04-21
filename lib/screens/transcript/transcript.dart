import 'package:chat_app/screens/transcript/transcript_bloc.dart';
import 'package:chat_app/screens/transcript/transcript_state.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/enum/api_error_result.dart';
import 'package:chat_app/widgets/app_image.dart';
import 'package:chat_app/widgets/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/screen_utilities.dart';
import '../../utilities/utils.dart';
import '../../widgets/animation_loading.dart';

class TranscriptPage extends StatefulWidget {
  const TranscriptPage({Key? key}) : super(key: key);

  @override
  State<TranscriptPage> createState() => TranscriptPageState();
}

class TranscriptPageState extends State<TranscriptPage> {
  bool isAdmin = true;

  @override
  void initState() {
    // isAdmin = check();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TranscriptBloc, TranscriptState>(
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
        } else if (isAdmin) {
          body = _bodyAdmin(context, curState);
        } else {
          body = _body(context, curState);
        }
        return body;
      },
    );
  }

  Widget _body(BuildContext context, TranscriptState state) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.grey[50],
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Transcript',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => const MessageDialog(
                  title: AppConstants.calculateFinalPoint,
                  content:
                      '${AppConstants.finalPoint}\n${AppConstants.processPoint}',
                ),
              );
            },
            icon: Icon(
              Icons.info_outline,
              size: 24,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      // extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              _cardStudent(),
              _cardSubject(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bodyAdmin(BuildContext context, TranscriptState state) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.grey[50],
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Transcript',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {},
            icon: Icon(
              Icons.add_circle_outline_outlined,
              size: 26,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      // extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Container(
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _cardStudent() {
    //todo::
    String urlImage =
        'https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260';

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AppImage(
                  localPathOrUrl: urlImage,
                  boxFit: BoxFit.cover,
                  width: 100,
                  height: 150,
                  errorWidget: Container(
                    color: Colors.grey,
                    child: Center(
                      child: Icon(
                        Icons.person_outline,
                        size: 100,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 12),
                    child: Center(
                      child: Text(
                        'Student Card',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  _itemCard('ID', stInfo.userId.toString()),
                  _itemCard('Name', stInfo.studentName.toString()),
                  _itemCard('Class', stInfo.studentClass.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemCard(
    String title,
    String titleValue,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: SizedBox(
              width: 50,
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Text(
              ': $titleValue',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardSubject() {
    final columns = [
      'Subject name',
      'First Point',
      'Second Point',
      'Final Exam Point',
      'Final Point',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: DataTable(
            columns: getColumns(columns),
            rows: getRows(transcriptData),
          ),
        ),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String columns) {
      return DataColumn(
        label: Text(
          columns,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      );
    }).toList();
  }

  List<DataRow> getRows(List<TranscriptData> data) {
    return data.map((TranscriptData transcriptData) {
      final cells = [
        transcriptData.subjectName,
        transcriptData.firstPoint,
        transcriptData.secondPoint,
        transcriptData.finalExamPoint,
        transcriptData.finalPoint,
      ];

      return DataRow(
        cells: modelBuilder(
          cells,
          (index, cell) {
            //isAdmin -> show edit Icon
            // final bool showEdit = isAdmin;

            if (cell == null) {
              return const DataCell(
                Center(
                  child: Text('-'),
                ),
                showEditIcon: false,
              );
            }
            return DataCell(
              Center(
                child: Text('$cell'),
              ),
              showEditIcon: false,
            );
          },
        ),
      );
    }).toList();
  }
}

class StudentInfo {
  final String? studentId;
  final String? studentName;
  final String? studentClass;
  final String? userId;

  StudentInfo({
    this.studentId,
    this.studentName,
    this.studentClass,
    this.userId,
  });
}

StudentInfo stInfo = StudentInfo(
  studentId: 'SID123456',
  studentName: 'Name_of_ID_sds das da sd',
  studentClass: 'Class AA',
  userId: '001',
);

class TranscriptData {
  final String? subjectName;
  final double? firstPoint;
  final double? secondPoint;
  final double? finalExamPoint;
  final double? finalPoint;

  TranscriptData({
    this.subjectName,
    this.firstPoint,
    this.secondPoint,
    this.finalExamPoint,
    this.finalPoint,
  });
}

List<TranscriptData> transcriptData = [
  TranscriptData(
    subjectName: 'Subject 1',
    firstPoint: null,
    secondPoint: 8.5,
    finalExamPoint: 6.0,
    finalPoint: 8,
  ),
  TranscriptData(
    subjectName: 'Subject 2',
    firstPoint: null,
    secondPoint: 8.5,
    finalExamPoint: 6.0,
    finalPoint: 8,
  ),
  TranscriptData(
    subjectName: 'Subject 3',
    firstPoint: null,
    secondPoint: 8.5,
    finalExamPoint: 6.0,
    finalPoint: 8,
  ),
  TranscriptData(
    subjectName: 'Subject 4',
    firstPoint: null,
    secondPoint: 8.5,
    finalExamPoint: 6.0,
    finalPoint: 8,
  ),
  TranscriptData(
    subjectName: 'Subject 5',
    firstPoint: null,
    secondPoint: 8.5,
    finalExamPoint: 6.0,
    finalPoint: 8,
  ),
  TranscriptData(
    subjectName: 'Subject 6',
    firstPoint: null,
    secondPoint: 8.5,
    finalExamPoint: 6.0,
    finalPoint: 8,
  ),
];
