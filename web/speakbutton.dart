library spellingbee.web.speakbutton;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'speaker.dart';
import 'appcontroller.dart';

/**
 * A button to speak a word
 */
@CustomTag('speak-button')
class SpeakButton extends PolymerElement {
  @published String appId;
  @observable AppController app;
  Speaker speaker;
    
  static const int maxSpeakPhraseLen = 100; // All Google xlate can do in a single GET

  SpeakButton.created() : super.created() {
    speaker = new Speaker();
    window.console.log("Created SpeakButton");
  }

  void speak() {
    String word = app.current_word().word;
    window.console.log("Speaking: " + word);
    onError(event) {
      window.console.error("Error playing sound: " + word);
      app.speaking_stopped();
    };
    
    onEnded(event) {
      window.console.log("Done speaking '" + word + '"');
      app.speaking_stopped();
    }

    app.speaking_started();
    speaker.speak(word, onError, onEnded);
  }
  
  void appIdChanged() {
    app = document.querySelector('#$appId');
  }
}

