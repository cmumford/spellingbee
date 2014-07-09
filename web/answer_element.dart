library spellingbee.web.answer_element;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'app_controller.dart';
import 'package:paper_elements/paper_input.dart';

/**
 * UI to handle the user's answer
 */
@CustomTag('answer-element')
class AnswerElement extends PolymerElement {
  @published String appId;
  @observable AppController app;
    
  AnswerElement.created() : super.created() {
  }

  void appIdChanged() {
    app = document.querySelector('#$appId');
  }
  
  // Reset this element back to empty
  void reset() {
    clearAnswer() {
      window.console.log("Need to clear the answer");
    }
    // Use a timer bacause if we set the InputElement during a change event
    // then it will be ignored.
    Timer.run(clearAnswer);
  }
  
  void gotInput(Event event) {
    PaperInput input = event.target;
    window.console.log("Got input: ${input.inputValue}");
    app.checkPartialAnswer(input.inputValue);
  }
  
  // Hit the enter key
  void gotChange(Event event) {
    PaperInput input = event.target;
    window.console.log("Got change: ${input.inputValue}");
    app.checkFullAnswer(input.inputValue);
  }
}
