import 'package:flutter/material.dart';

class CatcherErrorWidget extends StatelessWidget {
  final FlutterErrorDetails details;
  final bool showStacktrace;
  final String customTitle;
  final String customDescription;

  const CatcherErrorWidget({Key key, this.details, this.showStacktrace, this.customTitle, this.customDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = "An application error has occurred";
    if (customTitle != null){
      title = customTitle;
    }


    var description =
        "There was unexepcted situation in application. Application has been able to recover from error state.";
    if (showStacktrace) {
      description += " See details below.";
    }

    if (customDescription != null){
      description = customDescription;
    }


    return Container(
        margin: EdgeInsets.all(20),
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.announcement,
            color: Colors.red,
            size: 40,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 25),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          _getStackTraceWidget()
        ])));
  }

  Widget _getStackTraceWidget() {
    if (showStacktrace) {
      return SizedBox(
        height: 200.0,
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Text(details.exceptionAsString());
          },
        ),
      );
    } else {
      return Container();
    }
  }
}
