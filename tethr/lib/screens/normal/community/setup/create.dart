import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:tethr/lib/location.dart';
import 'package:tethr/widgets/fragment.dart';
import 'package:tethr/widgets/loader.dart';
import 'package:tethr/widgets/map.dart';

import './logic.dart' as logic;
import 'package:tethr/screens/normal/dashboard/index.dart' as dashboard;

class CreateCommunity extends StatelessWidget {
  const CreateCommunity({super.key});

  @override
  Widget build(BuildContext context) {
    return Fragment(
      title: "Create Community",
      body: SafeArea(child: Column(
        spacing: 20,
        children: [
          Flexible(flex: 3, child: TethrMap(interactive: false)),
          Flexible(flex: 7, child: SingleChildScrollView(
            child: Padding(
              padding: .symmetric(horizontal: 15, vertical: 20),
              child: CreateForm(),
            ),
          ))
        ],
      )),
    );
  }
}


class CreateForm extends StatefulWidget {
  const CreateForm({super.key});

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {

  final _key = GlobalKey<FormBuilderState>();
  bool loading = false;

  void createComm() async {
    if (!_key.currentState!.saveAndValidate()) return;
    setState(() { loading = true; });

    final pos = await Location.getCurrent();

    if (!await logic.createCommunity(
        context, {
          ..._key.currentState!.value,
          "lat": pos.latitude, "lng": pos.longitude
        }
    )) setState(() { loading = false; });
    else
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => dashboard.Screen()),
        (route) => false
      );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _key,
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min, spacing: 10,
        children: [
          FormBuilderTextField(
            name: "name",
            decoration: InputDecoration(label: Text("Community Name"))
          ),

          FormBuilderTextField(
            name: "description",
            decoration: InputDecoration(label: Text("Brief Description")),
            minLines: 5, maxLines: 5, maxLength: 255,
          ),

          LoaderButton(text: "Create", loading: loading, onPressed: createComm)
        ],
      ),
    );
  }
}
