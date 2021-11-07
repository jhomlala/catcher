import 'package:flutter/material.dart';

class CatcherErrorWidget extends StatelessWidget {
  final FlutterErrorDetails? details;
  final bool showStacktrace;
  final String title;
  final String description;
  final double maxWidthForSmallMode;

  const CatcherErrorWidget({
    Key? key,
    this.details,
    required this.showStacktrace,
    required this.title,
    required this.description,
    required this.maxWidthForSmallMode,
  })  : assert(maxWidthForSmallMode > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        if (constraint.maxWidth < maxWidthForSmallMode) {
          return _buildSmallErrorWidget();
        } else {
          return _buildNormalErrorWidget();
        }
      },
    );
  }

  Widget _buildSmallErrorWidget() {
    return const Center(
      child: Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 40,
      ),
    );
  }

  Widget _buildNormalErrorWidget() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Center(
        child: ListView(
          children: [
            _buildIcon(),
            Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 25),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              _getDescription(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _buildStackTraceWidget()
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return const Icon(
      Icons.announcement,
      color: Colors.red,
      size: 40,
    );
  }

  Widget _buildStackTraceWidget() {
    if (showStacktrace) {
      final List<String> items = [];
      if (details != null) {
        items.add(details!.exception.toString());
        items.addAll(details!.stack.toString().split("\n"));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final String line = items[index];
          if (line.isNotEmpty == true) {
            return Text(line);
          } else {
            return const SizedBox();
          }
        },
      );
    } else {
      return const SizedBox();
    }
  }

  String _getDescription() {
    String descriptionText = description;
    if (showStacktrace) {
      descriptionText += " See details below.";
    }
    return descriptionText;
  }
}
