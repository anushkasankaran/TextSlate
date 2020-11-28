import 'package:flutter/material.dart';

///Code created by following tutorial: https://www.youtube.com/watch?v=TNKtGOZRA5o
///Creates the buttons needed to pick and scan an image
class ControlsWidget extends StatelessWidget {
  final VoidCallback onClickedPickImage;
  final VoidCallback onClickedScanText;

  const ControlsWidget({
    @required this.onClickedPickImage,
    @required this.onClickedScanText,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(child: RaisedButton(
        onPressed: onClickedPickImage,
        child: Text('Pick Image'),
      ),),
      const SizedBox(width: 12),
      Expanded(child: RaisedButton(
        onPressed: onClickedScanText,
        child: Text('Scan For Text'),
      ),),
      const SizedBox(width: 12),
    ],
  );
}