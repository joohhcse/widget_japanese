import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedOption = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WordProvider>(context);
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
                return Column(
                  children: [
                    Text(
                      '${wordProvider.duration.inSeconds} ',
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      wordProvider.currentWord,
                      style: TextStyle(fontSize: 48),
                    ),
                  ],
                );
              },
            ),

            // Radio Option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   'Option',
                //   style: TextStyle(fontSize: 20),
                // ),
                // CupertinoSwitch(value: value, onChanged: onChanged)
                Text('Hiragana'),
                Radio(
                  value: 0,
                  groupValue: provider.selectedOption,
                  onChanged: (int? value) {
                    if (value != null) {
                      provider.saveSelectedOption(value);
                    }
                  },
                ),
                Text('Katakana'),
                Radio(
                  value: 1,
                  groupValue: provider.selectedOption,
                  onChanged: (int? value) {
                    if (value != null) {
                      provider.saveSelectedOption(value);
                    }
                  },
                ),
                Text('All'),
                Radio(
                  value: 2,
                  groupValue: provider.selectedOption,
                  onChanged: (int? value) {
                    if (value != null) {
                      provider.saveSelectedOption(value);
                    }
                  },
                ),
              ],
            ),

            // Expanded(
            //     child: Text(),
            // )
            // ElevatedButton(
            //   onPressed: () {
            //     Provider.of<WordProvider>(context, listen: false).updateWidget();
            //   },
            //   child: Text('Update Widget'),
            // ),
          ],
        ),
      ),
    );
  }

}



class WordProvider with ChangeNotifier {
  String _currentWord = "あ : a";
  Timer? _timer;
  static const platform = MethodChannel('com.example.widget/update');
  Duration _duration = Duration(seconds: 5);
  DateTime? _nextUpdateTime;
  final Random _random = Random();
  int _selectedOption = 0;

  WordProvider() {
    _loadWord();
    _startTimer();
    _loadSelectedOption();
  }

  String get currentWord => _currentWord;
  int get selectedOption => _selectedOption;

  Duration get duration => _nextUpdateTime != null
      ? _nextUpdateTime!.difference(DateTime.now())
      : Duration.zero;

  void _loadWord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentWord = prefs.getString('currentWord') ?? "あ : a";
    notifyListeners();
  }

  void _saveWord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentWord', _currentWord);
  }

  void _startTimer() {
    // _timer = Timer.periodic(Duration(seconds: 7), (timer) {
    //   _changeWord();
    // });

    _nextUpdateTime = DateTime.now().add(_duration);
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_nextUpdateTime != null && DateTime.now().isAfter(_nextUpdateTime!)) {
        _changeWord();
        _nextUpdateTime = DateTime.now().add(_duration);
      }
      notifyListeners();
    });
  }

  void _changeWord() {
    List<String> hWords = [
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
    ];
    List<String> kWords = [
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
    List<String> allWords =
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

    int idx;
    if(_selectedOption == 0) {
      idx = _random.nextInt(hWords.length);
      _currentWord = hWords[idx];
    } else if(_selectedOption == 1) {
      idx = _random.nextInt(kWords.length);
      _currentWord = kWords[idx];
    } else if(_selectedOption == 2) {
      idx = _random.nextInt(allWords.length);
      _currentWord = allWords[idx];
    } else {
      idx = _random.nextInt(allWords.length);
      _currentWord = allWords[idx];
    }

    print(idx);
    print(_selectedOption);

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

  Future<void> _loadSelectedOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedOption = prefs.getInt('selectedOption') ?? 0;
    notifyListeners();
  }

  Future<void> saveSelectedOption(int option) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedOption = option;
    await prefs.setInt('selectedOption', option);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
