library spellingbee.web.app_controller;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'speak_button.dart';
import 'definition_button.dart';
import 'answer_element.dart';
import 'statistics_element.dart';
import 'speaker.dart';
import 'corpus.dart';
import 'word.dart';
import 'dart:math';
import 'package:paper_elements/paper_icon_button.dart';
import 'package:paper_elements/paper_toast.dart';
import 'package:paper_elements/paper_progress.dart';
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
  static const int k_NumWordsInTest = 5;
  int current_word_idx;
  List<Word> current_words = new List<Word>();
  Random rand = new Random();
  CoreDrawerPanel core_drawer_panel;
  Speaker speaker = new Speaker();
  PaperToast toast_correct;
  PaperToast toast_incorrect;
  PaperProgress progress;
  
  AppController.created() : super.created() {
    corpus = new Corpus();
    onCorpusLoaded() {
      window.console.log("Got corpus");
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
    toast_correct = document.querySelector('#correct');
    toast_incorrect = document.querySelector('#incorrect');
    progress = document.querySelector('#progress');
    progress.max = k_NumWordsInTest;
  }
  
  void setProgress() {
    Element intro = document.querySelector('#intro');
    intro.innerHtml = "Word ${current_word_idx+1} of ${current_words.length} out of ${corpus.words.length} words.";
    progress.value = current_word_idx;
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
    setProgress();
  }
  
  Word current_word() {
    return current_words[current_word_idx];
  }
  
  void speaking_started() {
    // Might want to desensitize controls
  }

  void speaking_stopped() {
    // Might want to sensitize controls
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
    if (current_word_idx >= current_words.length) {
      startTest();
      toggleDrawer();
    }
    else {
      answerElement.reset();
      setProgress();
    }
  }
  
  void gotAnswerRight() {
    window.console.log("Answer is correct");
    toast_correct.show();
    speaker.speak_via_dictionary("right", null, null);
    statisticsElement.addResult(1);
    moveToNextWord();
  }
  
  void gotAnswerWrong(String answer, String actual_answer) {
    window.console.log('Got answer wrong: "$answer" != "$actual_answer"');
    toast_incorrect.show();
    speaker.speak_via_dictionary("incorrect", null, null);
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
    if (!startsWith(partial_answer, word.word)) {
      gotAnswerWrong(partial_answer, word.word);
    }
    else
      window.console.log("$partial_answer is the start of ${word.word}");
  }
  
  void checkFullAnswer(String answer) {
    Word word = current_word();
    if (word.word.toLowerCase() == answer.toLowerCase())
      gotAnswerRight();
    else
      gotAnswerWrong(answer, word.word);
  }
  
  void onNavigate() {
    window.console.log("Navigate button pressed");
  }
}