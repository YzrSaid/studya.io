import 'package:hive/hive.dart';
part 'hive_model.g.dart';

@HiveType(typeId: 0)
class HiveModel extends HiveObject {
  @HiveField(0)
  late String studSessionName;

  @HiveField(1)
  late String selectedStudSession;

  @HiveField(2)
  late String alarmSound;

  @HiveField(3)
  late bool isAutoStartSwitched;
}
