import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(BuildContext context) : super(ProfileState()) {
    on((event, emit) async {
      if (event is DisplayLoading) {
        emit(state.copyWith(
          isLoading: true,
          isEdit: false,
        ));
      }

      if (event is EditProfile) {
        emit(state.copyWith(
          isLoading: false,
          isEdit: true,
        ));
      }
    });
  }
}
