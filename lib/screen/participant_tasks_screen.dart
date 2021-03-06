import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:score_system/component/pie_diagram.dart';
import 'package:score_system/model/person.dart';
import 'package:score_system/model/task.dart';
import 'package:score_system/screen/menu/bottom_menu.dart';
import 'package:score_system/service/person_service.dart';
import 'package:score_system/util/date_util.dart';
import 'package:score_system/vocabulary/constant.dart';
import 'package:tuple/tuple.dart';

import '../main.dart';

class ParticipantTasksArguments {
  final Person _person;
  ParticipantTasksArguments(this._person);
}

class ParticipantTasksPage extends StatefulWidget {

  final String participantsTitle = "Задачи участника";
  static final String ROUTE_NAME = '/participant_tasks';

  const ParticipantTasksPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ParticipantTasksPageState();
  }

}

class ParticipantTasksPageState extends State<ParticipantTasksPage> {
  late final Person _person;
  late final PersonTaskProgress _personProgress;
  late final Map<TaskIdActivity, Tuple4<int, int, int, int>> _personByTasksProgress;
  int selectedIndex = 0;
  Map<String, TaskStatus?> taskStatusVal = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ParticipantTasksArguments;
    _person = args._person;
    DateTime dt = DateTime.now();
    _personProgress = getIt<PersonService>().getPersonProgressByDateInterval(_person, dt.subtract(Duration(days:1)), dt.add(Duration(days: 1)));
    _personByTasksProgress = getIt<PersonService>().getActualPersonProgressByDate(_person, dt);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Text(
            _person.fio(),
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
      body:
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child:
                Row(
                  mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      // alignment: Alignment.center,
                      child:
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child:
                          _person.avaPath != null ?
                          Image.asset(
                            _person.avaPath!,
                          ) : Icon(Icons.person, color: Theme.of(context).colorScheme.primary)
                        ),
                        radius: 52,
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 3,
                        // alignment: Alignment.center,
                        // padding: EdgeInsets.only(bottom: 25, left: 20, right: 20),
                        child: Container(
                          // padding: EdgeInsets.only(left: 30),
                          alignment: Alignment.center,
                          child:
                          Text(
                            getIt<DateUtil>().getDateNowInStr(),
                            style: TextStyle(
                              fontSize: 26,
                              fontFamily: FONT_FAMILY_SECOND,
                            ),
                          ),
                        )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TaskStatPie(
                          dataMap: {
                            "Провалено" : _personProgress.failProgress as double,
                            "Успешно" : _personProgress.successProgress as double,
                            "Осталось" : (_personProgress.allProgress - _personProgress.successProgress - _personProgress.failProgress) as double
                          },
                          title: "${_personProgress.successProgress} из ${_personProgress.allProgress}",
                          colorList: taskPieColorList
                      ),
                    ),
                  ],
                ),
            ),
            Expanded(child:
              ListView(
                children:
                _personByTasksProgress.entries.map((entry) =>
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          // alignment: Alignment.center,
                          child:
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              // alignment: Alignment.center,
                              child:
                                entry.key.activity.avaPath != null ?
                                Image.asset(
                                  entry.key.activity.avaPath!,
                                  color: Theme.of(context).colorScheme.primary,
                                ) : Icon(Icons.description, color: Theme.of(context).colorScheme.primary)
                            )
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Container(
                              alignment: Alignment.center,
                              child:
                              Text(
                                entry.key.activity.name!,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontFamily: FONT_FAMILY_SECOND,
                                ),
                              ),
                            )
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child:
                            Column(
                              children: List.generate(entry.value.item1,
                                (index) => Container(
                                    child: Row(
                                      children:[
                                        RadioListTile<TaskStatus>(
                                          title: Text(TaskStatus.NONE.name),
                                          value: TaskStatus.NONE,
                                          groupValue: taskStatusVal['${entry.key.taskId}_$index'],
                                          onChanged: (TaskStatus? value) {
                                            setState(() {
                                              taskStatusVal['${entry.key.taskId}_$index'] = value;
                                              recalc(entry.key.taskId, value!);
                                            });
                                          },
                                        ),
                                        RadioListTile<TaskStatus>(
                                          title: Text(TaskStatus.DONE.name),
                                          value: TaskStatus.DONE,
                                          groupValue: taskStatusVal['${entry.key.taskId}_$index'],
                                          onChanged: (TaskStatus? value) {
                                            setState(() {
                                              taskStatusVal['${entry.key.taskId}_$index'] = value;
                                              recalc(entry.key.taskId, value!);
                                            });
                                          },
                                        ),
                                        RadioListTile<TaskStatus>(
                                          title: Text(TaskStatus.ILL.name),
                                          value: TaskStatus.ILL,
                                          groupValue: taskStatusVal['${entry.key.taskId}_$index'],
                                          onChanged: (TaskStatus? value) {
                                            setState(() {
                                              taskStatusVal['${entry.key.taskId}_$index'] = value;
                                              recalc(entry.key.taskId, value!);
                                            });
                                          },
                                        ),
                                        RadioListTile<TaskStatus>(
                                          title: Text(TaskStatus.OTHER.name),
                                          value: TaskStatus.ILL,
                                          groupValue: taskStatusVal['${entry.key.taskId}_$index'],
                                          onChanged: (TaskStatus? value) {
                                            setState(() {
                                              taskStatusVal['${entry.key.taskId}_$index'] = value;
                                              recalc(entry.key.taskId, value!);
                                            });
                                          },
                                        ),
                                      ]
                                    )
                                )
                              )
                            )
                        )
                      ]
                    )).toList(),
              )
            ),
          ]
        ),
            // );
          // }),
      bottomNavigationBar: MainBottomNavigationBar(context, selectedIndex),
    );

  }

  void recalc(int taskId, TaskStatus status) {
    if st
  }

}