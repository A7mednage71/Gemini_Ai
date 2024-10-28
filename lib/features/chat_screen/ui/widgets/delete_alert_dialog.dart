import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog(
      {super.key,
      required this.title,
      required this.subtitle,
      this.onDeletePressed});
  final String title;
  final String subtitle;

  final void Function()? onDeletePressed;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      content: Text(
        subtitle,
        style: TextStyle(fontSize: 17.sp),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: onDeletePressed,
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
