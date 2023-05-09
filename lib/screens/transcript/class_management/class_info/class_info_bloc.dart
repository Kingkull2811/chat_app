import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'class_info_event.dart';
import 'class_info_state.dart';

class ClassInfoBloc extends Bloc<ClassInfoEvent, ClassInfoState> {
  final BuildContext context;

  ClassInfoBloc(this.context) : super(ClassInfoState()) {
    on((event, emit) async {
      if (event is ClassInfoInit) {}
    });
  }
}
