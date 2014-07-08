import 'package:polymer/polymer.dart';
import 'dart:html';
import 'speaker.dart';

/**
 * A button to speak a word
 */
@CustomTag('speak-button')
class SpeakButton extends PolymerElement {
  @published String word = "Hello";
  Speaker speaker;
  
  static const int maxSpeakPhraseLen = 100; // All Google xlate can do in a single GET

  SpeakButton.created() : super.created() {
    speaker = new Speaker();
    window.console.log("Created SpeakButton");
  }

  void has_spoken() {
    
  }
  
  void speak() {
    window.console.log("Speaking: " + word);
    onError(event) {
      window.console.error("Error playing sound: " + word);
    };
    
    onEnded(event) {
      window.console.log("Done speaking '" + word + '"');
      has_spoken();
    }

    speaker.speak(word, onError, onEnded);
  }
}

