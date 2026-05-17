import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tethr/widgets/loader.dart';

import './logic.dart' as logic;
import 'package:tethr/screens/normal/index.dart' as dashboard;

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {

  final _key = GlobalKey<FormBuilderState>();

  bool loading = false;
  bool otp = false;

  void request(
    BuildContext ctx,
    {
      required Future<bool> Function(BuildContext, Map<String, dynamic>) fn,
      required Function() onSuccess
    }
  ) async {
    if (!_key.currentState!.saveAndValidate()) return;
    setState(() { loading = true; });

    final success = await fn(ctx, _key.currentState!.value);
    setState(() { loading = false; });
    if (success) onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _key,
      child: Column(
        mainAxisSize: .min, crossAxisAlignment: .stretch,
        spacing: 10,
        children: [
          FormBuilderTextField(
            name: "name",
            decoration: InputDecoration(label: Text("Name")),
            enabled: !otp,
          ),

          FormBuilderTextField(
            name: "phone",
            decoration: InputDecoration(label: Text("Phone Number")),
            keyboardType: .phone, enabled: !otp,
          ),

          if (otp)
            FormBuilderTextField(
              name: "otp",
              decoration: InputDecoration(label: Text("OTP")),
              keyboardType: .number,
            ),

          LoaderButton(
            text: !otp ? "Signup" : "Verify",
            loading: loading,
            onPressed: (!otp ?
              () => request(
                context, fn: logic.signup,
                onSuccess: () => setState(() { otp = true; })
              ) :
              () => request(
                context, fn: logic.verifyOTP,
                onSuccess: () => Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (ctx) => dashboard.Screen()
                ))
              )
            )
          )
        ],
      ),
    );
  }
}
