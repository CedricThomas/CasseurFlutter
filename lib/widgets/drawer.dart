import 'package:casseurflutter/redux/state.dart';
import 'package:casseurflutter/views/Logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../views/Login.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) {
        return store.state;
      },
      builder: (BuildContext context, AppState state) {
        final List<Widget> menu = <Widget>[];
        if (state.isAuthenticated) {
          menu.add(
            ListTile(
              onTap: () => Navigator.pushReplacement(context, PageRouteBuilder<Logout>(
                pageBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2) => Logout(),
                transitionDuration: const Duration(seconds: 0),
              ),),
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
            ),
          );
        } else {
          menu.add(
            ListTile(
              onTap: () => Navigator.pushReplacement(context, PageRouteBuilder<Login>(
                pageBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2) => Login(),
                transitionDuration: const Duration(seconds: 0),
              ),),
              title: const Text('Login'),
              trailing: const Icon(Icons.login),
            ),
          );
        }
        return ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(state.isAuthenticated ? state.profile.name : ''),
              accountEmail: Text(state.isAuthenticated ? state.profile.email : ''),
              currentAccountPicture: state.isAuthenticated
                  ? Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(state.profile.avatar),
                          )),
                    )
                  : null,
            ),
            ...menu,
          ],
        );
      },
    );
  }
}
