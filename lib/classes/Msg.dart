import 'package:flutter/material.dart';

class Msg extends StatelessWidget {
  Msg({this.txt, this.animationController});
  final String txt;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: 165.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Souhaibou",
                  style: Theme.of(context).textTheme.subhead,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 0.0,
                    ),
                    child: Text(txt),
                  ),
                ],

              ),
            ),
            Expanded(
              child:CircleAvatar(
                child: Text("S"),
              ), 

            ),
          ],
        ),
      ),
    );
  }
}