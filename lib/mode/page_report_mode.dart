import 'package:catcher/catcher.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:catcher/utils/catcher_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageReportMode extends ReportMode {
  final bool showStackTrace;

  PageReportMode({
    this.showStackTrace = true,
  });

  @override
  void requestAction(Report report, BuildContext? context) {
    if (context != null) {
      _navigateToPageWidget(report, context);
    }
  }

  Future<void> _navigateToPageWidget(
    Report report,
    BuildContext context,
  ) async {
    await Future<void>.delayed(Duration.zero);
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => PageWidget(this, report),
      ),
    );
  }

  @override
  bool isContextRequired() {
    return true;
  }

  @override
  List<PlatformType> getSupportedPlatforms() => [
        PlatformType.android,
        PlatformType.iOS,
        PlatformType.web,
        PlatformType.linux,
        PlatformType.macOS,
        PlatformType.windows,
      ];
}

class PageWidget extends StatefulWidget {
  final PageReportMode pageReportMode;
  final Report report;

  const PageWidget(
    this.pageReportMode,
    this.report, {
    super.key,
  });

  @override
  PageWidgetState createState() {
    return PageWidgetState();
  }
}

class PageWidgetState extends State<PageWidget> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.pageReportMode.onActionRejected(widget.report);
        return true;
      },
      child: Builder(
        builder: (context) => CatcherUtils.isCupertinoAppAncestor(context)
            ? _buildCupertinoPage()
            : _buildMaterialPage(),
      ),
    );
  }

  Widget _buildMaterialPage() {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.pageReportMode.localizationOptions.pageReportModeTitle),
      ),
      body: _buildInnerWidget(),
    );
  }

  Widget _buildCupertinoPage() {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle:
            Text(widget.pageReportMode.localizationOptions.pageReportModeTitle),
      ),
      child: SafeArea(
        child: _buildInnerWidget(),
      ),
    );
  }

  Widget _buildInnerWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget
                  .pageReportMode.localizationOptions.pageReportModeDescription,
              style: _getTextStyle(15),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _getStackTraceWidget(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: _onAcceptClicked,
                child: Text(
                  widget
                      .pageReportMode.localizationOptions.pageReportModeAccept,
                ),
              ),
              TextButton(
                onPressed: _onCancelClicked,
                child: Text(
                  widget
                      .pageReportMode.localizationOptions.pageReportModeCancel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _getTextStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize,
      decoration: TextDecoration.none,
    );
  }

  Widget _getStackTraceWidget() {
    if (widget.pageReportMode.showStackTrace) {
      var error = '';
      if (widget.report.error != null) {
        error = widget.report.error.toString();
      } else if (widget.report.errorDetails != null) {
        error = widget.report.errorDetails.toString();
      }

      final items = <String>[
        error,
        ...widget.report.stackTrace.toString().split('\n'),
      ];
      return SizedBox(
        height: 300,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Text(
              // ignore: unnecessary_string_interpolations
              '${items[index]}',
              style: _getTextStyle(10),
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }

  void _onAcceptClicked() {
    widget.pageReportMode.onActionConfirmed(widget.report);
    _closePage();
  }

  void _onCancelClicked() {
    widget.pageReportMode.onActionRejected(widget.report);
    _closePage();
  }

  void _closePage() {
    Navigator.of(context).pop();
  }
}
