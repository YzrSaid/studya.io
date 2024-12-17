import 'package:audioplayers/audioplayers.dart';

class AlarmAudioPlayer {
  final _audioplayer = AudioPlayer();
  final _audioplayerEffect = AudioPlayer();

  // Play alarm sound with the given sound name and volume
  void playAlarmSound(String soundName, double volume) {
    // Get the sound path based on the sound name
    String? soundPath;

    switch (soundName) {
      case 'Sound 1':
        soundPath = 'alarm_sounds/default_alarm_sound.mp3';
        break;
      case 'Sound 2':
        soundPath = 'alarm_sounds/digital_beep_alarm_sound.mp3';
        break;
      case 'Sound 3':
        soundPath = 'alarm_sounds/bliss_alarm_sound.mp3';
        break;
      case 'Sound 4':
        soundPath = 'alarm_sounds/classic_alarm_sound.mp3';
        break;
      default:
        return;
    }

    _audioplayer.setVolume(volume); // Set the volume before playing
    // Play the sound in loop
    _audioplayer.setReleaseMode(ReleaseMode.loop);
    _audioplayer.play(AssetSource(soundPath));
  }

  void playSoundEffect(String soundName, double volume) {
    // Get the sound path based on the sound name
    String? soundPath;

    switch (soundName) {
      case 'Flashcard':
        soundPath = 'alarm_sounds/flipcard.mp3';
        break;
      default:
        return;
    }

    _audioplayerEffect.setVolume(volume); // Set the volume before playing
    _audioplayerEffect.play(AssetSource(soundPath));
  }


  // Stop the alarm sound
  void stopAlarmSound() {
    _audioplayer.stop();
  }
}
