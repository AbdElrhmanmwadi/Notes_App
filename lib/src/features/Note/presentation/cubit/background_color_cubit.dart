import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'background_color_state.dart';

class BackgroundColorCubit extends Cubit<BackgroundColorState> {
  Color colo = Colors.white;
  BackgroundColorCubit() : super(BackgroundColorInitial(Colors.white));
  void changeBackgroundColor(Color color) {
    colo = color;
    emit(BackgroundColorInitial(colo));
  }

  @override
  Future<void> close() {
    BackgroundColorCubit().close();
    return super.close();
  }
}
