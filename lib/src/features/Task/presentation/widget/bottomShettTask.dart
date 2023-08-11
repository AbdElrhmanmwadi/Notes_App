// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/generated/l10n.dart';
import 'package:note/src/features/Note/presentation/cubit/isupdate_cubit.dart';
import 'package:note/src/utils/dimensions.dart';
import 'package:note/src/utils/styles.dart';

class bottomShettTask extends StatelessWidget {
  final initValue;
  final hint;
  final onPressed;

  const bottomShettTask({
    super.key,
    required this.taskController,
    this.initValue,
    this.hint,
    required this.onPressed,
  });

  final TextEditingController taskController;

  @override
  Widget build(BuildContext context) {
    IsupdateCubit cubitdesbleButton = BlocProvider.of<IsupdateCubit>(context);
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              initialValue: initValue,
              onChanged: (value) {
                taskController.text = value;
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
                hintText: hint,
                hintStyle:
                    robotoRegular.copyWith(fontSize: 16, color: Colors.black45),
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
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        backgroundColor: Colors.grey.withOpacity(.2),
                        foregroundColor: Colors.black),
                    onPressed: () {},
                    icon: Icon(Icons.lock_clock),
                    label: Text(
                      '${S.of(context).SetReminder}',
                      style: robotoMedium,
                    )),
                OutlinedButton(
                    onPressed:
                        cubitdesbleButton.desbleButto ? onPressed : onPressed,
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
    );
  }
}
