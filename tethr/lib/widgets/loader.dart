import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final bool loading; final Widget child;
  const Loader({super.key, required this.loading, required this.child});

  @override
  Widget build(BuildContext context) {
    return loading ? Center(child: CircularProgressIndicator()) : child;
  }
}

class LoaderButton extends StatelessWidget {
  final String text; final bool loading;
  final void Function() onPressed;
  const LoaderButton({super.key, required this.text, required this.loading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: !loading ? Text(text) : CircularProgressIndicator(
        constraints: BoxConstraints(
          minWidth: 25, minHeight: 25,
          maxWidth: 25, maxHeight: 25
        ),
      )
    );
  }
}
