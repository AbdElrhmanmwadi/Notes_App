// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  List<Alarm> alarms = [];

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
        padding: EdgeInsets.all(20),
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
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusDefault)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          backgroundColor: Colors.grey.withOpacity(.2),
                          foregroundColor: Colors.black),
                      onPressed: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((selectedTime) {
                          if (selectedTime != null) {
                            setState(() {
                              print(selectedTime);
                              alarms.add(Alarm(time: selectedTime));
                            });
                            scheduleAlarmNotification(
                                alarms.length - 1, selectedTime);
                          }
                        });
                      },
                      icon: Icon(Icons.lock_clock),
                      label: Text(
                        '${S.of(context).SetReminder}',
                        style: robotoMedium,
                      )),
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

  Future<void> scheduleAlarmNotification(int alarmId, TimeOfDay time) async {
    final now = DateTime.now();
    final alarmDateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      alarmId,
      '${widget.taskController.text} ',
      'Task time finished!',
      tz.TZDateTime.from(alarmDateTime, tz.local),
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
