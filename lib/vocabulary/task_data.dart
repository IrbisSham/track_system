import 'package:score_system/model/activity.dart';
import 'package:score_system/model/person.dart';
import 'package:score_system/model/schedule.dart';
import 'package:score_system/model/task.dart';
import 'package:score_system/vocabulary/abstract_list_voc.dart';
import 'package:score_system/vocabulary/constant.dart';

class TaskPlanData extends EntitiesData<TaskPlan>{

  TaskPlanData() :
        super(isDbMode: IS_DB_MODE);

  @override
  List<TaskPlan> getDbData() {
    // TODO: Imlement db query
    // TODO: implement getDbData
    throw UnimplementedError();
  }

  @override
  List<TaskPlan> getLocalData() {
    return [
      TaskPlan(
        id: 1,
        sum: 2,
        activity: Activity(
          id: 14,
          name: 'Сделать зарядку',
          sum: 2,
          avaPath: ACT_PATH + 'gym.png',
        ),
        schedule: [
          Schedule(
            id: 1,
            date: DateTime(2022, 2, 5),
          ),
          Schedule(
            id: 2,
            date: DateTime(2022, 2, 8),
          ),
          Schedule(
            id: 3,
            date: DateTime(2022, 2, 9),
          ),
        ],
        person: Person(
          id: 1,
          name: 'Виталий',
          family: 'Ермилов',
          secName: 'Юрьевич',
          avaPath: AVA_PATH + "Vitaliy.png",
        ),
      ),
      TaskPlan(
        id: 2,
        sum: 3,
        activity: Activity(
          id: 15,
          name: 'Протереть мебель',
          avaPath: ACT_PATH + 'dusting_furniture.png',
          sum: 3,
        ),
        schedule: [
          Schedule(
            id: 4,
            date: DateTime(2022, 2, 4),
          ),
          Schedule(
            id: 2,
            date: DateTime(2022, 2, 2),
          ),
        ],
        person: Person(
          id: 3,
          name: 'Елизавета',
          family: 'Ермилова',
          secName: 'Витальевна',
          avaPath: AVA_PATH + "Liza.png",
        ),
      ),
      TaskPlan(
        id: 3,
        sum: 4,
        activity: Activity(
          id: 16,
          name: 'Глажка',
          avaPath: ACT_PATH + 'ironing.png',
          sum: 4,
        ),
        person: Person(
          id: 2,
          name: 'Екатерина',
          family: 'Ермилова',
          secName: 'Евгеньевна',
          avaPath: AVA_PATH + "Kate.png",
        ),
        schedule: [
          Schedule(
            id: 5,
            date: DateTime(2022, 2, 5),
          ),
        ],
      ),
      TaskPlan(
        id: 4,
        sum: 1,
        activity: Activity(
          id: 17,
          name: 'Заправить кровать',
          avaPath: ACT_PATH + 'bed_make.png',
          sum: 1,
        ),
        person: Person(
          id: 1,
          name: 'Виталий',
          family: 'Ермилов',
          secName: 'Юрьевич',
          avaPath: AVA_PATH + "Vitaliy.png",
        ),
        schedule: [
          Schedule(
            id: 4,
            date: DateTime(2022, 2, 4),
          ),
          Schedule(
            id: 2,
            date: DateTime(2022, 2, 2),
          ),
        ],
      ),
      TaskPlan(
        id: 5,
        sum: 2,
        activity: Activity(
          id: 18,
          name: 'Вынести мусор',
          avaPath: ACT_PATH + 'garbage_out.png',
          sum: 2,
        ),
        person: Person(
          id: 4,
          name: 'Ксения',
          family: 'Ермилова',
          secName: 'Витальевна',
          avaPath: AVA_PATH + "Ksenia.png",
        ),
        schedule: [
          Schedule(
            id: 4,
            date: DateTime(2022, 2, 4),
          ),
          Schedule(
            id: 2,
            date: DateTime(2022, 2, 2),
          ),
        ],
      ),
      TaskPlan(
        id: 6,
        sum: 4,
        activity: Activity(
          id: 19,
          name: 'Приготовить еду',
          avaPath: ACT_PATH + 'cooking.png',
          sum: 4,
        ),
        person: Person(
          id: 5,
          name: 'Полина',
          family: 'Ермилова',
          secName: 'Витальевна',
          avaPath: AVA_PATH + "Polya.png",
        ),
        schedule: [
          Schedule(
            id: 4,
            date: DateTime(2022, 2, 4),
          ),
          Schedule(
            id: 2,
            date: DateTime(2022, 2, 2),
          ),
        ],
      ),
    ];
  }

}

