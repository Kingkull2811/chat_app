import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './transcript_event.dart';
import './transcript_state.dart';

class TranscriptBloc extends Bloc<TranscriptEvent, TranscriptState>{
  TranscriptBloc(BuildContext context): super(TranscriptState()){
    on((event, emit) async{

    });
  }
}