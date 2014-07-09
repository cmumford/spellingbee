library spellingbee.web.answer_element;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'appcontroller.dart';

/**
 * UI to handle the user's answer
 */
@CustomTag('answer-element')
class AnswerElement extends PolymerElement {
  @published String appId;
  @observable AppController app;
  InputElement guess;
    
  AnswerElement.created() : super.created() {
  }

  void check() {
    if (guess != null) {
      window.console.log("Checking: " + guess.value);
    }
    else {
      window.console.error("Can't find guess");
    }
  }
  
  void appIdChanged() {
    app = document.querySelector('#$appId');
  }
}
