import 'package:material_ui/material_ui.dart';

class Catcher2ErrorWidget extends StatelessWidget {
  const Catcher2ErrorWidget({
    super.key,
    this.details,
    required this.showStacktrace,
    required this.title,
    required this.description,
    required this.maxWidthForSmallMode,
  }) : assert(
         maxWidthForSmallMode > 0,
         'maxWidthForSmallMode must be positive',
       );
  final FlutterErrorDetails? details;
  final bool showStacktrace;
  final String title;
  final String description;
  final double maxWidthForSmallMode;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraint) => constraint.maxWidth < maxWidthForSmallMode
        ? _buildSmallErrorWidget(context)
        : _buildNormalErrorWidget(context),
  );

  Widget _buildSmallErrorWidget(BuildContext context) => Center(
    child: Icon(
      Icons.error_outline,
      color: Theme.of(context).colorScheme.error,
      size: 40,
    ),
  );

  Widget _buildNormalErrorWidget(BuildContext context) => Container(
    margin: const EdgeInsets.all(20),
    child: Center(
      child: ListView(
        children: [
          _buildIcon(context),
          Text(
            title,
            style:
                Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontSize: 25) ??
                const TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(_getDescription(), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          _buildStackTraceWidget(),
        ],
      ),
    ),
  );

  Widget _buildIcon(BuildContext context) => Icon(
    Icons.announcement,
    color: Theme.of(context).colorScheme.error,
    size: 40,
  );

  Widget _buildStackTraceWidget() {
    if (showStacktrace) {
      final items = <String>[];
      if (details != null) {
        items
          ..add(details!.exception.toString())
          ..addAll(details!.stack.toString().split('\n'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final line = items[index];
          return line.isNotEmpty ? Text(line) : const SizedBox();
        },
      );
    } else {
      return const SizedBox();
    }
  }

  String _getDescription() {
    var descriptionText = description;
    if (showStacktrace) {
      descriptionText += ' See details below.';
    }
    return descriptionText;
  }
}
