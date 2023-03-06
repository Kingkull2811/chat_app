import 'package:chat_app/screens/authenticator/signup/sign_up_event.dart';
import 'package:chat_app/screens/authenticator/signup/sign_up_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState>{
  final BuildContext context;


  SignUpBloc(this.context): super(SignUpState()){
    on((event, emit) async{
      // if (event is SubmitButton) {
      //   emit(SignUpLoading()) ;
      //
      //   try {
      //     final response = await httpClient.post(
      //       Uri.parse('https://localhost/signup'),
      //       body: {
      //         'username': event.username,
      //         'email': event.email,
      //         'password': event.password,
      //       },
      //     );
      //
      //     if (response.statusCode == 200) {
      //       emit( SignUpSuccess());
      //     } else {
      //       emit ( SignUpFailure(error: 'Sign Up Failed'));
      //     }
      //   } catch (error) {
      //     emit ( SignUpFailure(error: error.toString()));
      //   }
      // }
    });
  }
}