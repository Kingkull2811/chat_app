import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './profile_event.dart';
import './profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState>{
  ProfileBloc(BuildContext context): super(ProfileState()){
    on((event, emit) async{

    });
  }
}