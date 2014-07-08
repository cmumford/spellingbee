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
    
  AnswerElement.created() : super.created() {
  }

  void check() {
  }
  
  void appIdChanged() {
    app = document.querySelector('#$appId');
  }
}
