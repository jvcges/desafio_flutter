import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_wrapper_event.dart';
part 'main_wrapper_state.dart';

class MainWrapperBloc extends Bloc<MainWrapperEvent, MainWrapperState> {
  MainWrapperBloc() : super(CurrentPageState(index: 0)) {
    on<ChangePage>((event, emit) {
      emit(CurrentPageState(index: event.index));
    });
  }
}
