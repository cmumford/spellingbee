library spellingbee.web.answer_element;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'app_controller.dart';
import 'package:paper_elements/paper_input.dart';

/**
 * UI to handle the user's answer
 */
@CustomTag('answer-element')
class AnswerElement extends PolymerElement {
  @published String appId;
  @observable AppController app;
  PaperInput answerInput;

  AnswerElement.created() : super.created() {
  }

  void appIdChanged() {
    app = document.querySelector('#$appId');
  }
  
  // Reset this input back to empty
  void reset() {
    window.console.log("Resetting");
    if (answerInput == null)
      return;
    answerInput.value = '';
    answerInput.inputValue = '';
    answerInput.blur();
  }
  
  void gotInput(Event event) {
    answerInput = event.target;
    if (answerInput.inputValue == '')
      return;
    window.console.log('Got input: "${answerInput.inputValue}"');
    app.checkPartialAnswer(answerInput.inputValue);
  }
  
  // Hit the enter key
  void gotChange(Event event) {
    answerInput = event.target;
    if (answerInput.inputValue == '')
      return;
    
    window.console.log('Got change: "${answerInput.inputValue}"');
    app.checkFullAnswer(answerInput.inputValue);
  }
}
