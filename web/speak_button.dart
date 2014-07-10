library spellingbee.web.speak_button;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'speaker.dart';
import 'app_controller.dart';

/**
 * A button to speak a word
 */
@CustomTag('speak-button')
class SpeakButton extends PolymerElement {
  @published String appId;
  AppController _app;
  Speaker _speaker;
    
  SpeakButton.created() : super.created() {
    _speaker = new Speaker();
    window.console.log("Created SpeakButton");
  }

  void speak() {
    String word = _app.currentWord().word;
    onError(event) {
      window.console.error('Error speaking "$word"');
      _app.speakingStopped();
    };
    
    onEnded(event) {
      window.console.log('Done speaking "$word"');
      _app.speakingStopped();
    }

    _app.speakingStarted();
    _speaker.speak(word, onError, onEnded);
  }
  
  void appIdChanged() {
    _app = document.querySelector('#$appId');
  }
}

