import 'package:catcher/catcher_plugin.dart';
import 'package:catcher/model/report_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PageReportMode extends ReportMode {
  final bool showStackTrace;

  PageReportMode({
    this.showStackTrace = true,
  });

  @override
  void requestAction(Report report, BuildContext context) {
    _navigateToPageWidget(report, context);
  }

  _navigateToPageWidget(Report report, BuildContext context) async {
    await Future.delayed(Duration.zero);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageWidget(this, report)),
    );
  }

}

class PageWidget extends StatefulWidget {
  final PageReportMode pageReportMode;
  final Report report;

  PageWidget(this.pageReportMode, this.report);

  @override
  PageWidgetState createState() {
    return new PageWidgetState();
  }
}

class PageWidgetState extends State<PageWidget> {
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.pageReportMode.localizationOptions.pageReportModeTitle),
        ),
        body: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  widget.pageReportMode.localizationOptions
                      .pageReportModeDescription,
                  style: _getTextStyle(15),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                _getStackTraceWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text(widget.pageReportMode.localizationOptions
                          .pageReportModeAccept),
                      onPressed: () => _acceptReport(),
                    ),
                    FlatButton(
                      child: Text(widget.pageReportMode.localizationOptions
                          .pageReportModeCancel),
                      onPressed: () => _cancelReport(),
                    ),
                  ],
                )
              ],
            )));
  }

  TextStyle _getTextStyle(double fontSize) {
    return TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        decoration: TextDecoration.none);
  }

  Widget _getStackTraceWidget() {
    if (widget.pageReportMode.showStackTrace) {
      var items = widget.report.stackTrace.toString().split("\n");
      return SizedBox(
        height: 300.0,
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Text(
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

  _acceptReport() {
    widget.pageReportMode.onActionConfirmed(widget.report);
    _closePage();
  }

  _cancelReport() {
    widget.pageReportMode.onActionRejected(widget.report);
    _closePage();
  }

  _closePage() {
    Navigator.of(_context).pop();
  }
}
