library spellingbee.web.definition_button;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'speaker.dart';
import 'app_controller.dart';

/**
 * A button to speak a definition
 */
@CustomTag('definition-button')
class DefinitionButton extends PolymerElement {
  @published String appId;
  @observable AppController app;
  
  Speaker _speaker;
  
  DefinitionButton.created() : super.created() {
    _speaker = new Speaker();
    window.console.log("Created DefinitionButton");
  }

  void speak() {
    String definition = app.currentWord().definition;
    
    onError(event) {
      window.console.error('Error speaking "$definition"');
      app.speakingStopped();
    };
    
    onEnded(event) {
      window.console.log('Done speaking "$definition"');
      app.speakingStopped();
    }

    app.speakingStarted();
    _speaker.speakViaTranslate(definition, onError, onEnded);
  }
  
  void appIdChanged() {
    app = document.querySelector('#$appId');
  }
}

