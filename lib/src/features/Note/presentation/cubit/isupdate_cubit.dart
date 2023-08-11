import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note/src/features/Note/presentation/view/widget/viewEditNote.dart';

part 'isupdate_state.dart';

class IsupdateCubit extends Cubit<IsupdateState> {
  bool canPo = false;
  bool desbleButto= false;
  int pageInde = 0;
  IsupdateCubit() : super(IsUpdateInitialState(false));
  void isUpdate(isshow) {
    emit(IsUpdateInitialState(isshow));
  }

  void canPop(canPop) {
    canPo = canPop;
    emit(canPopstate(canPop));
  }

  void pageIndex(pageIndex) {
    pageInde = pageIndex;
    emit(pageIndexState(pageIndex));
  }
  void desbleButton(pageIndex) {
    desbleButto = pageIndex;
    emit(desbleButtonState(pageIndex));
  }
}
