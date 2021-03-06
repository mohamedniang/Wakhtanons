import 'package:flutter/material.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './main.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConnectionScreen(),
    );
  }
}

class ConnectionScreen extends StatefulWidget {
  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  final TextEditingController _textControllerPseudo = TextEditingController();

  final TextEditingController _textControllerPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final conxKey = GlobalKey<FormState>();

  String _username, _password;

  bool _isVisible = false;

  FocusNode _leFocus;

  // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  // print('Running on ${androidInfo.model}');

  void _seConnecter(BuildContext ctx) async {
    setState(() {
      _isVisible = true;
      FocusScope.of(ctx).detach();
    });
    if (!conxKey.currentState.validate()) {
      _noInputAlert(ctx);
      setState(() {
        _isVisible = false;
      });
      return;
    }
    conxKey.currentState.save();
    _textControllerPseudo.clear();
    _textControllerPassword.clear();
    final QuerySnapshot result = await Firestore.instance
        .collection('utilisateurs')
        .where('pseudo', isEqualTo: _username)
        .where('motdepasse', isEqualTo: _password)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    print(documents.length);
    if (documents.length == 0) {
      setState(() {
        _isVisible = false;
      });
      Fluttertoast.showToast(
          msg: "Pseudo et/ou mot de pass incorrect",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15.0);
    } else {
      Navigator.push(
          ctx,
          MaterialPageRoute(
            builder: (context) => MyApp(documents[0]),
          ));
    }
    setState(() {
      _isVisible = false;
    });
  }

  Future<void> _noInputAlert(BuildContext ctx) async {
    return showDialog<void>(
      context: ctx,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur lors de la tentative de connection'),
          content: Text('Veillez remplir les champs !'),
          actions: <Widget>[
            FlatButton(
              child: Text('Retour'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _signInDialog(BuildContext ctx) async {
    String _email;
    String _mdp;
    String _pseudo;
    return showDialog<void>(
        context: ctx,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Inscription',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: ListBody(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Pseudo ( nom d\'utilisateur)',
                      ),
                      validator: (input) => !input.contains('') ? '' : null,
                      onSaved: (input) => _pseudo = input,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                      ),
                      validator: (input) => input.length < 8
                          ? 'Le mot de passe doit contenir plus de huit(8) caractère'
                          : null,
                      onSaved: (input) => _mdp = input,
                      obscureText: true,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                      ),
                      validator: (input) => !input.contains('@')
                          ? 'Cette email n\'est pas valid'
                          : null,
                      onSaved: (input) => _email = input,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('s\'inscrire'),
                onPressed: () {
                  if (formKey.currentState.validate())
                    formKey.currentState.save();
                  return _signIn(_pseudo, _mdp, _email, ctx);
                },
              ),
              FlatButton(
                child: Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _signIn(String p, String m, String e, BuildContext ctx) {
    print(p);
    print(m);
    print(e);
    DocumentReference documentReferences =
        Firestore.instance.collection('utilisateurs').document();
    documentReferences.setData({'pseudo': p, 'motdepasse': m, 'email': e});
    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connection',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Connectez vous'),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(15.0),
            height: 250.0,
            child: Form(
              key: conxKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Nom D\'utilisateur'),
                    controller: _textControllerPseudo,
                    validator: (input) =>
                        input == '' ? 'Veiller saisir votre pseudo' : null,
                    onSaved: (input) => _username = input,
                     focusNode: _leFocus,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Mot De Passe'),
                    controller: _textControllerPassword,
                    validator: (input) => input == ''
                        ? 'Veiller saisir votre mot de passe'
                        : null,
                    onSaved: (input) => _password = input,
                    obscureText: true,
                    focusNode: _leFocus,
                  ),
                  Stack(
                    children: <Widget>[
                      RaisedButton(
                        child: Text(
                          'Se Connecter',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed:
                            !_isVisible ? () => _seConnecter(context) : null,
                      ),
                      Positioned(
                        left: 40.0,
                        child: Visibility(
                          visible: _isVisible,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                            // backgroundColor: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text('Toujours pas de compte ?'),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _signInDialog(context),
                            child: Text(
                              'Incrivez-vous.',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 22.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
