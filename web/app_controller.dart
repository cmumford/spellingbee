library spellingbee.web.app_controller;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'speak_button.dart';
import 'definition_button.dart';
import 'answer_element.dart';
import 'statistics_element.dart';
import 'corpus.dart';
import 'word.dart';
import 'dart:math';
import 'package:paper_elements/paper_icon_button.dart';
import 'package:core_elements/core_drawer_panel.dart';

@CustomTag('app-controller')
class AppController extends PolymerElement {
  
  @published String speakId;
  @published String definitionId;
  @published String answerId;
  @published String statisticsId;
  @observable SpeakButton speakButton;
  @observable DefinitionButton definitionButton;
  @observable AnswerElement answerElement;
  @observable StatisticsElement statisticsElement;
  Corpus corpus;
  static const int k_NumWordsInTest = 3;
  int current_word_idx;
  List<Word> current_words = new List<Word>();
  Random rand = new Random();
  CoreDrawerPanel core_drawer_panel;
  
  AppController.created() : super.created() {
    corpus = new Corpus();
    onCorpusLoaded() {
      window.console.log("Got corpus");
      Element intro = document.querySelector('#intro');
      int numWords = corpus.words.length;
      intro.innerHtml = "Spelling bee practice of $numWords words.";
      startTest();
    }
    corpus.onLoad(onCorpusLoaded);
    corpus.load();
    
    PaperIconButton navicon = document.querySelector('#navicon');
    core_drawer_panel = document.querySelector('#drawerPanel');
    onClicked(MouseEvent event) {
      toggleDrawer();
    }
    navicon.addEventListener('click', onClicked);
  }
  
  void toggleDrawer() {
    // Seems to be a bug in Polymer, Polymer.dart:
    // https://github.com/dart-lang/core-elements/issues/39
    core_drawer_panel.jsElement.callMethod('togglePanel', []);
  }
  
  void startTest() {
    window.console.log("Starting new test");
    current_word_idx = 0;
    List<int> used_idxs = new List<int>();
    current_words.clear();
    while (current_words.length < k_NumWordsInTest) {
      int idx = rand.nextInt(corpus.words.length - 1);
      if (!used_idxs.contains(idx)) {
        current_words.add(corpus.words[idx]);
        used_idxs.add(idx);
      }
    }
    answerElement.reset();
    statisticsElement.reset();
  }
  
  Word current_word() {
    return current_words[current_word_idx];
  }
  
  void speaking_started() {
    window.console.log("Started speaking...");
  }

  void speaking_stopped() {
    window.console.log("Stopped speaking...");
  }
  
  void answerIdChanged() {
    answerElement = document.querySelector('#$answerId');
  }
  
  void speakIdChanged() {
    speakButton = document.querySelector('#$speakId');
  }

  void definitionIdChanged() {
    definitionButton = document.querySelector('#$definitionId');
  }
  
  void statisticsIdChanged() {
    statisticsElement = document.querySelector('#$statisticsId');
  }
  
  void moveToNextWord() {
    current_word_idx += 1;
    if (current_word_idx >= current_words.length)
      startTest();
    else
      answerElement.reset();
  }
  
  void gotAnswerRight() {
    window.console.log("Answer is correct");
    statisticsElement.addResult(1);
    moveToNextWord();
  }
  
  void gotAnswerWrong(String answer, String actual_answer) {
    window.console.log('Got answer wrong: "$answer" != "$actual_answer"');
    statisticsElement.addResult(-1);
    moveToNextWord();
  }
  
  // Does txt start with sub (case insensitive)
  static bool startsWith(String sub, String txt) {
    if (sub.length > txt.length)
      return false;
    
    String txt_sub = txt.toLowerCase().substring(0, sub.length);
    return txt_sub == sub.toLowerCase();
  }
  
  void checkPartialAnswer(String partial_answer) {
    Word word = current_word();
    if (!startsWith(partial_answer, word.word))
      gotAnswerWrong(partial_answer, word.word);
    else
      window.console.log("$partial_answer is the start of ${word.word}");
  }
  
  void checkFullAnswer(String answer) {
    Word word = current_word();
    if (word.word.toLowerCase() != answer.toLowerCase())
      gotAnswerWrong(answer, word.word);
    else
      gotAnswerRight();
  }
  
  void onNavigate() {
    window.console.log("Navigate button pressed");
  }
}