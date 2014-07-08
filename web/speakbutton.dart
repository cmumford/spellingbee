import 'package:polymer/polymer.dart';
import 'dart:html';

/**
 * A button to speak a word
 */
@CustomTag('speak-button')
class SpeakButton extends PolymerElement {
  @published String word = "Hello";
  
  static const int maxSpeakPhraseLen = 100; // All Google xlate can do in a single GET

  SpeakButton.created() : super.created() {
    window.console.log("Created SpeakButton");
  }

  void has_spoken() {
    
  }
  
  // Need to run from Chrome to hear sound!
  // https://code.google.com/p/dart/issues/detail?id=9318
  void play_sound(String url, EventListener errcb, EventListener endcb) {
    AudioElement audio = new AudioElement(url);
    audio.onError.listen(errcb);
    audio.onEnded.listen(endcb);
    audio.load();
    audio.play();
  }
  
  void speak_via_dictionary(the_word) {
    String lc_word = the_word.toLowerCase();
    String encoded_word = Uri.encodeComponent(lc_word);
    String url = 'http://ssl.gstatic.com/dictionary/static/sounds/de/0/' + encoded_word + '.mp3';
    
    onError(event) {
      window.console.error("Error playing sound: " + the_word);
      window.console.error(url);
    };
    
    onEnded(event) {
      window.console.log("Done speaking '" + the_word + '"');
      has_spoken();
    }

    play_sound(url, onError, onEnded);
  }
  
  bool is_phrase_too_long(String phrase) {
    return phrase.length > maxSpeakPhraseLen;
  }
  
  void speak_via_translate(String phrase) {
    // Google translate will only speak 100 characters at a time. we can fix
    // this if we want to spend the time. See:
    // http://www.hung-truong.com/blog/2013/04/26/hacking-googles-text-to-speech-api/
    if (is_phrase_too_long(phrase)) {
      String astr = '. TRUNCATED!';
      window.console.log('Truncating "' + phrase + '"');
      // truncate to length allowing whatever we want to append.
      phrase = phrase.substring(0, maxSpeakPhraseLen - astr.length);
      // Assume we truncated the last word so delete it.
      List<String> words = phrase.split(' ');
      words.removeLast();
      phrase = words.join(' ');
      // Now concat our phrase.
      phrase += astr;
      //document.getElementById('toolong').style.display="inline";
    }
    
    window.console.log('Speaking: "' + phrase + '"');
    String encoded = Uri.encodeComponent(phrase.toLowerCase());
    String url = 'http://translate.google.com/translate_tts?ie=UTF-8&q=' + encoded +
                 '&tl=en&total=1&idx=0&textlen='+encoded.length.toString()+'&prev=input';
    onError(event) {
      window.console.error("Error playing sound: " + word);
      window.console.error(url);
    };
    
    onEnded(event) {
      window.console.log("Done speaking '" + word + '"');
      has_spoken();
    }
    play_sound(url, onError, onEnded);
  }
  
  void speak() {
    window.console.log("Speaking: " + word);
    speak_via_translate(word);
  }
}

