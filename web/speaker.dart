import 'dart:html';

class Speaker {
  static const int maxSpeakPhraseLen = 100; // All Google xlate can do in a single GET
  
  // Need to run from Chrome to hear sound!
  // https://code.google.com/p/dart/issues/detail?id=9318
  void play_sound(String url, EventListener errcb, EventListener endcb) {
    window.console.log('Playing: $url');
    AudioElement audio = new AudioElement(url);
    audio.onError.listen(errcb);
    audio.onEnded.listen(endcb);
    audio.load();
    audio.play();
  }
  
  void speak_via_dictionary(word, errcb, endcb) {
    String lc_word = word.toLowerCase();
    String encoded_word = Uri.encodeComponent(lc_word);
    String url = 'http://ssl.gstatic.com/dictionary/static/sounds/de/0/${encoded_word}.mp3';
    
    play_sound(url, errcb, endcb);
  }
  
  bool is_phrase_too_long(String phrase) {
    return phrase.length > maxSpeakPhraseLen;
  }
  
  void speak_via_translate(String phrase, errcb, endcb) {
    // Google translate will only speak 100 characters at a time. we can fix
    // this if we want to spend the time. See:
    // http://www.hung-truong.com/blog/2013/04/26/hacking-googles-text-to-speech-api/
    if (is_phrase_too_long(phrase)) {
      const String astr = '. TRUNCATED!';
      window.console.log('Truncating "$phrase"');
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
    
    window.console.log('Speaking: "$phrase"');
    String encoded = Uri.encodeComponent(phrase.toLowerCase());
    String url = 'http://translate.google.com/translate_tts?ie=UTF-8&q=' + encoded +
                 '&tl=en&total=1&idx=0&textlen='+encoded.length.toString()+'&prev=input';
    play_sound(url, errcb, endcb);
  }
  
  void speak(word, errcb, endcb) {
    window.console.log('Speaking: "$word"');
    speak_via_translate(word, errcb, endcb);
  }
}