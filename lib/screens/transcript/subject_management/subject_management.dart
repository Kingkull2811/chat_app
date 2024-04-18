import 'package:chat_app/l10n/l10n.dart';
import 'package:chat_app/network/response/base_get_response.dart';
import 'package:chat_app/screens/transcript/subject_management/subject_management_state.dart';
import 'package:chat_app/widgets/data_not_found.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/model/subject_model.dart';
import '../../../network/repository/class_repository.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../utilities/utils.dart';
import '../../../widgets/animation_loading.dart';
import '../../../widgets/primary_button.dart';
import 'subject_management_bloc.dart';
import 'subject_management_event.dart';

class SubjectManagementPage extends StatefulWidget {
  const SubjectManagementPage({Key? key}) : super(key: key);

  @override
  State<SubjectManagementPage> createState() => _SubjectManagementPageState();
}

class _SubjectManagementPageState extends State<SubjectManagementPage> {
  late SubjectManagementBloc _subjectBloc;

  final _subjectCodeController = TextEditingController();
  final _subjectNameController = TextEditingController();

  final _classRepository = ClassRepository();

  Future<void> _reloadPage() async {
    showLoading(context);
    await Future.delayed(const Duration(seconds: 1), () {
      _subjectBloc.add(InitSubjectEvent());
      Navigator.pop(context);
      setState(() {});
    });
  }

  @override
  void initState() {
    _subjectBloc = BlocProvider.of<SubjectManagementBloc>(context)..add(InitSubjectEvent());
    super.initState();
  }

  @override
  void dispose() {
    _subjectBloc.close();
    _subjectCodeController.dispose();
    _subjectNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubjectManagementBloc, SubjectManagementState>(
      listenWhen: (preState, curState) {
        return curState.apiError != ApiError.noError;
      },
      listener: (context, curState) {
        if (curState.apiError == ApiError.internalServerError) {
          showCupertinoMessageDialog(context, context.l10n.error, content: context.l10n.internal_server_error);
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
          body = _body(context, curState.listSubject);
        }
        return body;
      },
    );
  }

