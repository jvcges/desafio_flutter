part of 'main_wrapper_bloc.dart';

sealed class MainWrapperState {
  final int index;

  MainWrapperState({required this.index});
}

class CurrentPageState extends MainWrapperState {
  CurrentPageState({required super.index});
}
