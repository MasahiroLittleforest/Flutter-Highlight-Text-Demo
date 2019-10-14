import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Highlight Text Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Highlight Text Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String originalText = '';
  String inputText = '';
  String highlightedText = '';
  final TextEditingController _originalTextController = TextEditingController();
  final TextEditingController _highlightedPartController =
      TextEditingController();

  void refreshScreen() {
    setState(() {
      originalText = '';
      inputText = '';
      highlightedText = '';
      _originalTextController.clear();
      _highlightedPartController.clear();
    });
  }

  List<Widget> getHighlightedText(String originalString, String inputString) {
    List<Widget> highlightedText;
    final String lowerOriginalString = originalString.toLowerCase();
    final String lowerInputString = inputString.toLowerCase();
    final int lastOfOriginalString = originalString.length - 1;
    final int firstOfInputString =
        lowerOriginalString.indexOf(lowerInputString);
    int lastOfInputString;

    // 入力値に連続する同じ文字が含まれる時に、'lastOfInputString'が1つ目のインデックスにならないようにする
    if (lowerInputString.length >= 2) {
      final String secondLastInputLetter =
          lowerInputString[lowerInputString.length - 2];
      final String lastInputLetter =
          lowerInputString[lowerInputString.length - 1];
      if (secondLastInputLetter == lastInputLetter) {
        lastOfInputString = lowerOriginalString.indexOf(lowerInputString) +
            (lowerInputString.length - 1);
      } else {
        lastOfInputString = lastOfInputString = lowerOriginalString
            .indexOf(lowerInputString[lowerInputString.length - 1]);
      }
    } else {
      lastOfInputString = lastOfInputString = lowerOriginalString
          .indexOf(lowerInputString[lowerInputString.length - 1]);
    }

    // inputStringと一致する箇所がない場合のエラー(Value not in range: -1)回避
    if (firstOfInputString == -1) {
      return [Container()];
    }

    // 頭から途中まで一致
    if (lowerOriginalString.startsWith(lowerInputString)) {
      highlightedText = [
        Text(
          originalString.substring(firstOfInputString, lastOfInputString + 1),
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 24.0,
          ),
        ),
        Text(
          originalString.substring(lastOfInputString + 1),
          style: TextStyle(fontSize: 24.0),
        ),
      ];
      // 途中で部分一致
    } else if (!lowerOriginalString.startsWith(lowerInputString) &&
        !lowerOriginalString.endsWith(lowerInputString) &&
        lowerOriginalString.contains(lowerInputString)) {
      highlightedText = [
        Text(
          originalString.substring(0, firstOfInputString),
          style: TextStyle(fontSize: 24.0),
        ),
        Text(
          originalString.substring(firstOfInputString, lastOfInputString + 1),
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 24.0,
          ),
        ),
        Text(
          originalString.substring(
              lastOfInputString + 1, lastOfOriginalString + 1),
          style: TextStyle(fontSize: 24.0),
        ),
      ];
      // 途中から末尾まで一致
    } else if (lowerOriginalString.endsWith(lowerInputString)) {
      highlightedText = [
        Text(
          originalString.substring(0, firstOfInputString),
          style: TextStyle(fontSize: 24.0),
        ),
        Text(
          originalString.substring(firstOfInputString, lastOfInputString + 1),
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 24.0,
          ),
        ),
      ];
      // 完全一致
    } else if (lowerOriginalString == lowerInputString) {
      highlightedText = [
        Text(
          originalString,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 24.0,
          ),
        ),
      ];
    }
    return highlightedText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Highlight Text'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Text(
                  'Original Text: ',
                  style: TextStyle(fontSize: 16),
                ),
                Flexible(
                  child: originalText == ''
                      ? TextField(
                          controller: _originalTextController,
                          onEditingComplete: () {
                            setState(() {
                              originalText = _originalTextController.text;
                            });
                          },
                        )
                      : Text(
                          originalText,
                          style: const TextStyle(fontSize: 24),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                const Text(
                  'Highlighted Text: ',
                  style: TextStyle(fontSize: 16),
                ),
                inputText == ''
                    ? Text(
                        originalText,
                        style: const TextStyle(fontSize: 24.0),
                      )
                    : Row(
                        children: getHighlightedText(originalText, inputText),
                      ),
              ],
            ),
            const SizedBox(height: 60.0),
            TextField(
              controller: _highlightedPartController,
              enabled: originalText == '' ? false : true,
              decoration: const InputDecoration(hintText: 'Keyword'),
              onChanged: (value) {
                setState(() {
                  inputText = value;
                });
              },
            ),
            const SizedBox(height: 60.0),
            RaisedButton(
              onPressed: refreshScreen,
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
