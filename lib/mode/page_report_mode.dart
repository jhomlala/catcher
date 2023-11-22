import 'package:catcher_2/catcher_2.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/utils/catcher_2_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageReportMode extends ReportMode {
  PageReportMode({
    this.showStackTrace = true,
  });

  final bool showStackTrace;

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
    if (!context.mounted) {
      return;
    }
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => PageWidget(this, report),
      ),
    );
  }

  @override
  bool isContextRequired() => true;

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
  const PageWidget(
    this.pageReportMode,
    this.report, {
    super.key,
  });

  final PageReportMode pageReportMode;
  final Report report;

  @override
  PageWidgetState createState() => PageWidgetState();
}

class PageWidgetState extends State<PageWidget> {
  @override
  // ignore: deprecated_member_use
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          widget.pageReportMode.onActionRejected(widget.report);
          return true;
        },
        child: Builder(
          builder: (context) => Catcher2Utils.isCupertinoAppAncestor(context)
              ? _buildCupertinoPage()
              : _buildMaterialPage(),
        ),
      );

  Widget _buildMaterialPage() => Scaffold(
        appBar: AppBar(
          title: Text(
            widget.pageReportMode.localizationOptions.pageReportModeTitle,
          ),
        ),
        body: _buildInnerWidget(),
      );

  Widget _buildCupertinoPage() => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            widget.pageReportMode.localizationOptions.pageReportModeTitle,
          ),
        ),
        child: SafeArea(
          child: _buildInnerWidget(),
        ),
      );

  Widget _buildInnerWidget() => Container(
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
                widget.pageReportMode.localizationOptions
                    .pageReportModeDescription,
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
                    widget.pageReportMode.localizationOptions
                        .pageReportModeAccept,
                  ),
                ),
                TextButton(
                  onPressed: _onCancelClicked,
                  child: Text(
                    widget.pageReportMode.localizationOptions
                        .pageReportModeCancel,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  TextStyle _getTextStyle(double fontSize) => TextStyle(
        fontSize: fontSize,
        decoration: TextDecoration.none,
      );

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
          itemBuilder: (context, index) => Text(
            items[index],
            style: _getTextStyle(10),
          ),
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
