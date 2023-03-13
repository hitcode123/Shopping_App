// ignore_for_file: prefer_const_constructors

import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0, 1]),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: Container(
                    margin: EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 94.0,
                    ),
                    transform: Matrix4.rotationZ(-8 * pi / 100)
                      ..translate(-10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // ignore: prefer_const_literals_to_create_immutables
                        color: Colors.deepOrange.shade900,
                        // ignore: prefer_const_literals_to_create_immutables
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ]),
                    child: Text(
                      'MyShop',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.titleMedium?.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal),
                    ),
                  )),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  )
                ]),
          ),
        )
      ]),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authmode = AuthMode.Login;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();

  void submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_authmode == AuthMode.Login) {
      // log user in
    } else {
      // sign user up
    }

    setState(() {
      _isLoading = true;
    });
  }

  void _switchAuthMode() {
    if (_authmode == AuthMode.Login) {
      setState(() {
        _authmode == AuthMode.Signup;
      });
    } else {
      setState(() {
        _authmode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authmode == AuthMode.Signup ? 320 : 260,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                
                TextFormField(
                  decoration: InputDecoration(labelText: 'password'),
                   obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length<5) {
                      return 'passWord is too Short';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                  if(_authmode==AuthMode.Signup)
                  
                       TextFormField(
                        enabled: _authmode==AuthMode.Signup,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: _authmode==AuthMode.Signup?(value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  }:null,
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                if(_isLoading)
                CircularProgressIndicator()
                else 
                ElevatedButton(onPressed: null, child: Text(_authmode==AuthMode.Login?'LOGIN':'SIGN UP')
                 ,style: ButtonStyle
                 (padding:MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal:30.0,vertical: 4
                 )),
                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  ),
                  

                
                 )),
               ,)     
                
              ]),
            )),
      ),
    );
  }
}
