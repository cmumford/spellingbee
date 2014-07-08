library spellingbee.web.corpus;

import 'dart:html';
import 'dart:convert';
import 'word.dart';

class Corpus extends Object {
  
  List<Word> words;
  
  Corpus() {
    load();
  }
  
  void load() {
    var url = "words.json";
    
    window.console.log("Loading the corpus");
    void onDataLoaded(String responseText) {
      window.console.log("Got corpus data");
      List json_words = JSON.decode(responseText);
      words = new List<Word>();
      for (Map word_info in json_words) {
        words.add(new Word(word_info['word'], word_info['definition']));
      }
      window.console.log("Done parsing corpus: " + words.length.toString());
    }
    var request = HttpRequest.getString(url).then(onDataLoaded);
    onError(event) {
      window.console.error("Got an error loading corpus");
    }
    request.catchError(onError);
  }
}