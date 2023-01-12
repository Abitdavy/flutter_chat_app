// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:chat_app/widgets/img_pickers/img_pickers.dart';
import 'package:flutter/material.dart';

class AuthScreenWidget extends StatefulWidget {
  final Function(
    String email,
    String username,
    String password,
    bool isLogin,
    File pickedImage,
  ) submitForm;

  AuthScreenWidget(this.submitForm);

  @override
  State<AuthScreenWidget> createState() => _AuthScreenWidgetState();
}

class _AuthScreenWidgetState extends State<AuthScreenWidget> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _showSpinner = false;
  String? _userEmail = '';
  String? _userName = '';
  String? _userPassword = '';
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _showSpinner = true;
      });
      await widget.submitForm(
        _userEmail!.trim(),
        _userPassword!.trim(),
        _userName!.trim(),
        _isLogin,
        _userImageFile!,
      );
      setState(() {
        _showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 76, 68, 220).withOpacity(0.5),
                const Color.fromARGB(255, 157, 200, 179).withOpacity(0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Center(
          child: AnimatedSize(
            //curve: Curves.easeInOut,
            duration: Duration(milliseconds: 300),
            child: Card(
              margin: const EdgeInsets.all(20),
              elevation: 8,
              child: _showSpinner
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!_isLogin) ImgPicker(_pickedImage),
                              TextFormField(
                                key: ValueKey('Email'),
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Email Address',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _userEmail = value;
                                },
                              ),
                              if (!_isLogin)
                                TextFormField(
                                  key: ValueKey('Username'),
                                  decoration: const InputDecoration(
                                      labelText: 'Username'),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 4) {
                                      return 'Username must be more than 4 characters';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _userName = value;
                                  },
                                ),
                              TextFormField(
                                key: ValueKey('Password'),
                                decoration: const InputDecoration(
                                    labelText: 'password'),
                                obscureText: true,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 7) {
                                    return 'Password must be more than 7 characters';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _userPassword = value;
                                },
                                onSaved: (value) {
                                  _userPassword = value;
                                },
                              ),
                              if (!_isLogin)
                                TextFormField(
                                  key: ValueKey('Confirm Password'),
                                  decoration: const InputDecoration(
                                      labelText: 'confirm password'),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value != _userPassword ||
                                        value!.isEmpty) {
                                      return 'password doesnt match';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _userPassword = value;
                                  },
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: _trySubmit,
                                child: Text(_isLogin ? 'Login' : 'Signup'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin
                                    ? 'Create new account'
                                    : 'Already have account? Login'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
