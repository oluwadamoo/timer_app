import 'package:flutter/material.dart';

typedef CallbackSetting = void Function(String, int);

class SettingButton extends StatelessWidget {
  Color color;
  String text;
  int value;
  String setting;
  CallbackSetting callback;

  SettingButton(
      {required this.color,
      required this.text,
      required this.value,
      required this.callback,
      required this.setting});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(this.text, style: TextStyle(color: Colors.white)),
      onPressed: () => this.callback(this.setting, this.value),
      color: this.color,
    );
  }
}
