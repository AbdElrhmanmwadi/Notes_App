// ignore_for_file: must_be_immutable

part of 'isupdate_cubit.dart';

abstract class IsupdateState extends Equatable {
  const IsupdateState();

  @override
  List<Object> get props => [];
}

 class IsUpdateInitialState extends IsupdateState {
  bool  isshow=false;

  IsUpdateInitialState(this.isshow);
   @override
  List<Object> get props => [isshow];
  



 }
 class canPopstate extends IsupdateState {
  bool  canPop=false;

  canPopstate(this.canPop);
   @override
  List<Object> get props => [canPop];




 }
 class pageIndexState extends IsupdateState {
  int  pageIndex=0;

  pageIndexState(this.pageIndex);
   @override
  List<Object> get props => [pageIndex];




 }
 class desbleButtonState extends IsupdateState {
  bool  desbleButton=true;

  desbleButtonState(this.desbleButton);
   @override
  List<Object> get props => [desbleButton];




 }
