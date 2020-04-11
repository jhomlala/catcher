import 'package:flutter/material.dart';

class CatcherErrorWidget extends StatelessWidget {
  final FlutterErrorDetails details;
  final bool showStacktrace;
  final String title;
  final String description;
  final double maxWidthForSmallMode;

  const CatcherErrorWidget({
    Key key,
    this.details,
    this.showStacktrace,
    this.title,
    this.description,
    this.maxWidthForSmallMode,
  })  : assert(showStacktrace != null),
        assert(title != null),
        assert(description != null),
        assert(maxWidthForSmallMode != null && maxWidthForSmallMode > 0),
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
    return Center(
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
        child: ListView(children: [
          _buildIcon(),
          Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 25),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            _getDescription(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          _buildStackTraceWidget()
        ]),
      ),
    );
  }

  Widget _buildIcon() {
    return Icon(
      Icons.announcement,
      color: Colors.red,
      size: 40,
    );
  }

  Widget _buildStackTraceWidget() {
    if (showStacktrace) {
      List<String> stackTrace = details.stack.toString().split("\n");
      return ListView.builder(
        padding: EdgeInsets.all(8.0),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: stackTrace.length,
        itemBuilder: (BuildContext context, int index) {
          String line = stackTrace[index];
          if (line?.isNotEmpty == true) {
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
