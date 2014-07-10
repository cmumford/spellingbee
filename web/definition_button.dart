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
  
  Speaker speaker;
  
  DefinitionButton.created() : super.created() {
    speaker = new Speaker();
    window.console.log("Created DefinitionButton");
  }

  void speak() {
    String definition = app.current_word().definition;
    
    onError(event) {
      window.console.error('Error speaking "$definition"');
      app.speaking_stopped();
    };
    
    onEnded(event) {
      window.console.log('Done speaking "$definition"');
      app.speaking_stopped();
    }

    app.speaking_started();
    speaker.speak_via_translate(definition, onError, onEnded);
  }
  
  void appIdChanged() {
    app = document.querySelector('#$appId');
  }
}

