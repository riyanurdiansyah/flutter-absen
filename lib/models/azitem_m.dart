import 'package:azlistview/azlistview.dart';

class AZItemM extends ISuspensionBean {
  AZItemM({
    required this.title,
    required this.tag,
  });

  final String title;
  final String tag;

  @override
  String getSuspensionTag() => tag;
}
