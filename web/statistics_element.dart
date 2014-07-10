library spellingbee.web.statistics_element;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'app_controller.dart';

/**
 * UI to handle the user's answer
 */
@CustomTag('statistics-element')
class StatisticsElement extends PolymerElement {
  @published String appId;
  AppController _app;
  @observable int correct = 0;
  @observable int incorrect = 0;
  @observable int total = 0;
  @observable double score = 0.0;
  
  StatisticsElement.created() : super.created();

  void appIdChanged() {
    _app = document.querySelector('#$appId');
  }
  
  void reset() {
    correct = 0;
    incorrect = 0;
    total = 0;
    score = 0.0;
  }
  
  void addResult(int result) {
    if (result == 1)
      correct += 1;
    else
      incorrect += 1;
    total = correct + incorrect;
    score = (100.0 * correct / total).roundToDouble();
  }
}
