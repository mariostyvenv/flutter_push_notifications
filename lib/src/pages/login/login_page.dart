import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harxz/src/blocs/push_notification/push_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    final pushBloc = BlocProvider.of<PushBloc>(context);
    pushBloc.add(GetNotifications());

    return Scaffold(
      body: BlocBuilder<PushBloc, PushState>(
        builder: (BuildContext context, PushState state) {
          return Center(
            child: Text(state.title)
          );
        },
      ),
    );
  }

}