class TaskFactData extends EntitiesData<TaskFact>{

  TaskFactData() :
        super(isDbMode: IS_DB_MODE);

  @override
  List<TaskFact> getDbData() {
    // TODO: Imlement db query
    // TODO: implement getDbData
    throw UnimplementedError();
  }

  @override
  List<TaskFact> getLocalData() {
    return [
      TaskFact(
        id: 1,
        taskPlan: TaskPlan(
          id: 1,
          activity: Activity(
            id: 14,
            name: 'Сделать зарядку',
            sum: 2,
            avaPath: ACT_PATH + 'gym.png',
          ),
          schedule: [
            Schedule(
              id: 1,
              date: DateTime(2022, 2, 5),
            ),
            Schedule(
              id: 2,
              date: DateTime(2022, 2, 6),
            ),
            Schedule(
              id: 3,
              date: DateTime(2022, 2, 8),
            ),
          ],
        ),
        person: Person(
          id: 1,
          name: 'Виталий',
          family: 'Ермилов',
          secName: 'Юрьевич',
          avaPath: AVA_PATH + "Vitaliy.png",
        ),
        schedule: DateTime(2022, 2, 2),
      ),
      TaskFact(
        id: 2,
        taskPlan: TaskPlan(
          id: 4,
          activity: Activity(
            id: 17,
            name: 'Заправить кровать',
            avaPath: ACT_PATH + 'bed_make.png',
            sum: 2,
          ),
          schedule: [
            Schedule(
              id: 1,
              date: DateTime(2022, 2, 2),
            ),
            Schedule(
              id: 2,
              date: DateTime(2022, 2, 4),
            ),
          ],
        ),
        person: Person(
          id: 1,
          name: 'Виталий',
          family: 'Ермилов',
          secName: 'Юрьевич',
          avaPath: AVA_PATH + "Vitaliy.png",
        ),
        schedule: DateTime(2022, 2, 3),
      ),
      TaskFact(
        id: 3,
        taskPlan: TaskPlan(
          id: 3,
          activity: Activity(
            id: 16,
            name: 'Глажка',
            avaPath: ACT_PATH + 'ironing.png',
            sum: 2,
          ),
          person: Person(
            id: 2,
            name: 'Екатерина',
            family: 'Ермилова',
            secName: 'Евгеньевна',
            avaPath: AVA_PATH + "Kate.png",
          ),
          schedule: [
            Schedule(
              id: 5,
              date: DateTime(2022, 2, 5),
            ),
          ],
        ),
        person: Person(
          id: 2,
          name: 'Екатерина',
          family: 'Ермилова',
          secName: 'Евгеньевна',
          avaPath: AVA_PATH + "Kate.png",
        ),
        schedule: DateTime(2022, 2, 4),
      ),
      TaskFact(
        id: 4,
        taskPlan: TaskPlan(
          id: 2,
          activity: Activity(
            id: 15,
            name: 'Протереть мебель',
            avaPath: ACT_PATH + 'dusting_furniture.png',
            sum: 2,
          ),
          schedule: [
            Schedule(
              id: 4,
              date: DateTime(2022, 2, 4),
            ),
            Schedule(
              id: 2,
              date: DateTime(2022, 2, 2),
            ),
          ],
          person: Person(
            id: 3,
            name: 'Елизавета',
            family: 'Ермилова',
            secName: 'Витальевна',
            avaPath: AVA_PATH + "Liza.png",
          ),
        ),
        person: Person(
          id: 1,
          name: 'Виталий',
          family: 'Ермилов',
          secName: 'Юрьевич',
          avaPath: AVA_PATH + "Vitaliy.png",
        ),
        schedule: DateTime(2022, 2, 4),
      ),
    ];
  }

}