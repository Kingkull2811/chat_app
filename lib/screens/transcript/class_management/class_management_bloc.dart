import 'dart:developer';

import 'package:chat_app/network/repository/class_repository.dart';
import 'package:chat_app/network/response/class_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/enum/api_error_result.dart';
import 'class_management_event.dart';
import 'class_management_state.dart';

class ClassManagementBloc
    extends Bloc<ClassManagementEvent, ClassManagementState> {
  final _classRepository = ClassRepository();
  final BuildContext context;

  ClassManagementBloc(this.context) : super(ClassManagementState()) {
    on<ClassManagementEvent>((event, emit) async {
      if (event is InitEvent) {
        emit(state.copyWith(isLoading: true));

        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          emit(state.copyWith(
            isLoading: false,
            apiError: ApiError.noInternetConnection,
          ));
        } else {
          final response = await _classRepository.getListClass();
          log('response News: $response ');

          if (response is ClassResponse) {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.noError,
              listClass: response.listClass,
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              apiError: ApiError.internalServerError,
              listClass: [],
            ));
          }
        }
      }
    });
  }
}
