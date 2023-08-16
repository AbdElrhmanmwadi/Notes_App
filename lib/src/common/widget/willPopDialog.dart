import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/src/features/Note/presentation/cubit/isupdate_cubit.dart';

class WillPopDialog extends StatelessWidget {
  const WillPopDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IsupdateCubit cubitisUpdate = BlocProvider.of<IsupdateCubit>(context);

    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      backgroundColor: Colors.white38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Center(
          child: Icon(
        Icons.error,
        color: Colors.white,
      )),
      content: const Text(
        "Are your sure you want discard your changes ?",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
      ),
      actions: [
        MaterialButton(
          color: Colors.white54,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Keep"),
        ),
        MaterialButton(
          textColor: Colors.white,
          color: Colors.white38,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onPressed: () {
            cubitisUpdate.canPop(true);

            Navigator.of(context).pushNamed('HomeScreen');
          },
          child: Text("Discard"),
        ),
      ],
    );
  }
}
