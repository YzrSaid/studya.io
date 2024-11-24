import 'package:hive/hive.dart';
import 'package:studya_io/screens/pomodoro_timer_page/create_pomodoro_timer/hive_model.dart';

class Boxes {
  static Box<HiveModel> getStudSession () => Hive.box<HiveModel>('StudSession');

}