  Widget _body(BuildContext context, List<SubjectModel>? listSubject) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Theme.of(context).primaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, size: 24, color: Colors.white),
        ),
        centerTitle: true,
        title: Text(
          context.l10n.subManage,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return CupertinoActionSheet(
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        onPressed: () async {
                          Navigator.pop(context);
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => _formSubjectInfo(context),
                          ).whenComplete(() async {
                            setState(() {
                              _subjectNameController.clear();
                            });
                            await _reloadPage();
                          });
                        },
                        child: Text(
                          context.l10n.addSub,
                          style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        context.l10n.cancel,
                        style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.more_vert_outlined,
              size: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: isNullOrEmpty(listSubject)
          ? DataNotFoundPage(title: context.l10n.noSubject)
          : RefreshIndicator(
              onRefresh: () async => await _reloadPage(),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                      child: Text(
                        context.l10n.subjects,
                        style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
                      ),
                    ),
                    SizedBox(
                      height: 150 + 80 * (listSubject!.length + 1).toDouble(),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: listSubject.length,
                        itemBuilder: (context, index) => itemSubject(listSubject[index]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget itemSubject(SubjectModel data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(width: 0.5, color: Colors.grey.withOpacity(0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '${context.l10n.subCode}: ${data.code}',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      '${context.l10n.subName}: ${data.subjectName}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: InkWell(
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => _formSubjectInfo(context, isEdit: true, subjectData: data),
                  );
                },
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(17), color: Colors.grey.withOpacity(0.3)),
                  child: Icon(Icons.edit_note, size: 24, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: InkWell(
                onTap: () {
                  showMessageTwoOption(
                    context,
                    context.l10n.deleteSub,
                    okLabel: context.l10n.delete,
                    onOk: () async {
                      showLoading(context);
                      _subjectBloc.add(DeleteSubjectEvent((data.subjectId)!));
                      Navigator.pop(context);
                      await _reloadPage();
                    },
                  );
                },
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  child: const Icon(Icons.delete_outline, size: 24, color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formSubjectInfo(
    BuildContext context, {
    bool isEdit = false,
    SubjectModel? subjectData,
  }) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.white,
            ),
          ),
          title: Text(
            isEdit ? context.l10n.editSub : context.l10n.addSub,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (isEdit)
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: _inputText(
                    context,
                    readOnly: true,
                    controller: _subjectCodeController,
                    inputAction: TextInputAction.done,
                    labelText: context.l10n.subCode,
                    initText: isEdit ? '${subjectData?.code}' : '',
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(top: isEdit ? 16 : 32),
                child: _inputText(
                  context,
                  controller: _subjectNameController,
                  inputAction: TextInputAction.done,
                  labelText: context.l10n.subName,
                  initText: isEdit ? '${subjectData?.subjectName}' : '',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: PrimaryButton(
                  text: isEdit ? context.l10n.update : context.l10n.save,
                  onTap: () {
                    if (_subjectCodeController.text.isEmpty && isEdit) {
                      showCupertinoMessageDialog(context, context.l10n.emptySubCode);
                    } else if (_subjectNameController.text.isEmpty) {
                      showCupertinoMessageDialog(context, context.l10n.emptySubName);
                    } else {
                      final Map<String, dynamic> data = {if (isEdit) "code": _subjectCodeController.text.trim(), "name": _subjectNameController.text.trim()};
                      isEdit ? _updateSubject(context, (subjectData?.subjectId)!, data) : _addSubject(context, data);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addSubject(BuildContext context, Map<String, dynamic> data) async {
    final response = await _classRepository.addSubject(data: data);
    if (response is SubjectModel && context.mounted) {
      showCupertinoMessageDialog(
        this.context,
        context.l10n.successfully,
        onClose: () async {
          Navigator.pop(context);

          await _reloadPage();
        },
      );
    } else if (response is ExpiredTokenGetResponse && context.mounted) {
      logoutIfNeed(this.context);
    } else {
      showCupertinoMessageDialog(
        this.context,
        context.l10n.addSubFail,
      );
    }
  }

  _updateSubject(
    BuildContext context,
    int subjectId,
    Map<String, dynamic> data,
  ) async {
    final response = await _classRepository.editSubject(
      subjectId: subjectId,
      data: data,
    );
    if (response is SubjectModel && context.mounted) {
      showCupertinoMessageDialog(
        this.context,
        context.l10n.updateSubSuccess,
        onClose: () async {
          Navigator.pop(context);
          await _reloadPage();
        },
      );
    } else if (response is ExpiredTokenGetResponse && context.mounted) {
      logoutIfNeed(this.context);
    } else {
      showCupertinoMessageDialog(this.context, context.l10n.updateSubFail);
    }
  }

  Widget _inputText(
    BuildContext context, {
    TextEditingController? controller,
    TextInputAction? inputAction,
    String? initText,
    String? labelText,
    String? hintText,
    Function()? onTap,
    bool readOnly = false,
  }) {
    if (initText != null) {
      controller?.text = initText;
      controller?.selection = TextSelection(
        baseOffset: 0,
        extentOffset: initText.length,
      );
    }
    return SizedBox(
      height: 50,
      child: TextFormField(
        onTap: onTap,
        readOnly: readOnly,
        controller: controller,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: inputAction ?? TextInputAction.done,
        onFieldSubmitted: (value) {},
        onChanged: (_) {},
        keyboardType: TextInputType.text,
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 26, 26, 26),
        ),
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            contentPadding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
            filled: true,
            fillColor: const Color.fromARGB(102, 230, 230, 230),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                width: 1,
                color: Color.fromARGB(128, 130, 130, 130),
              ),
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6))),
      ),
    );
  }
}
