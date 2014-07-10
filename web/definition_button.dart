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
  AppController _app;
  
  Speaker _speaker;
  
  DefinitionButton.created() : super.created() {
    _speaker = new Speaker();
    window.console.log("Created DefinitionButton");
  }

  void speak() {
    String definition = _app.currentWord().definition;
    
    onError(event) {
      window.console.error('Error speaking "$definition"');
      _app.speakingStopped();
    };
    
    onEnded(event) {
      window.console.log('Done speaking "$definition"');
      _app.speakingStopped();
    }

    _app.speakingStarted();
    _speaker.speakViaTranslate(definition, onError, onEnded);
  }
  
  void appIdChanged() {
    _app = document.querySelector('#$appId');
  }
}

