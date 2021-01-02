import 'package:flutter/material.dart';

import 'menu.dart';

class DefaultDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: DrawerMenu(),
    );
  }
}
