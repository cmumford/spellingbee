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
import 'package:paper_elements/paper_dialog.dart';
import 'package:core_elements/core_drawer_panel.dart';

@CustomTag('app-controller')
class AppController extends PolymerElement {
  
  @published String speakId;
  @published String definitionId;
  @published String answerId;
  @published String statisticsId;
  SpeakButton _speak_button;
  DefinitionButton _definition_button;
  AnswerElement _answer_element;
  StatisticsElement _statistics_element;
  Corpus _corpus;
  static const int _NUM_WORDS_IN_TEST = 4;
  int _current_word_idx;
  List<Word> _current_words = new List<Word>();
  Random _rand = new Random();
  CoreDrawerPanel _core_drawer_panel;
  Speaker _speaker = new Speaker();
  PaperToast _toast_correct;
  PaperToast _toast_incorrect;
  PaperProgress _progress;
  Element _div_quiz;
  Element _div_start;
  bool _in_quiz = false;
  
  AppController.created() : super.created() {
    _corpus = new Corpus();
    onCorpusLoaded() {
      window.console.log("Got corpus");
      startTest();
    }
    _corpus.onLoad(onCorpusLoaded);
    _corpus.load();
    
    PaperIconButton navicon = document.querySelector('#navicon');
    _core_drawer_panel = document.querySelector('#drawerPanel');
    onClicked(MouseEvent event) {
      toggleDrawer();
    }
    navicon.addEventListener('click', onClicked);
    _toast_correct = document.querySelector('#correct');
    _toast_incorrect = document.querySelector('#incorrect');
    _progress = document.querySelector('#progress');
    _progress.max = _NUM_WORDS_IN_TEST;
    
    document.querySelector('#helpButton').onClick.listen(helpClicked);
    document.querySelector('#newQuiz').onClick.listen(newQuizClicked);
    
    _div_quiz = document.querySelector("#quizDiv");
    _div_start = document.querySelector("#startDiv");
  }
  
  void toggleDivs() {
    if (_div_quiz.style.display == "none") {
      _div_quiz.style.display = "inherit";
      _div_start.style.display = "none";
    } else {
      _div_quiz.style.display = "none";
      _div_start.style.display = "inherit";
    }
  }
  
  void helpClicked(_) {
    PaperDialog dialog = document.querySelector('#helpDialog');
    dialog.toggle();
  }
  
  void newQuizClicked(_) {
    startTest();
    toggleDivs();
  }
  
  void setProgress() {
    Element intro = document.querySelector('#intro');
    intro.innerHtml = "Word ${_current_word_idx+1} of ${_current_words.length} out of ${_corpus.words.length} words.";
    if (_progress != null)
      _progress.value = _current_word_idx;
  }
  
  void toggleDrawer() {
    // Seems to be a bug in Polymer, Polymer.dart:
    // https://github.com/dart-lang/core-elements/issues/39
    _core_drawer_panel.jsElement.callMethod('togglePanel', []);
  }
  
  void startTest() {
    window.console.log("Starting new test");
    _in_quiz = true;
    _current_word_idx = 0;
    List<int> used_idxs = new List<int>();
    _current_words.clear();
    while (_current_words.length < _NUM_WORDS_IN_TEST) {
      int idx = _rand.nextInt(_corpus.words.length - 1);
      if (!used_idxs.contains(idx)) {
        _current_words.add(_corpus.words[idx]);
        used_idxs.add(idx);
      }
    }
    _answer_element.reset();
    _statistics_element.reset();
    setProgress();
  }
  
  Word currentWord() => _current_words[_current_word_idx];
  
  void speakingStarted() {
    // Might want to desensitize controls
  }

  void speakingStopped() {
    // Might want to sensitize controls
  }
  
  void answerIdChanged() {
    _answer_element = document.querySelector('#$answerId');
  }
  
  void speakIdChanged() {
    _speak_button = document.querySelector('#$speakId');
  }

  void definitionIdChanged() {
    _definition_button = document.querySelector('#$definitionId');
  }
  
  void statisticsIdChanged() {
    _statistics_element = document.querySelector('#$statisticsId');
  }
  
  void moveToNextWord() {
    _current_word_idx += 1;
    if (_current_word_idx >= _current_words.length) {
      _in_quiz = false;
      toggleDivs();
      toggleDrawer();
    } else {
      _answer_element.reset();
      setProgress();
    }
  }
  
  void gotAnswerRight() {
    window.console.log("Answer is correct");
    _toast_correct.show();
    _speaker.speakViaDictionary("right", null, null);
    _statistics_element.addResult(1);
    moveToNextWord();
  }
  
  void gotAnswerWrong(String answer, String actual_answer) {
    window.console.log('Got answer wrong: "$answer" != "$actual_answer"');
    _toast_incorrect.show();
    _speaker.speakViaDictionary("incorrect", null, null);
    _statistics_element.addResult(-1);
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
    if (!_in_quiz)
      return;
    Word word = currentWord();
    if (!startsWith(partial_answer, word.word))
      gotAnswerWrong(partial_answer, word.word);
    else
      window.console.log("$partial_answer is the start of ${word.word}");
  }
  
  void checkFullAnswer(String answer) {
    // Apparently input events get a value change when parent div is hidden
    // so looking at state variable to early exit.
    if (!_in_quiz)
      return;
    Word word = currentWord();
    if (word.word.toLowerCase() == answer.toLowerCase())
      gotAnswerRight();
    else
      gotAnswerWrong(answer, word.word);
  }
}