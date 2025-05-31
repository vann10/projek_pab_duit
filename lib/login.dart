// login.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_bloc.dart';
import 'login_portrait.dart';
import 'login_landscape.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _loginBloc.close();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _loginBloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.enteredPin.length == 4 &&
              !state.isPinWrong &&
              !state.isLoading &&
              state.enteredPin == '1234') {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  isLandscape
                      ? const LoginLandscape(key: ValueKey('landscape'))
                      : const LoginPortrait(key: ValueKey('portrait')),
            );
          },
        ),
      ),
    );
  }
}
