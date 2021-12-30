import 'package:flutter/material.dart';
import 'package:timer_app/ProductivityButton.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:percent_indicator/percent_indicator.dart';
import 'package:timer_app/timermodel.dart';
import './timer.dart';
import 'settings.dart';

void main() => runApp(const MyApp());
const double defaultPadding = 5.0;

final CountDownTimer timer = CountDownTimer();
void goToSettings(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => SettingsScreen()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    timer.startWork();

    return MaterialApp(
        title: 'My Work Timer',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const TimerHomePage());
  }
}

class TimerHomePage extends StatelessWidget {
  const TimerHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    final List<PopupMenuItem<String>> menuItems = <PopupMenuItem<String>>[];

    menuItems
        .add(const PopupMenuItem(value: 'Settings', child: Text("Settings")));
    return Scaffold(
        appBar: AppBar(
          title: const Text('My work timer'),
          actions: [
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return menuItems.toList();
              },
              onSelected: (s) {
                if (s == 'Settings') {
                  goToSettings(context);
                }
              },
            )
          ],
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          return Column(children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
                Expanded(
                    child: ProductivityButton(
                        color: const Color(0xff009688),
                        text: "Work",
                        size: 10,
                        onPressed: () => timer.startWork())),
                const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
                Expanded(
                    child: ProductivityButton(
                        color: const Color(0xff607D8B),
                        text: "Short Break",
                        size: 10,
                        onPressed: () => timer.startBreak(true))),
                const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
                Expanded(
                    child: ProductivityButton(
                        color: const Color(0xff455A64),
                        text: "Long Break",
                        size: 10,
                        onPressed: () => timer.startBreak(false))),
                const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
              ],
            ),
            Expanded(
                child: StreamBuilder(
                    initialData: '00:00',
                    stream: timer.stream(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      TimerModel timer = (snapshot.data == '00:00')
                          ? TimerModel('00:00', 1)
                          : snapshot.data;
                      return Expanded(
                          child: CircularPercentIndicator(
                        radius: availableWidth / 2,
                        lineWidth: 10.0,
                        percent: timer.percent,
                        center: Text(
                          timer.time,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        progressColor: const Color(0xff009688),
                      ));
                    })),
            Row(
              children: [
                const Padding(padding: EdgeInsets.all(defaultPadding)),
                Expanded(
                    child: ProductivityButton(
                        color: Color(0xff212121),
                        text: 'Stop',
                        size: 10,
                        onPressed: () => timer.stopTimer())),
                const Padding(padding: EdgeInsets.all(defaultPadding)),
                Expanded(
                    child: ProductivityButton(
                        color: Color(0xff009688),
                        text: 'Restart',
                        size: 10,
                        onPressed: () => timer.startTimer()))
              ],
            )
          ]);
        }));
  }
}
