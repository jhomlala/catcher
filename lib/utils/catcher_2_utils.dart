import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:dio/dio.dart';

class Catcher2Utils {
  static bool isCupertinoAppAncestor(BuildContext context) =>
      context.findAncestorWidgetOfExactType<CupertinoApp>() != null;
}

/// From https://stackoverflow.com/a/70282800/5894824
extension IsOk on Response {
  bool get ok => statusCode != null && (statusCode! ~/ 100) == 2;
}
