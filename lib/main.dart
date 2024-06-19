import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WordProvider(),
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일본어 외우기 - 히라가나 / 가타가나'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<WordProvider>(
              builder: (context, wordProvider, child) {
                return Text(
                  wordProvider.currentWord,
                  style: TextStyle(fontSize: 24),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<WordProvider>(context, listen: false).updateWidget();
              },
              child: Text('Update Widget'),
            ),
          ],
        ),
      ),
    );
  }
}

class WordProvider with ChangeNotifier {
  String _currentWord = "Hello";
  Timer? _timer;
  static const platform = MethodChannel('com.example.widget/update');

  WordProvider() {
    _loadWord();
    _startTimer();
  }

  String get currentWord => _currentWord;

  void _loadWord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentWord = prefs.getString('currentWord') ?? "Hello";
    notifyListeners();
  }

  void _saveWord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentWord', _currentWord);
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _changeWord();
    });
  }

  void _changeWord() {
    List<String> words =
    [
      "あ : a", "い : i", "う : u", "え : e", "お : o",
      "か : ka", "き : ki", "く : ku", "け : ke", "こ : ko",
      "さ : sa", "し : shi", "す : su", "せ : se", "そ : so",
      "た : ta", "ち : chi", "つ : tsu", "て : te", "と : to",
      "な : na", "に : ni", "ぬ : nu", "ね : ne", "の : no",
      "は : ha", "ひ : hi", "ふ : fu", "へ : he", "ほ : ho",
      "ま : ma", "み : mi", "む : mu", "め : me", "も : mo",
      "や : ya", "ゆ : yu", "よ : yo",
      "ら : ra", "り : ri", "る : ru", "れ : re", "ろ : ro",
      "わ : wa", "を : o",
      "ん : N",
      "ア : a", "イ : i", "ウ : u", "エ : e", "オ : o",
      "カ : ka", "キ : ki", "ク : ku", "ケ : ke", "コ : ko",
      "サ : sa", "シ : shi", "ス : su", "セ : se", "ソ : so",
      "タ : ta", "チ : chi", "ツ : tsu", "テ : te", "ト : to",
      "ナ : na", "ニ : ni", "ヌ : nu", "ネ : ne", "ノ : no",
      "ハ : ha", "ヒ : hi", "フ : fu", "ヘ : he", "ホ : ho",
      "マ : ma", "ミ : mi", "ム : mu", "メ : me", "モ : mo",
      "ヤ : ya", "ユ : yu", "ヨ : yo",
      "ラ : ra", "リ : ri", "ル : ru", "レ : re", "ロ : ro",
      "ワ : wa", "ヲ : o",
      "ン : N"
    ];
    _currentWord = words[DateTime.now().minute % words.length];
    _saveWord();
    notifyListeners();
    updateWidget();
  }

  Future<void> updateWidget() async {
    try {
      await platform.invokeMethod('updateWidget', {"word": _currentWord});
    } on PlatformException catch (e) {
      print("Failed to update widget: '${e.message}'.");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
