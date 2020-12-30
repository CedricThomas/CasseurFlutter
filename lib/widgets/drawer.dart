import 'package:casseurflutter/redux/state.dart';
import 'package:casseurflutter/views/Logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../views/Login.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) {
        return store.state;
      },
      builder: (context, state) {
        List<Widget> menu = [];
        if (state.isAuthenticated) {
          menu.add(
            ListTile(
              onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Logout(),
                transitionDuration: Duration(seconds: 0),
              ),),
              title: Text("Logout"),
              trailing: Icon(Icons.logout),
            ),
          );
        } else {
          menu.add(
            ListTile(
              onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Login(),
                transitionDuration: Duration(seconds: 0),
              ),),
              title: Text("Login"),
              trailing: Icon(Icons.login),
            ),
          );
        }
        return ListView(
          children: [
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
