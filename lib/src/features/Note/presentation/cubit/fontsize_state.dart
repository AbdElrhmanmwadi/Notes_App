part of 'fontsize_cubit.dart';

abstract class FontsizeState extends Equatable {
  const FontsizeState();

  @override
  List<Object> get props => [];
}

class FontsizeInitial extends FontsizeState {}

class changeFontSizeState extends FontsizeState {
  double fontSize;

  changeFontSizeState(this.fontSize);
  @override
  List<Object> get props => [fontSize];
}
