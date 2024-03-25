import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/material.dart';

void main() {
  final debugOptions = Catcher2Options(SilentReportMode(), [
    ConsoleHandler(),
  ]);
  final releaseOptions = Catcher2Options(PageReportMode(), [
    EmailManualHandler(['recipient@email.com']),
  ]);

  Catcher2(
    rootWidget: const MyApp(),
    debugConfig: debugOptions,
    releaseConfig: releaseOptions,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: Catcher2.navigatorKey,
        builder: (context, widget) {
          Catcher2.addDefaultErrorWidget(
            showStacktrace: true,
            title: 'Custom title',
            description: 'Custom description',
            maxWidthForSmallMode: 150,
          );
          return widget!;
        },
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: _buildSmallErrorWidget(),
        ),
      );

  ///Trigger "normal" mode
  /*Widget _buildNormalErrorWidget() {
    return ChildWidget();
  }*/

  ///Trigger "small" mode
  Widget _buildSmallErrorWidget() => GridView.count(
        crossAxisCount: 3,
        children: const [
          ChildWidget(),
          ChildWidget(),
          ChildWidget(),
        ],
      );
}

class ChildWidget extends StatelessWidget {
  const ChildWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      TextButton(onPressed: generateError, child: const Text('Test'));

  Future<void> generateError() async {
    Catcher2.sendTestException();
  }
}
