// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';

class CounterController extends GetxController {
  var counterOne = 0.obs;
  var counterTwo = 0.obs;
  var canPop = false.obs;
  SumCounter() => counterTwo.value + counterOne.value;
}
