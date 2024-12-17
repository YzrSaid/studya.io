import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs

part 'flashcarddb.g.dart';

@HiveType(typeId: 2)
class Flashcard {
  @HiveField(0)
  final String flashcardId; // Unique ID for the flashcard

  @HiveField(1)
  final String front; // Front text of the flashcard

  @HiveField(2)
  final String back; // Back text of the flashcard

  @HiveField(3)
  final int color; // Color index or code

  @HiveField(4)
  final String flashcardSetId; // ID of the flashcard set

  Flashcard({
    String? flashcardId, // Optional to auto-generate
    required this.front,
    required this.back,
    required this.color,
    required this.flashcardSetId,
  }) : flashcardId = flashcardId ?? const Uuid().v4();
}
