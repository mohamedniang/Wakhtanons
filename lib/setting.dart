import 'dart:io';
// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final DocumentSnapshot user;
  Settings(this.user);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey();
  File _image;

  // String _path;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> _getImage() async {
    // File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    // print("Path of image = " + image.path);

    // // uploading
    // final ByteData bytes = await rootBundle.load(image.path);
    // final Directory tempDir = Directory.systemTemp;
    // final String fileName = "${Random().nextInt(10000)}.jpg";
    // final File file = File('${tempDir.path}/$fileName');
    // file.writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write);

    // final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    // final StorageUploadTask task = ref.putFile(file);
    // final Uri downloadUrl = (await task.onComplete).uploadSessionUri;
    // _path = downloadUrl.toString();

    // print("storage path = " + _path);

    // setState(() {
    //   _image = image;
    // });
  }

  Widget _input({IconData ico, String hintText, String oldValue}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: <Widget>[
          // Icon(ico),
          Expanded(
            child: TextFormField(
              initialValue: "$oldValue",
              style: TextStyle(color: Theme.of(context).accentColor),
              decoration: InputDecoration(
                icon: Icon(ico),
                hintText: "$hintText",
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Setting',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _image == null
                          ? Container(
                              width: 150.0,
                              height: 150.0,
                              color: Colors.black,
                            )
                          : _profilPhoto(),
                      FloatingActionButton(
                        onPressed: () => _getImage(),
                        child: Icon(Icons.camera_alt),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      Expanded(child: Text('Profil')),
                    ],
                  ),
                  _input(
                      ico: Icons.person,
                      hintText: "username",
                      oldValue: widget.user['pseudo'] ?? ""),
                  _input(
                      ico: Icons.lock,
                      hintText: "password",
                      oldValue: widget.user['motdepasse'] ?? ""),
                  _input(
                      ico: Icons.lock_outline,
                      hintText: "repeat password",
                      oldValue: widget.user['motdepasse'] ?? ""),
                  _input(
                      ico: Icons.mail,
                      hintText: "email",
                      oldValue: widget.user['email'] ?? ""),
                  _input(
                      ico: Icons.call,
                      hintText: "tel",
                      oldValue: widget.user['tel'] ?? ""),
                  RaisedButton(
                    child: Text('test'),
                    onPressed: () async {
                      AndroidNotificationDetails and =
                          AndroidNotificationDetails('your channel id',
                              'your channel name', 'your channel description',
                              importance: Importance.Max,
                              priority: Priority.High);
                      var ios = new IOSNotificationDetails();
                      var platformChannelSpecifics =
                          new NotificationDetails(and, ios);
                      await flutterLocalNotificationsPlugin.show(0,
                          'plain title', 'plain body', platformChannelSpecifics,
                          payload: 'item id 2');

                      //

                      // var scheduledNotificationDateTime =
                      //     new DateTime.now().add(new Duration(seconds: 5));
                      // await flutterLocalNotificationsPlugin.schedule(
                      //     0,
                      //     'scheduled title',
                      //     'scheduled body',
                      //     scheduledNotificationDateTime,
                      //     platformChannelSpecifics);
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _profilPhoto() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Image.file(
        _image,
        width: 150.0,
        height: 150.0,
      ),
    );
  }

  Future onSelectNotification(String payload) {
    print('"payload : $payload');
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Notifs'),
              content: Text(payload),
            ));
    return null;
  }
}
