part of 'background_color_cubit.dart';

abstract class BackgroundColorState extends Equatable {
  const BackgroundColorState();

  @override
  List<Object> get props => [];
}

class BackgroundColorInitial extends BackgroundColorState {
  final Color color;

  BackgroundColorInitial(this.color);
  @override
  List<Object> get props => [color];
}
