import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'controller_state.dart';

class ControllerCubit extends Cubit<ControllerState> {
  ControllerCubit() : super(ControllerInitial(false));
  bool isExpande = false;
  void isExpanded(isExpanded) {
    isExpande = isExpanded;
    emit(ControllerInitial(isExpanded));
  }

  void isComplete(isComplete) {
    emit(isCompleteState(isComplete));
  }
}
