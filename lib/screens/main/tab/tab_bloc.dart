import 'package:bloc/bloc.dart';
import 'package:chat_app/screens/main/tab/tab_event.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  final AppTab initTab;

  TabBloc({
    this.initTab = AppTab.chat,
  }) : super(initTab) {
    on((event, emit) {
      if (event is TabUpdated) {
        emit(event.tab);
      }
    });
  }
}