library spellingbee.web.appcontroller;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'speakbutton.dart';
import 'definitionbutton.dart';
import 'corpus.dart';
import 'word.dart';

@CustomTag('app-controller')
class AppController extends PolymerElement {
  
  @published String speakId;
  @published String definitionId;
  @observable SpeakButton speakButton;
  @observable DefinitionButton definitionButton;
  Corpus corpus;
  
  AppController.created() : super.created() {
    corpus = new Corpus();
  }
  
  Word current_word() {
    for (Word w in corpus.words) {
      if (w.word == 'eggplant') {
        return w;
      }
    }
    return corpus.words[0];    
  }
  
  void speaking_started() {
    window.console.log("Started speaking...");
  }

  void speaking_stopped() {
    window.console.log("Stopped speaking...");
  }
  
  void speakIdChanged() {
    speakButton = document.querySelector('#$speakId');
  }

  void definitionIdChanged() {
    definitionButton = document.querySelector('#$definitionId');
    window.console.log(definitionButton.toString());
  }
}