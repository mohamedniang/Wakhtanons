import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuildComposer extends StatefulWidget {
  BuildComposer({this.doc, this.type = 0, this.from});

  final DocumentReference doc;
  final DocumentSnapshot from;
  final int type;

  @override
  _BuildComposerState createState() => _BuildComposerState();
}

class _BuildComposerState extends State<BuildComposer> {
  final TextEditingController _textController = TextEditingController();

  bool _isWritting = false;

  void _submitMessage(String txt, DocumentReference document) {
    print('_submitmessage called');
    _textController.clear();
    _textController.clearComposing();
    setState(() {
      print('Inside set state () ');
      _isWritting = false;
      if (widget.type == 0) {
        print('message type 0 ');
        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(document, {
            'content': txt,
            'from': widget.from.data['pseudo'].toString(),
            'timestamp': DateTime.now().millisecondsSinceEpoch
          });
        });
      } else if (widget.type == 1) {
        print('message type 1 ');
        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(document, {
            'txt': txt,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'from': widget.from.data['pseudo'].toString()
          });
        });
      }
      print('last line set state () ');
    });
    print('out side set state () ');
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 9.0,
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                maxLines: 2,
                controller: _textController,
                onChanged: (String txt) {
                  setState(() {
                    _isWritting = txt.length > 0;
                  });
                },
                onSubmitted: (input) =>
                    _submitMessage(_textController.text, widget.doc),
                decoration: InputDecoration.collapsed(
                  hintText: "Entrez votre message ici",
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 3.0,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                  ),
                  onPressed: () {
                    if (_isWritting) {
                      return _submitMessage(_textController.text, widget.doc);
                    } else {
                      return null;
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }
}
