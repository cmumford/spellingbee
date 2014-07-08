import 'package:polymer/polymer.dart';
import 'dart:html';

/**
 * A button to speak a word
 */
@CustomTag('definition-button')
class DefinitionButton extends PolymerElement {
  @published String definition = "The definition";
  
  static const int maxSpeakPhraseLen = 100; // All Google xlate can do in a single GET

  DefinitionButton.created() : super.created() {
    window.console.log("Created DefinitionButton");
  }

  void speak() {
    window.console.log("Speaking: " + word);
  }
}

