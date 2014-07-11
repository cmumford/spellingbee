import 'dart:html';
import 'dart:web_audio';

class Speaker {
  static const int _MAX_SPEAK_PHRASE_LEN = 100; // All Google xlate can do in a single GET
  static const bool _DEBUG = false;
  AudioContext _audio_context = new AudioContext();
  
  void playSoundUsingWebAudio(String url, EventListener errcb, EventListener endcb) {
    
    // Not working because of cross domain checks.
    AudioBufferSourceNode source = _audio_context.createBufferSource();
    window.console.log("Playing using web audio: $url");
    HttpRequest request = new HttpRequest();
    request.responseType = "arraybuffer";
    request.onLoad.listen((event) {
      window.console.log("Decoding audio data");
      //audioContext.decodeAudioData(request.response);
    });
    request.open("GET", url, async: true);
    request.send();
  }
  
  // Need to run from Chrome to hear sound!
  // https://code.google.com/p/dart/issues/detail?id=9318
  void playSound(String url, EventListener errcb, EventListener endcb) {
    if (_DEBUG)
      window.console.log('Playing: $url');
    AudioElement audio = new AudioElement(url);
    if (errcb != null)
      audio.onError.listen(errcb);
    if (endcb != null)
      audio.onEnded.listen(endcb);
    audio.play();
  }
  
  void speakViaDictionary(String word, EventListener errcb, EventListener endcb) {
    String lc_word = word.toLowerCase();
    String encoded_word = Uri.encodeComponent(lc_word);
    String url = 'http://ssl.gstatic.com/dictionary/static/sounds/de/0/${encoded_word}.mp3';
    
    playSound(url, errcb, endcb);
  }
  
  static bool isPhraseTooLong(String phrase) => phrase.length > _MAX_SPEAK_PHRASE_LEN;
  
  void speakViaTranslate(String phrase, EventListener errcb, EventListener endcb) {
    // Google translate will only speak 100 characters at a time. we can fix
    // this if we want to spend the time. See:
    // http://www.hung-truong.com/blog/2013/04/26/hacking-googles-text-to-speech-api/
    if (isPhraseTooLong(phrase)) {
      const String astr = '. TRUNCATED!';
      window.console.log('Truncating "$phrase"');
      // truncate to length allowing whatever we want to append.
      phrase = phrase.substring(0, _MAX_SPEAK_PHRASE_LEN - astr.length);
      // Assume we truncated the last word so delete it.
      List<String> words = phrase.split(' ');
      words.removeLast();
      phrase = words.join(' ');
      // Now concat our phrase.
      phrase += astr;
      //document.getElementById('toolong').style.display="inline";
    }
    
    if (_DEBUG)
      window.console.log('Speaking: "$phrase"');
    String encoded = Uri.encodeComponent(phrase.toLowerCase());
    String url = 'http://translate.google.com/translate_tts?ie=UTF-8&q=${encoded}&tl=en&total=1&idx=0&textlen=${encoded.length}&prev=input';
    playSound(url, errcb, endcb);
  }
  
  void speak(String word, EventListener errcb, EventListener endcb) {
    dictErr(_) {
      if (_DEBUG)
        window.console.log("Falling back to translate");
      speakViaTranslate(word, errcb, endcb);
    }
    speakViaDictionary(word, dictErr, endcb);
  }
}