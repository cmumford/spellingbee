library spellingbee.web.app_controller;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'speak_button.dart';
import 'definition_button.dart';
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
    onCorpusLoaded() {
      window.console.log("Got corpus");
      Element intro = document.querySelector('#intro');
      int numWords = corpus.words.length;
      intro.innerHtml = "Spelling bee practice of $numWords words.";
    }
    corpus.onLoad(onCorpusLoaded);
    corpus.load();
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
  }
}