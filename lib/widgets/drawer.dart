import 'package:casseurflutter/blocs/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../views/Login.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (BuildContext context, AuthenticationState state) {
      final List<Widget> menu = <Widget>[];
      if (state is AuthenticationAuthenticated) {
        menu.add(
          ListTile(
            onTap: () {},
            title: const Text('Logout'),
            trailing: const Icon(Icons.logout),
          ),
        );
      } else {
        menu.add(
          ListTile(
            onTap: () => Navigator.pushReplacement(
              context,
              PageRouteBuilder<Login>(
                pageBuilder: (BuildContext context,
                        Animation<double> animation1,
                        Animation<double> animation2) =>
                    Login(),
                transitionDuration: const Duration(seconds: 0),
              ),
            ),
            title: const Text('Login'),
            trailing: const Icon(Icons.login),
          ),
        );
      }
      return ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
                state is AuthenticationAuthenticated ? state.user.name : ''),
            accountEmail: Text(
                state is AuthenticationAuthenticated ? state.user.name : ''),
            currentAccountPicture: state is AuthenticationAuthenticated
                ? Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(state.user.avatar),
                        )),
                  )
                : null,
          ),
          ...menu,
        ],
      );
    });
  }
}
