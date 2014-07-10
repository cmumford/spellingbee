library spellingbee.web.corpus;

import 'dart:html';
import 'dart:convert';
import 'word.dart';

class Corpus extends Object {
  
  List<Word> words;
  Function _loadCallback;
  
  Corpus() {
  }
  
  void onLoad(Function callback) {
    _loadCallback = callback;
  }
  
  void load() {
    var url = "words.json";
    void onDataLoaded(String responseText) {
      List json_words = JSON.decode(responseText);
      words = new List<Word>();
      for (Map word_info in json_words) {
        words.add(new Word(word_info['word'], word_info['definition']));
      }
      if (_loadCallback != null)
        _loadCallback();
    }
    // Should I be using core-ajax?
    var request = HttpRequest.getString(url).then(onDataLoaded);
    onError(event) {
      window.console.error("Got an error loading corpus");
    }
    request.catchError(onError);
  }
}