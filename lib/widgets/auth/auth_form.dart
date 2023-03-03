import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_againapp1/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn,this.isLoading);
  final bool isLoading;
  final void Function(String email, String password, String userName,File image,
      bool islogin, BuildContext ctx) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _islogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  File _userimagefile;

  void _pickedImage(File image){
    _userimagefile=image;

  }

  void _trysubmit() {
    final isvalid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(_userimagefile==null && !_islogin){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('please pick an image'),
      backgroundColor: Theme.of(context).errorColor,
      ),
      );
      return;
    }
    if (isvalid) {
      _formkey.currentState.save();
      widget.submitFn(
          _userEmail.trim(), _userName, _userPassword,_userimagefile, _islogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_islogin) userimagepicker(_pickedImage),
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                      ),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    if (!_islogin)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'Please enter atleast 4 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Username'),
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password is not long enough';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                    SizedBox(height: 12),
                    if(widget.isLoading) CircularProgressIndicator(),
                    if(!widget.isLoading)
                      ElevatedButton(
                        onPressed: _trysubmit,
                        child: Text(_islogin ? 'Login' : 'signUp')),
                    if(!widget.isLoading)
                      TextButton(
                      child: Text(_islogin
                          ? 'Create a new account'
                          : 'I already have an account'),
                      onPressed: () {
                        setState(() {
                          _islogin = !_islogin;
                        });
                      },
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}