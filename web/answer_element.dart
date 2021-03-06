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
  AppController _app;
  PaperInput _answerInput;

  AnswerElement.created() : super.created();

  void appIdChanged() {
    _app = document.querySelector('#$appId');
  }
  
  // Reset this input back to empty
  void reset() {
    if (_answerInput == null)
      return;
    _answerInput.value = '';
    _answerInput.inputValue = '';
    _answerInput.blur();
  }
  
  void gotInput(Event event) {
    _answerInput = event.target;
    if (_answerInput.inputValue == '')
      return;
    window.console.log('Got input: "${_answerInput.inputValue}"');
    _app.checkPartialAnswer(_answerInput.inputValue);
  }
  
  // Hit the enter key
  void gotChange(Event event) {
    _answerInput = event.target;
    String answer = _answerInput.inputValue;
    if (answer == '')
      return;
    
    reset();
    window.console.log('Got change: "${answer}"');
    _app.checkFullAnswer(answer);
  }
}
