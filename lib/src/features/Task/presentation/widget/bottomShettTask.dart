import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:note/generated/l10n.dart';
import 'package:note/src/features/Note/presentation/cubit/isupdate_cubit.dart';
import 'package:note/src/features/Task/domain/entites/Alarm.dart';
import 'package:note/src/utils/dimensions.dart';
import 'package:note/src/utils/styles.dart';
import 'package:timezone/timezone.dart' as tz;

class bottomShettTask extends StatefulWidget {
  final initValue;
  final hint;
  final onPressed;
  final selectedTimee;

  const bottomShettTask({
    super.key,
    required this.taskController,
    this.initValue,
    this.hint,
    required this.onPressed,
    this.selectedTimee,
  });

  final TextEditingController taskController;

  @override
  State<bottomShettTask> createState() => _bottomShettTaskState();
}

class _bottomShettTaskState extends State<bottomShettTask> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  DateTime dateTime = DateTime.now();
  static int id = 0;

  List<Alarm> alarms = [];

  void _showDialog(Widget child) {
    final DateTime today = DateTime.now();
    final DateTime threeDaysLater = today.add(Duration(days: 3));

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 280,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              Material(
                  color: Colors.transparent,
                  child: Text('Set reminder',
                      style: robotoBlack.copyWith(fontSize: 17))),
              SizedBox(
                height: 5,
              ),
              Material(
                  color: Colors.transparent,
                  child: Text(
                      '${DateFormat('dd MMM hh:mm a').format(DateTime.now())}')),
              SizedBox(
                height: 5,
              ),
              Expanded(child: child),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusExtraLarge),
                      ),
                      minimumSize:
                          Size(150, 40), // Adjust the minimum width as needed
                    ),
                    child: Text(S.of(context).Cancel),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (dateTime != null) {
                        scheduleAlarmNotification(id++, dateTime.toLocal());
                        print(id);
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusExtraLarge),
                      ),
                      minimumSize:
                          Size(150, 40), // Adjust the minimum width as needed
                    ),
                    child: Text(S.of(context).ok),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    IsupdateCubit cubitdesbleButton = BlocProvider.of<IsupdateCubit>(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            Dimensions.radiusDefault), // Adjust the radius as needed
      ),
      elevation: 1,
      child: Container(
        padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                initialValue: widget.initValue,
                onChanged: (value) {
                  widget.taskController.text = value;
                  value.isEmpty
                      ? cubitdesbleButton.desbleButton(false)
                      : cubitdesbleButton.desbleButton(true);
                },
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
                maxLines: 5,
                decoration: InputDecoration(
                  prefixIconConstraints: BoxConstraints.tight(Size(10, 10)),
                  hintText: widget.hint,
                  hintStyle: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Colors.black45),
                  border: InputBorder.none,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      backgroundColor: Colors.grey.withOpacity(.2),
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      _showDialog(
                        CupertinoDatePicker(
                          dateOrder: DatePickerDateOrder.dmy,
                          initialDateTime: dateTime,
                          use24hFormat: false,
                          onDateTimeChanged: (DateTime newDateTime) {
                            setState(() => dateTime = newDateTime);
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.lock_clock),
                    label: Text(
                      '${S.of(context).SetReminder}',
                      style: robotoMedium,
                    ),
                  ),
                  OutlinedButton(
                      onPressed: cubitdesbleButton.desbleButto
                          ? widget.onPressed
                          : widget.onPressed,
                      style: OutlinedButton.styleFrom(
                          disabledForegroundColor: Colors.grey,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(side: BorderSide.none)),
                      child: Text(
                        '${S.of(context).Done}',
                        style: robotoMedium.copyWith(
                            color: cubitdesbleButton.desbleButto
                                ? Colors.amber
                                : Colors.grey,
                            fontSize: Dimensions.fontSizeLarge),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> scheduleAlarmNotification(int alarmId, DateTime time) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      alarmId,
      '${widget.taskController.text} ',
      'Task time finished!',
      tz.TZDateTime.from(time, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarms',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
