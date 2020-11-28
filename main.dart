import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'package:clipboard/clipboard.dart';

import 'package:flutter_tts/flutter_tts.dart';

import 'package:translator/translator.dart';

import 'package:text_recognition/ControlsWidget.dart';
import 'package:text_recognition/TextAreaWidget.dart';

void main() => runApp(MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int currentIndex;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  File pickedImage;
  String identifiedText = '';
  String out = 'Choose a language';
  String language = '';
  final lang = TextEditingController();
  final lang2 = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  String dyslexiaText = '';
  GoogleTranslator translator = new GoogleTranslator();


  ///This allows the user to choose an image file
  Future pickImage() async {
    final file = await ImagePicker().getImage(source: ImageSource.gallery);
    setImage(File(file.path));
  }

  ///This scans the text in the picture
  Future scanText() async {
    showDialog(
      context: context,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );

    final text = await recognizeText(pickedImage);
    setText(text);

    Navigator.of(context).pop();
  }

  ///This method defines what the copy to clipboard button does
  void copyToClipboard() {
    if (identifiedText.trim() != '') {
      FlutterClipboard.copy(identifiedText);
    }
  }

  void setImage(File newImage) {
    setState(() {
      pickedImage = newImage;
    });
  }

  void setText(String newText) {
    setState(() {
      identifiedText = newText;
    });
  }

  ///This Method uses the Firebase Vision API and text recognizer to find the words in the image
  static Future<String> recognizeText(File imageFile) async {
    if (imageFile == null) {
      return 'No selected image';
    } else {
      final visionImage = FirebaseVisionImage.fromFile(imageFile);
      final textRecognizer = FirebaseVision.instance.textRecognizer();
      try {
        final visionText = await textRecognizer.processImage(visionImage);
        await textRecognizer.close();

        final text = extractText(visionText);
        return text.isEmpty ? 'No text found in the image' : text;
      } catch (error) {
        return error.toString();
      }
    }
  }

  ///This method formats what is seen on the uploaded file
  static extractText(VisionText visionText) {
    String text = '';

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          text = text + word.text + ' ';
        }
        text = text + '\n';
      }
    }

    return text;
  }

  @override
  void initState() {
    super.initState();

    currentIndex = 0;
  }

  changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void transSpanish()
  {
    translator.translate(lang.text, to: 'es')
        .then((output)
    {
      setState(() {
        out = output.text;
      });
      print(out);
    });
  }
  void transFrench()
  {
    translator.translate(lang.text, to: 'fr')
        .then((output)
    {
      setState(() {
        out = output.text;
      });
      print(out);
    });
  }
  void transHindi()
  {
    translator.translate(lang.text, to: 'hi')
        .then((output)
    {
      setState(() {
        out = output.text;
      });
      print(out);
    });
  }

  ///Text to Speech Settings
  speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setVolume(100000.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: (currentIndex == 0)
      ? AppBar(
           title: Text('Home'),
           backgroundColor: Colors.pinkAccent[100],
      )
      : (currentIndex == 1)
          ? AppBar(
          title: Text('Translate'),
          backgroundColor: Colors.pinkAccent[100],
      )
      : (currentIndex == 2)
          ? AppBar(
          title: Text('Text to Speech'),
          backgroundColor: Colors.pinkAccent[100],
      )
      : (currentIndex == 3)
          ? AppBar(
          title: Text('Change the Font'),
          backgroundColor: Colors.pinkAccent[100],
      ): Container ,
      endDrawer: new Drawer(
          child: Column(
            children: [
              Expanded(child: Center(child: buildImage())),
              const SizedBox(height: 16),
              Expanded(child:
                ControlsWidget(
                  onClickedPickImage: pickImage,
                  onClickedScanText: scanText,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child:
                TextAreaWidget(
                  text: identifiedText,
                  onClickedCopy: copyToClipboard,
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BubbleBottomBar(
        opacity: 0.2,
        backgroundColor: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        currentIndex: currentIndex,
        hasInk: true,
        inkColor: Colors.black12,
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        onTap: changePage,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: Colors.pinkAccent[100],
            icon: Icon(Icons.home_outlined, color: Colors.black),
            activeIcon: Icon(Icons.home_outlined, color: Colors.pinkAccent[100]),
            title: Text('Home'),
          ),

          BubbleBottomBarItem(
            backgroundColor: Colors.pinkAccent[100],
            icon: Icon(Icons.g_translate_rounded, color: Colors.black),
            activeIcon: Icon(Icons.g_translate_rounded, color: Colors.pinkAccent[100]),
            title: Text('Translate'),
          ),

          BubbleBottomBarItem(
            backgroundColor: Colors.pinkAccent[100],
            icon: Icon(Icons.speaker_outlined, color: Colors.black),
            activeIcon: Icon(Icons.speaker_outlined, color: Colors.pinkAccent[100]),
            title: Text('Speech'),
          ),

          BubbleBottomBarItem(
            backgroundColor: Colors.pinkAccent[100],
            icon: Icon(Icons.subject_rounded, color: Colors.black),
            activeIcon: Icon(Icons.subject_rounded, color: Colors.pinkAccent[100]),
            title: Text('Font'),
          ),
        ],
      ),
      body: (currentIndex == 0)
              ? SingleChildScrollView(child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                    child: Text(
                      'TextSlate',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 35.0,
                      ),
                    ),
                  ),
                  Center(child: Image(image: AssetImage('images/book.png')),),
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                    child: Text(
                      'An app made to make education more accessible.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Click on one of the tabs at the bottom or click on the camera button to start.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 27.0,
                      ),
                    ),
                  ),
              ],
          ))
          :(currentIndex == 1)
          ? SingleChildScrollView(child: Container(
            child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: lang,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Text'
                        ),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.pinkAccent[75],
                      child: Text("Translate"),            //on press to translate the language using function
                      onPressed: ()
                      {
                        if(language == 'Spanish'){
                          transSpanish();
                        } else if(language == 'French'){
                          transFrench();
                        } else if(language == 'Hindi'){
                          transHindi();
                        }
                      },
                    ),
                    Padding(padding: const EdgeInsets.all(8.0),
                      child: Text(out.toString(),
                        style: TextStyle(fontSize: 20.0,
                        ),
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: FloatingActionButton.extended(
                            label: Text('Français'),
                            onPressed: () => language = 'French',
                            backgroundColor: Colors.black26,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: FloatingActionButton.extended(
                            onPressed: () => language = 'Spanish',
                            label: Text('Español'),
                            backgroundColor: Colors.black26,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton.extended(
                            onPressed: () => language = 'Hindi',
                            label: Text('Hindi'),
                            backgroundColor: Colors.black26,
                          ),
                        ),
                      ],
                    )//translated string
                  ],
                )
            ),
          ))
          :(currentIndex == 2)
          ? SingleChildScrollView(child: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Text'
                        ),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.pinkAccent[75],
                      child: Text('Read Aloud'),
                      onPressed: () => speak(textEditingController.text),
                    ),
                    RaisedButton(
                      color: Colors.pinkAccent[75],
                      child: Text('Stop'),
                      onPressed: () => flutterTts.stop(),
                    )
                  ],
                ),
              )
            ))
          :(currentIndex == 3)
          ? SingleChildScrollView(child: Container(
              child: Center(
                  child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: lang2,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter Text'
                              ),
                            ),
                        ),
                        RaisedButton(
                          color: Colors.pinkAccent[75],
                          child: Text("Change Font"),
                          onPressed: (){
                            setState(() {
                              dyslexiaText = lang2.text;
                            });
                          },
                        ),
                        Text(dyslexiaText,
                          style: TextStyle(fontFamily: 'OpenDyslexic',
                            fontSize: 20.0,
                          ),
                        )
                    ],
                  ),
                ))
            ): Container ,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _scaffoldKey.currentState.openEndDrawer();
        },
        child: new Icon(Icons.camera_alt_outlined),
        backgroundColor: Colors.pinkAccent[100],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget buildImage() => Container(
    child: pickedImage != null
        ? Image.file(pickedImage)
        : Icon(Icons.photo, size: 80, color: Colors.black),
  );

}
