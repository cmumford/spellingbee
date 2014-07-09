library spellingbee.web.statistics_element;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'appcontroller.dart';

/**
 * UI to handle the user's answer
 */
@CustomTag('statistics-element')
class StatisticsElement extends PolymerElement {
  @published String appId;
  @observable AppController app;
  int correct = 0;
  int incorrect = 0;
  int total = 0;
  double score = 0.0;
  
  InputElement guess;
    
  StatisticsElement.created() : super.created() {
  }

  void appIdChanged() {
    app = document.querySelector('#$appId');
  }
}
