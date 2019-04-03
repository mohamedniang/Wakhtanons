import 'package:flutter/material.dart';

class Msg extends StatelessWidget {
  Msg({this.txt, this.animationController, this.sender, this.isRight});
  final String sender;
  final bool isRight;
  final String txt;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: TextStyle(fontSize: 17.0, color: Colors.black),
        child: isRight ? _msgRight(context) : _msgLeft(context));
  }

  Widget _msgRight(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(maxWidth: 280.0),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          // width: 280.0,
          // height: 500.0,
          decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                "${this.sender}",
                style: Theme.of(context).textTheme.headline,
              ),
              Container(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 0.0,
                  ),
                  child: Text(
                    txt,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Padding(
        CircleAvatar(
          child: Text('${this.sender[0].toUpperCase()}'),
        ),
        //   padding: EdgeInsets.all(5.0),
        // ),
      ],
    );
  }

  Widget _msgLeft(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.grey,
          child: Text(
            '${this.sender[0].toUpperCase()}',
            style: TextStyle(
              color: Colors.white
              ),
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 280.0),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          // width: 280.0,
          // height: 500.0,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${this.sender}",
                style: Theme.of(context).textTheme.headline,
              ),
              Container(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 0.0,
                  ),
                  child: Text(
                    txt,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.all(5.0),
        // ),
      ],
    );
  }
}
