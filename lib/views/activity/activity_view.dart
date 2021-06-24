import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_workouts/helpers/date_time_helper.dart';

import 'package:home_workouts/service/service.dart';
import 'package:home_workouts/views/exercise/exercise_view.dart';

import 'package:home_workouts/views/shared/scroll_behavior.dart';

import 'package:home_workouts/model/exercise_model.dart';
import 'package:home_workouts/views/shared/padding.dart';
import 'package:home_workouts/views/shared/whitespace.dart';

class ActivityView extends StatefulWidget {
  final AppService service;
  ActivityView({required this.service});

  @override
  _ActivityViewState createState() => _ActivityViewState(service);
}

class _ActivityViewState extends State<ActivityView> {
  _ActivityViewState(this.service);
  AppService service;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: service.exerciseDataStream,
      builder: (context, snapshot) {
        return _buildActivityBody(snapshot.data as List<Exercise>?);
      },
    );
  }

  Widget _buildActivityBody(List<Exercise>? data) {
    if (data == null || data.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 1,
            child: Text(
              "You have no activity! \n WTF bro! STOP SLACKING! START GRINDING!",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }
    // Generate list of cards
    List<Widget> activityViewBody = [];
    DateTime? currDay = DateTime(0, 0, 0, 0);
    for (var exercise in data) {
      if (!isSameDay(currDay!, exercise.createDate!)) {
        activityViewBody.add(
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              toPrettyString(exercise.createDate!),
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        );
        currDay = exercise.createDate;
      }
      activityViewBody.add(Container(
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.of(this.context)
                .push(MaterialPageRoute(builder: (context) {
              return ExerciseView(
                service: service,
                exercise: exercise,
              );
            }));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(
                thickness: 0.75,
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  exercise.type!,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  exercise.getDisplayAmount(),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          ),
        ),
      ));
    }

    activityViewBody.add(SizedBox(
      height: 128,
    ));

    // Return in Listview
    return ScrollConfiguration(
      behavior: BasicScrollBehaviour(),
      child: ListView(
        padding: containerPadding,
        children: activityViewBody,
      ),
    );
  }
}
