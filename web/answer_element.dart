library spellingbee.web.answer_element;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'app_controller.dart';

/**
 * UI to handle the user's answer
 */
@CustomTag('answer-element')
class AnswerElement extends PolymerElement {
  @published String appId;
  @observable AppController app;
  @published String answer;
    
  AnswerElement.created() : super.created() {
  }

  void appIdChanged() {
    app = document.querySelector('#$appId');
  }
  
  void answerChanged() {
    if (answer != '')
      app.checkPartialAnswer(answer);
  }
  
  // Reset this element back to empty
  void reset() {
    clearAnswer() {
      answer = '';
    }
    // Use a timer bacause if we set the InputElement during a change event
    // then it will be ignored.
    Timer.run(clearAnswer);
  }
}
