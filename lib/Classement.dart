import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class Classement extends StatefulWidget {
  final DocumentSnapshot currentUser;
  Classement(this.currentUser);
  @override
  State<StatefulWidget> createState() {
    return _ClassementState();
  }
}

class _ClassementState extends State<Classement>
    with SingleTickerProviderStateMixin {
  List<String> filesNames = <String>[
    'profilPhotos/Girl1.jpg',
    'profilPhotos/Girl2.jpg',
    'profilPhotos/Girl3.jpg',
  ];

  String _path;
  File cachedFile;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('ladder').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ));
        return ListView.builder(
          // itemExtent: 80.0,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) =>
              _buildCandidat(context, snapshot.data.documents[index], index),
        );
      },
    );
  }

  Widget _buildCandidat(
      BuildContext ctx, DocumentSnapshot document, int index) {
    return Container(
        width: 350.0,
        child: GestureDetector(
          onTap: () => _uploadFile(filesNames[index]),
          child: Column(
            children: <Widget>[
              Image.asset(
                filesNames[index],
                fit: BoxFit.scaleDown,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton.icon(
                    icon: Icon(Icons.thumb_up),
                    label: Text("${document.data['like']}"),
                    onPressed: () => _liked(document),
                  ),
                  RaisedButton.icon(
                    icon: Icon(Icons.thumb_down),
                    label: Text("${document.data['dislike']}"),
                    onPressed: () => _disliked(document),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  _liked(DocumentSnapshot document) async {
    var res = Firestore.instance.collection('ladder').document('alreadyVoted');
    if (res != null) {
      print(res.path);
    } else {
      print("nothing");
    }
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot nouveauSnap = await transaction.get(document.reference);
      await transaction
          .update(nouveauSnap.reference, {'like': nouveauSnap['like'] + 1});
    });
  }

  _disliked(DocumentSnapshot document) {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot nouveauSnap = await transaction.get(document.reference);
      await transaction.update(
          nouveauSnap.reference, {'dislike': nouveauSnap['dislike'] + 1});
    });
  }

  Future<Null> _uploadFile(String filepath) async {
    final ByteData bytes = await rootBundle.load(filepath);
    final Directory tempDir = Directory.systemTemp;
    final String fileName = "${Random().nextInt(10000)}.jpg";
    final File file = File('${tempDir.path}/$fileName');
    file.writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write);

    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask task = ref.putFile(file);
    final Uri downloadUrl = (await task.onComplete).uploadSessionUri;
    _path = downloadUrl.toString();

    print(_path);
  }

  Future<Null> downloadFile(String httpPath) async {
    final RegExp regExp = RegExp('([^?/]*\.(jpg))');
    final String fileName = regExp.stringMatch(httpPath);
    final Directory tempDir = Directory.systemTemp;
    final File file = File('${tempDir.path}/$fileName');

    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    final StorageFileDownloadTask downloadTask = ref.writeToFile(file);

    final int byteNumber = (await downloadTask.future).totalByteCount;

    print(byteNumber);

    setState(() => cachedFile = file);
  }
}
