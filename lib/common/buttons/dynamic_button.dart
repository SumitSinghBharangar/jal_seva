import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jal_seva/common/buttons/scale_button.dart';


class DynamicButton extends StatefulWidget {
  const DynamicButton(
      {super.key,
      required this.child,
      this.onPressed,
      this.isLoading,
      this.style,
      this.color,
      this.foregroundColor});

  @override
  State<DynamicButton> createState() => _DynamicButtonState();

  final Widget child;
  final FutureOr<void> Function()? onPressed;
  final bool? isLoading;
  final ButtonStyle? style;
  final Color? color;
  final Color? foregroundColor;

  static DynamicButton fromText({
    required String text,
    required FutureOr<void> Function()? onPressed,
    bool? isLoading,
    Color? color,
    Color? foregroundColor,
    Color? textColor,
  }) {
    return DynamicButton(
      isLoading: isLoading,
      onPressed: onPressed,
      foregroundColor: foregroundColor,
      color: color,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor ?? Colors.white,
        ),
      ),
    );
  }
}

class _DynamicButtonState extends State<DynamicButton> {
  bool _isLoading = false;

  func() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      if (widget.onPressed != null) {
        _isLoading = true;
        setState(() {});

        await widget.onPressed!();

        _isLoading = false;
        setState(() {});
      }
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !(widget.isLoading ?? _isLoading),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: ScaleButton(
          scale: .98,
          onTap: (widget.onPressed == null || (widget.isLoading ?? false))
              ? null
              : _isLoading
                  ? null
                  : () {
                      func();
                    },
          // child: FilledButton(
          // style: widget.style ??
          //     FilledButton.styleFrom(
          //       // backgroundColor: AppColors.buttonColor,
          //       backgroundColor: widget.color ?? Colors.black,
          //       foregroundColor: widget.foregroundColor ?? Colors.white,
          //       padding: const EdgeInsets.symmetric(vertical: 20),
          //     ),
          // onPressed: (widget.onPressed == null || (widget.isLoading ?? false))
          //     ? null
          //     : _isLoading
          //         ? null
          //         : () {
          //             // func();
          //           },
          // child: widget.child,
          // ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color:
                  ((widget.onPressed == null || (widget.isLoading ?? false)) ||
                          _isLoading)
                      ? Colors.grey.withOpacity(.5)
                      : const Color(0xFF028353),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  ((widget.onPressed == null || (widget.isLoading ?? false)) ||
                          _isLoading)
                      ? Colors.black
                      : Colors.white,
                  BlendMode.srcIn,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
