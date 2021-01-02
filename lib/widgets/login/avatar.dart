import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      shape: const CircleBorder(),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Image.asset(
          'assets/icon-dark.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
