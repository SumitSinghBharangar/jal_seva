import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


showLoading(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: CupertinoActivityIndicator(
                color: Colors.black,
                radius: 23,
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<DateTime?> showAppTimePicker(BuildContext context) async {
  DateTime? dateTime;
  bool hasError = false;

  DateTime n = DateTime.now();

  if (n.hour >= 6 && n.hour < 19) {
    dateTime = n;
    hasError = false;
  } else {
    dateTime = null;
    hasError = true;
  }

  await showCupertinoModalPopup(
    context: context,
    builder: (context) => StatefulBuilder(
        builder: (context, void Function(void Function()) setState) {
      return Container(
        height: 350.h,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
          ),
        ),
        child: Material(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  onDateTimeChanged: (value) {
                    setState(() {
                      if (value.hour >= 6 && value.hour < 19) {
                        dateTime = value;
                        hasError = false;
                      } else {
                        dateTime = null;
                        hasError = true;
                      }
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ShakeAnimation(
                  isAnimating: hasError,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: hasError ? Colors.red : Colors.black,
                      fontWeight: hasError ? FontWeight.bold : null,
                      fontSize: 12,
                    ),
                    child: const Text(
                      "* You can only select time between 6:00 to 19:00",
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: TextButton(
                    onPressed: dateTime == null
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    child: const Text("Done"),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.paddingOf(context).bottom + 20),
            ],
          ),
        ),
      );
    }),
  );
  return dateTime;
}
