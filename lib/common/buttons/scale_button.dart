import 'package:flutter/widgets.dart';

class ScaleButton extends StatefulWidget {
  const ScaleButton(
      {super.key, required this.onTap, required this.child, this.scale});

  @override
  State<ScaleButton> createState() => _ScaleButtonState();
  final VoidCallback? onTap;
  final Widget child;

  final double? scale;
}

class _ScaleButtonState extends State<ScaleButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isPressed ? (widget.scale ?? .95) : 1,
      curve: Curves.elasticInOut,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTap: () {
          if (widget.onTap != null) {
            setState(() {
              isPressed = true;
            });
            Future.delayed(const Duration(milliseconds: 75)).then((value) {
              setState(() {
                isPressed = false;
              });
              widget.onTap!();
            });
          }
        },
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (widget.onTap != null) {
            setState(() {
              isPressed = true;
            });
          }
        },
        onTapUp: (_) {
          if (widget.onTap != null) {
            setState(() {
              isPressed = false;
            });
          }
        },
        onTapCancel: () {
          if (widget.onTap != null) {
            setState(() {
              isPressed = false;
            });
          }
        },
        child: widget.child,
      ),
    );
  }
}
