import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'titledescdb.g.dart';

@HiveType(typeId: 1)
class FlashcardSet {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String id; // Unique identifier for each flashcard set

  FlashcardSet({
    String? id,
    required this.title,
    required this.description,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}
