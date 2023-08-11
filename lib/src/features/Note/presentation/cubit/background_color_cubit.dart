import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'background_color_state.dart';

class BackgroundColorCubit extends Cubit<BackgroundColorState> {
  BackgroundColorCubit() : super(BackgroundColorInitial(Colors.white));
  void changeBackgroundColor(Color color) {
    
    emit(BackgroundColorInitial(color));
  }
}
