import 'dart:io';
import 'package:dart_sentencepiece_tokenizer/dart_sentencepiece_tokenizer.dart';

void main() {
  final tokenizerPath = '/home/xcarol/.local/share/com.xicra.moviescout/nlu_assets/tokenizer.json';
  final tokenizer = TokenizerJsonLoader.fromJsonFileSync(tokenizerPath);
  
  // Try normal string
  final t1 = tokenizer.encode('alien in space').ids;
  
  // Try with Metaspace explicitly prepended
  String text = ' alien in space'.replaceAll(' ', '\u2581');
  final t2 = tokenizer.encode(text).ids;
  
  print('Normal: $t1');
  print('Metaspace explicitly: $t2');
}
