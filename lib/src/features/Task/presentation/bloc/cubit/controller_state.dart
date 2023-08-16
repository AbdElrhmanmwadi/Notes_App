part of 'controller_cubit.dart';

abstract class ControllerState extends Equatable {
  const ControllerState();

  @override
  List<Object> get props => [];
}

class ControllerInitial extends ControllerState {
  bool isExpandedd = false;
  ControllerInitial(this.isExpandedd);
  @override
  List<Object> get props => [isExpandedd];
}

class isCompleteState extends ControllerState {
  bool isComplete = false;
  isCompleteState(this.isComplete);
  @override
  List<Object> get props => [isComplete];
}
