import 'package:flutter/material.dart';

///Code created by following tutorial: https://www.youtube.com/watch?v=TNKtGOZRA5o
///Creates the formatting for the Text Recognizer
class TextAreaWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClickedCopy;

  const TextAreaWidget({
    @required this.text,
    @required this.onClickedCopy,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Container(
          height: 100,
          decoration: BoxDecoration(border: Border.all()),
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: SelectableText(
            text.isEmpty ? 'Scan an Image to get text' : text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(child:
      IconButton(
        icon: Icon(Icons.copy, color: Colors.black),
        color: Colors.black12,
        onPressed: onClickedCopy,
      ),
      ),
    ],
  );
}