import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note/src/common/SharedPref/sharedPref.dart';

part 'fontsize_state.dart';

class FontsizeCubit extends Cubit<FontsizeState> {
  FontsizeCubit()
      : super(changeFontSizeState(
            SharedPrefController().getData(key: 'fontSize') ?? 18));
  double? fontSize;
  void changeFontSize(changeFontSize) {
    fontSize = changeFontSize;
    print('object');
    print(fontSize);

    emit(changeFontSizeState(changeFontSize));
  }
}
