part of 'main_wrapper_bloc.dart';

sealed class MainWrapperEvent {}

class ChangePage extends MainWrapperEvent {
  final int index;

  ChangePage({this.index = 0});
}
