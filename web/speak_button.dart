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
  @observable AppController app;
  Speaker speaker;
    
  SpeakButton.created() : super.created() {
    speaker = new Speaker();
    window.console.log("Created SpeakButton");
  }

  void speak() {
    String word = app.current_word().word;
    onError(event) {
      window.console.error('Error speaking "$word"');
      app.speaking_stopped();
    };
    
    onEnded(event) {
      window.console.log('Done speaking "$word"');
      app.speaking_stopped();
    }

    app.speaking_started();
    speaker.speak(word, onError, onEnded);
  }
  
  void appIdChanged() {
    app = document.querySelector('#$appId');
  }
}

