import 'package:casseurflutter/blocs/authentication/authentication.dart';
import 'package:casseurflutter/views/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationEnforcer extends StatefulWidget {
  const AuthenticationEnforcer(
      {@required this.child, @required this.authenticationBloc});

  final Widget child;
  final AuthenticationBloc authenticationBloc;

  @override
  _AuthenticationEnforcerState createState() => _AuthenticationEnforcerState();
}

class _AuthenticationEnforcerState extends State<AuthenticationEnforcer> {
  @override
  void initState() {
    if (widget.authenticationBloc.state is AuthenticationNotAuthenticated) {
      Get.off<Login>(Login());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) {
        if (state is AuthenticationNotAuthenticated) {
          Get.off<Login>(Login());
        }
      },
      child: widget.child,
    );
  }
}
