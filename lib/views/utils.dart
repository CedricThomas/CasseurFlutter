import 'package:flutter/material.dart';

void hardNavigate(BuildContext context, Widget view) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder<Widget>(
      pageBuilder: (BuildContext context, Animation<double> animation1,
          Animation<double> animation2) =>
      view,
      transitionDuration: const Duration(seconds: 0),
    ),
  );
}