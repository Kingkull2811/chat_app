import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'enter_point_subject_event.dart';
part 'enter_point_subject_state.dart';

class EnterPointSubjectBloc extends Bloc<EnterPointSubjectEvent, EnterPointSubjectState> {
  EnterPointSubjectBloc() : super(EnterPointSubjectInitial()) {
    on<EnterPointSubjectEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
