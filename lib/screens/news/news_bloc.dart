import 'package:chat_app/network/response/news_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './news_event.dart';
import './news_state.dart';
import '../../network/repository/news_repository.dart';
import '../../utilities/enum/api_error_result.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final _newsRepository = NewsRepository();

  NewsBloc(BuildContext context) : super(NewsState()) {
    on((event, emit) async {
      if (event is GetListNewEvent) {
        emit(state.copyWith(
          isLoading: true,
          apiError: ApiError.noError,
        ));

        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final response = await _newsRepository.getListNews();

          if (response is NewsResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              listNews: response.listNews,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listNews: [],
            ));
          }
        }
      }
    });
  }
}
