import 'package:polymer/polymer.dart';
import 'dart:html';

/**
 * A button to speak a word
 */
@CustomTag('speak-button')
class SpeakButton extends PolymerElement {
  @published String word = "Hello";

  SpeakButton.created() : super.created() {
    window.console.log("Created SpeakButton");
  }

  void speak() {
    window.console.log("Speaking: " + word);
  }
}

