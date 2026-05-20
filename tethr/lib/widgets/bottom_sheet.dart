import 'package:flutter/material.dart';

class BottomSheetModal extends StatelessWidget {
  final Widget child;
  const BottomSheetModal(this.child, {super.key});

  @override
  Widget build(BuildContext context) {

    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(child: Container(
      width: .infinity,
      padding: .fromLTRB(20, 10, 20, bottom + 10),
      child: child,
    ));
  }
}

