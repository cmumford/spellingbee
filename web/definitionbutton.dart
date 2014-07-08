import 'package:polymer/polymer.dart';
import 'dart:html';
import 'speaker.dart';

/**
 * A button to speak a definition
 */
@CustomTag('definition-button')
class DefinitionButton extends PolymerElement {
  @published String definition = "The definition";
  
  Speaker speaker;
  
  static const int maxSpeakPhraseLen = 100; // All Google xlate can do in a single GET

  DefinitionButton.created() : super.created() {
    speaker = new Speaker();
    window.console.log("Created DefinitionButton");
  }

  void speak() {
    window.console.log("Speaking: " + definition);
    onError(event) {
      window.console.error("Error playing sound: " + definition);
    };
    
    onEnded(event) {
      window.console.log("Done speaking '" + definition + '"');
    }

    speaker.speak(definition, onError, onEnded);
  }
}

