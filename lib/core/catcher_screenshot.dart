import 'package:flutter/material.dart';

import 'athmany_catcher.dart';

///Screenshot widget used to create screenshot of all child widgets.
class CatcherScreenshot extends StatefulWidget {
  final Widget child;
  final AthmanyCatcher catcher;

  const CatcherScreenshot({
    Key? key,
    required this.child,
    required this.catcher,
  }) : super(key: key);

  @override
  State<CatcherScreenshot> createState() {
    return CatcherScreenshotState();
  }
}

///State of screenshot widget.
class CatcherScreenshotState extends State<CatcherScreenshot> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.catcher.screenshotManager.containerKey,
      child: widget.child,
    );
  }
}
