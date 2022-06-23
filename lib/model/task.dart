import 'package:score_system/model/activity.dart';
import 'package:score_system/model/entity.dart';
import 'package:score_system/model/person.dart';
import 'package:score_system/model/schedule.dart';
import 'package:tuple/tuple.dart';

/// Status: 0 - valid, -1 - invalid
class TaskPlan extends HierarchEntity {
  final Activity activity;
  final List<Schedule> schedule;
  Person? person;
  List<String>? conditions;
  int sum;
  String? reward;

  TaskPlan({required int id, required Activity activity, String? name, String? desc, int status = 0,
    required List<Schedule> schedule, Person? person,
    List<String>? conditions, int sum = 0, String? reward}) :
        this.activity = activity,
        this.schedule = schedule,
        this.person = person,
        this.conditions = conditions,
        this.sum = sum,
        this.reward = reward,
        super(id: id, name: name, desc: desc, status: status);

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic> {
      "id" : id,
      "activity" : activity,
      "status" : status,
      "desc" : desc,
      "schedule" : schedule,
      "person" : person,
      "conditions" : conditions,
      "sum" : sum,
      "reward" : reward,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TaskPlan
              && runtimeType == other.runtimeType
              && id == other.id
              && activity == other.activity
              && desc == other.desc
              && status == other.status
              && schedule == other.schedule
              && person == other.person
              && conditions == other.conditions
              && sum == other.sum
              && reward == other.reward;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + activity.hashCode;
    result = 37 * result + id.hashCode;
    result = 37 * result + desc.hashCode;
    result = 37 * result + status.hashCode;
    result = 37 * result + schedule.hashCode;
    result = 37 * result + person.hashCode;
    result = 37 * result + conditions.hashCode;
    result = 37 * result + sum.hashCode;
    result = 37 * result + reward.hashCode;
    return result;
  }

}

/// Status: 10 - none, 0 - done, -1 - fail, 3 - ill, 5 - other
enum TaskStatus {
  NONE,
  DONE,
  INVALID,
  FAIL,
  ILL,
  OTHER,
}

extension TaskStatusExtension on TaskStatus {

  static const statuses = {
    TaskStatus.NONE: Tuple2(10, 'Пусто'),
    TaskStatus.DONE: Tuple2(0, 'Сделано'),
    TaskStatus.INVALID: Tuple2(-1, 'Ошибочное'),
    TaskStatus.FAIL: Tuple2(3, 'Провал'),
    TaskStatus.ILL: Tuple2(5, 'Болезнь'),
    TaskStatus.OTHER: Tuple2(7, 'Друг'),
  };

  int get status => statuses[this]!.item1;

  String get name => statuses[this]!.item2;

}

/// Status: 0 - done, -1 - invalid, 3 - fail, 5 - ill, 7 - other
class TaskFact extends HierarchEntity {
  final TaskPlan taskPlan;
  final Person person;
  String? duration;
  final DateTime dtPlan;
  final DateTime dtExecute;

  TaskFact({required int id, String? name, String? desc, String? parentIdList, int status = 0,
    required TaskPlan taskPlan, required Person person, required DateTime dtPlan, required DateTime dtExecute}) :
        this.taskPlan = taskPlan,
        this.person = person,
        this.dtPlan = dtPlan,
        this.dtExecute = dtExecute,
        super(id: id, name: name, desc: desc, parentIdList: parentIdList, status: status);

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic> {
      "id" : id,
      "status" : status,
      "desc" : desc,
      "taskPlan" : taskPlan,
      "person" : person,
      "dtPlan" : dtPlan,
      "dtExecute" : dtExecute,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TaskFact
              && runtimeType == other.runtimeType
              && id == other.id
              && desc == other.desc
              && status == other.status
              && taskPlan == other.taskPlan
              && person == other.person
              && dtPlan == other.dtPlan
              && dtExecute == other.dtExecute;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + id.hashCode;
    result = 37 * result + desc.hashCode;
    result = 37 * result + status.hashCode;
    result = 37 * result + taskPlan.hashCode;
    result = 37 * result + person.hashCode;
    result = 37 * result + dtPlan.hashCode;
    result = 37 * result + dtExecute.hashCode;
    return result;
  }

}

