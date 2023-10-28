import 'package:catcher_2/core/catcher_2.dart';
import 'package:flutter/material.dart';

/// Screenshot widget used to create screenshot of all child widgets.
class Catcher2Screenshot extends StatefulWidget {
  const Catcher2Screenshot({
    super.key,
    required this.child,
    required this.catcher2,
  });

  final Widget child;
  final Catcher2 catcher2;

  @override
  State<Catcher2Screenshot> createState() => Catcher2ScreenshotState();
}

/// State of screenshot widget.
class Catcher2ScreenshotState extends State<Catcher2Screenshot>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => RepaintBoundary(
        key: widget.catcher2.screenshotManager.containerKey,
        child: widget.child,
      );
}
