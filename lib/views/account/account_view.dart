import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_workouts/model/user_model.dart';
import 'package:home_workouts/service/auth_service.dart';
import 'package:home_workouts/service/service.dart';
import 'package:home_workouts/views/shared/buttons/danger_button.dart';
import 'package:home_workouts/views/shared/padding.dart';
import 'package:home_workouts/views/shared/scroll_behavior.dart';
import 'package:home_workouts/views/shared/text/headings.dart';
import 'package:home_workouts/views/shared/text/title.dart';
import 'package:home_workouts/views/shared/white_app_bar.dart';
import 'package:home_workouts/views/shared/whitespace.dart';

class AccountView extends StatefulWidget {
  @override
  _AccountViewState createState() => _AccountViewState();
}

final AuthService _authService = AuthService();
AppService service = AppService();

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WhiteAppBar(),
      body: StreamBuilder<Object>(
        stream: service.userStream,
        builder: (context, snapshot) {
          return _buildAccountViewBody(snapshot.data);
        },
      ),
    );
  }

  Widget _buildAccountViewBody(User user) {
    // Null check
    if (user == null) {
      return Container();
    }
    var accountBodyView = List<Widget>();
    accountBodyView.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.account_circle,
              size: 64,
            ),
          ),
          TitleText(user.username ?? "")
        ],
      ),
    ));
    accountBodyView.add(
      Divider(
        height: 32,
      ),
    );

    // Change username section
    accountBodyView.add(InkWell(
      enableFeedback: true,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.alternate_email, size: 32),
          ),
          Body("Change username")
        ],
      ),
    ));
    accountBodyView.add(Divider(
      height: 32,
    ));

    // Modify password section
    accountBodyView.add(InkWell(
      enableFeedback: true,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.lock_outline, size: 32),
          ),
          Body("Change Password")
        ],
      ),
    ));
    accountBodyView.add(Divider(
      height: 32,
    ));
    accountBodyView.add(WhiteSpace());
    accountBodyView.add(
      DangerButton(
        'Logout',
        () async {
          await _authService.signOut();
        },
      ),
    );
    return Container(
      padding: containerPadding,
      child: Column(
        children: accountBodyView,
      ),
    );
  }
}
