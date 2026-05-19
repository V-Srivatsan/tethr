import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tethr/lib/profile.dart';

class Info extends StatefulWidget {
  final String name, description;
  const Info({super.key, required this.name, required this.description});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {

  bool loading = false;
  final _key = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _key,
      child: Column(
        mainAxisSize: .min, crossAxisAlignment: .stretch, spacing: 10,
        children: [

          FormBuilderTextField(
            name: "name", initialValue: widget.name, enabled: Profile.comm_admin,
            decoration: InputDecoration(labelText: "Community Name"),
          ),

          FormBuilderTextField(
            name: "description", initialValue: widget.description,
            decoration: InputDecoration(labelText: "Community Description"),
            maxLines: 5, minLines: 5, enabled: Profile.comm_admin
          ),

          if (Profile.comm_admin)
            ElevatedButton(
              onPressed: () {},
              child: Text("Update")
            )

        ],
      ),
    );
  }
}
