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
        decoration: BoxDecoration(
          color: Colors.blueAccent[100],
          borderRadius: BorderRadius.circular(25.0),
        ),
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.symmetric(
          vertical: 5.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                // decoration: BoxDecoration(
                //   border: Border.all()
                // ),
                // margin: EdgeInsets.all(
                //   1.0,
                // ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Souhaibou",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    Container(
                      // margin: EdgeInsets.only(
                      //   top: 0.0,
                      // ),
                      child: Text(txt),
                    ),
                  ],
                ),
              ),
            ),
            CircleAvatar(
              child: Text("S"),
            ),
          ],
        ),
      ),
    );
  }
}
