import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './news_event.dart';
import './news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState>{
  NewsBloc(BuildContext context): super(NewsState()){
    on((event, emit) async{

    });
  }
}