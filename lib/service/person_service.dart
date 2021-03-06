import 'dart:collection';

import 'package:score_system/model/activity.dart';
import 'package:score_system/model/person.dart';
import 'package:score_system/model/schedule.dart';
import 'package:score_system/model/task.dart';
import 'package:score_system/vocabulary/constant.dart';
import 'package:score_system/vocabulary/task_data.dart';
import 'package:tuple/tuple.dart';
import 'package:score_system/util/date_util.dart';
import 'package:time_machine/time_machine.dart';

class PersonProgress {
  final Person person;
  final List<Schedule> schedule;
  final DateTime? datePlan;
  final int successProgress;
  final int failProgress;
  final int illProgress;
  final int otherProgress;
  final int allProgress;
  PersonProgress({required Person person, required List<Schedule> schedule, DateTime? datePlan,
      int successProgress = 0, int failProgress = 0, int illProgress = 0, int otherProgress = 0, int allProgress = 0}) :
    this.person = person,
    this.schedule = schedule,
    this.datePlan = datePlan,
    this.successProgress = successProgress,
    this.failProgress = failProgress,
    this.illProgress = illProgress,
    this.otherProgress = otherProgress,
    this.allProgress = allProgress;
}

class PersonTaskProgress extends PersonProgress {
  final int taskId;
  PersonTaskProgress({required Person person, required List<Schedule> schedule, required int taskId, DateTime? dtPlan,
      int successProgress = 0, int failProgress = 0, int illProgress = 0, int otherProgress = 0, int allProgress = 0}) :
    this.taskId = taskId,
    super(person: person, schedule: schedule, datePlan: dtPlan, successProgress: successProgress, failProgress: failProgress,
          illProgress: illProgress, otherProgress: otherProgress, allProgress: allProgress);
}

class PersonTaskId {
  final Person person;
  final int taskId;
  final List<Schedule> schedule;
  final DateTime? dtPlan;

  PersonTaskId(this.person, this.taskId, this.schedule, this.dtPlan);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PersonTaskId
              && runtimeType == other.runtimeType
              && person == other.person
              && taskId == other.taskId
              && schedule == other.schedule
              && dtPlan == other.dtPlan;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + person.hashCode;
    result = 37 * result + taskId.hashCode;
    result = 37 * result + schedule.hashCode;
    result = 37 * result + dtPlan.hashCode;
    return result;
  }

}

class TaskIdActivity {
  final int taskId;
  final Activity activity;

  TaskIdActivity(this.taskId, this.activity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TaskIdActivity
              && runtimeType == other.runtimeType
              && taskId == other.taskId
              && activity == other.activity;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + taskId.hashCode;
    result = 37 * result + activity.hashCode;
    return result;
  }

}

class PersonService {

  List<PersonTaskProgress> getAllPersonProgress() {
    List<PersonTaskProgress> rez = [];
    /**
     * Get all plan tasks
     */
    List<TaskPlan> plans = TaskPlanData().getData();
    /**
     * Get all fact tasks
     */
    List<TaskFact> facts = TaskFactData().getData();
    /**
     * Get all actual plan tasks progresses
     */
    List<PersonTaskProgress> personStatsPlan = plans
        .where((plan) => plan.person != null && plan.status == STATUS_ACTUAL
        )
        .map((plan) =>
          PersonTaskProgress(
            person: plan.person!,
            taskId: plan.id,
            schedule: plan.schedule,
            allProgress: plan.schedule.map((sched) => sched.count > 1 ? sched.count : 1).reduce((value, element) => value + element)
          )
        ).toList();
    /**
     * Get all actual fact tasks progresses
     */
    List<PersonTaskProgress> personStatsFact = facts
        .map((fact) =>
        PersonTaskProgress(
            dtPlan: fact.dtPlan,
            person: fact.person,
            taskId: fact.taskPlan.id,
            schedule: fact.taskPlan.schedule,
            successProgress: fact.taskPlan.person == fact.person && fact.status == TaskStatus.DONE.status ? 1 : 0,
            illProgress: fact.taskPlan.person == fact.person && fact.status == TaskStatus.ILL.status ? 1 : 0,
            otherProgress: fact.taskPlan.person != fact.person && fact.status == TaskStatus.OTHER.status ? 1 : 0,
        )
    ).toList();
    /**
     * Get all actual fact tasks progresses
     */
    rez = _getPersonTaskProgress(personStatsPlan, personStatsFact);
    return rez;
  }

  List<PersonProgress> getAllPersonProgressGroupByPerson() {
    List<PersonProgress> rez = [];
    Map<Person, PersonProgress> rezMap = {};
    List<PersonTaskProgress> allPersonProgress = getAllPersonProgress();
    allPersonProgress.forEach((element) {
      PersonProgress? oldVal = rezMap[element.person];
      if (oldVal == null) {
        rezMap[element.person] =
            PersonProgress(
              person: element.person,
              schedule: element.schedule,
              successProgress: element.successProgress,
              failProgress: element.failProgress,
              allProgress: element.allProgress,
              illProgress: element.illProgress,
              otherProgress: element.otherProgress
            );
      } else {
        rezMap[element.person] =
            PersonProgress(
                person: element.person,
                schedule: element.schedule,
                successProgress: oldVal.successProgress + element.successProgress,
                failProgress: oldVal.failProgress + element.failProgress,
                allProgress: oldVal.allProgress + element.allProgress,
                illProgress: oldVal.illProgress + element.illProgress,
                otherProgress: oldVal.otherProgress + element.otherProgress
            );
      }
    });
    rez = rezMap.values.toList();
    return rez;
  }

  List<PersonTaskProgress> _getPersonTaskProgress(List<PersonTaskProgress> personStatsPlan, List<PersonTaskProgress> personStatsFact) {
    List<PersonTaskProgress> rez = [];
    /**
     * Get map of all tasks progresses
     */
    Map<PersonTaskId, int> allPersonProgress = new HashMap();
    Map<PersonTaskId, int> failPersonProgress = new HashMap();
    for (PersonTaskProgress personStatsPlanCur in personStatsPlan) {
      PersonTaskId key = PersonTaskId(personStatsPlanCur.person, personStatsPlanCur.taskId, personStatsPlanCur.schedule, null);
      /**
       * Get all progresses
       */
      int oldVal = 0;
      if (allPersonProgress.containsKey(key)) {
        oldVal = allPersonProgress[key]!;
      }
      oldVal += personStatsPlanCur.allProgress;
      allPersonProgress[key] = oldVal;
      /**
       * Get fail progresses
       */
      DateTime now = DateTime.now();
      List<Schedule> schedules = key.schedule.where((sched) => sched.date.isBefore(now)).toList();
      for (Schedule schedule in schedules) {
        int count = personStatsFact.where((fact) => key.person == fact.person && key.taskId == fact.taskId && schedule.date.isSameDate(fact.datePlan!)).length;
        if (count < schedule.count) {
          oldVal = 0;
          if (failPersonProgress.containsKey(key)) {
            oldVal = failPersonProgress[key]!;
          }
          oldVal += schedule.count - count;
          failPersonProgress[key] = oldVal;
        }
      }

    }
    /**
     * Get map of all success, ill, other tasks progresses
     */
    Map<PersonTaskId, int> successPersonProgress = new HashMap();
    Map<PersonTaskId, int> illPersonProgress = new HashMap();
    Map<PersonTaskId, int> otherPersonProgress = new HashMap();
    for (PersonTaskProgress personStatsFactCur in personStatsFact) {
      PersonTaskId key = PersonTaskId(personStatsFactCur.person, personStatsFactCur.taskId, personStatsFactCur.schedule, personStatsFactCur.datePlan);
      int oldVal = 0;
      if (successPersonProgress.containsKey(key)) {
        oldVal = successPersonProgress[key]!;
      }
      oldVal += personStatsFactCur.successProgress;
      successPersonProgress[key] = oldVal;
      oldVal = 0;
      if (illPersonProgress.containsKey(key)) {
        oldVal = illPersonProgress[key]!;
      }
      oldVal += personStatsFactCur.illProgress;
      illPersonProgress[key] = oldVal;
      oldVal = 0;
      if (otherPersonProgress.containsKey(key)) {
        oldVal = otherPersonProgress[key]!;
      }
      oldVal += personStatsFactCur.otherProgress;
      otherPersonProgress[key] = oldVal;
    }
    /**
     * Get collection of all merged tasks progresses
     */
    allPersonProgress.forEach((key, value) {
      rez.add(
        PersonTaskProgress(
          person: key.person,
          taskId: key.taskId,
          allProgress: allPersonProgress[key] ?? 0,
          successProgress: successPersonProgress[key] ?? 0,
          illProgress: illPersonProgress[key] ?? 0,
          otherProgress: otherPersonProgress[key] ?? 0,
          failProgress: failPersonProgress[key] ?? 0,
          schedule: key.schedule,
        )
      );
    });
    return rez;
  }

  List<PersonTaskProgress> getAllPersonProgressByDateInterval(DateTime dtBegin, DateTime dtEnd) {
    List<PersonTaskProgress> rez = [];
    /**
     * Get all plan tasks
     */
    List<TaskPlan> plans = TaskPlanData().getData();
    plans.forEach((plan) {
      plan.schedule.sort((sched1, sched2) => sched1.date.compareTo(sched2.date));
    });
    /**
     * Get all fact tasks
     */
    List<TaskFact> facts = TaskFactData().getData();
    facts.sort((fact1, fact2) => fact1.dtPlan.compareTo(fact2.dtPlan));
    /**
     * Get all actual plan tasks progresses
     */
    List<PersonTaskProgress> personStatsPlan = plans
        .where((plan) => plan.person != null && plan.status == STATUS_ACTUAL
          && (DateInterval(LocalDate.dateTime(dtBegin), LocalDate.dateTime(dtEnd))
                .intersection(DateInterval(LocalDate.dateTime(plan.schedule.first.date), LocalDate.dateTime(plan.schedule.last.date))) != null)
        )
        .map((plan) =>
        PersonTaskProgress(
            person: plan.person!,
            taskId: plan.id,
            allProgress: plan.schedule.map((sched) => sched.count > 1 ? sched.count : 1).reduce((value, element) => value + element),
            schedule: plan.schedule,
        )
    ).toList();
    /**
     * Get all actual fact tasks progresses
     */
    List<PersonTaskProgress> personStatsFact = facts
        .where((fact) => fact.status == STATUS_ACTUAL &&  personStatsPlan.where((plan) => plan.taskId == fact.taskPlan.id).isNotEmpty
        )
        .map((fact) =>
        PersonTaskProgress(
            person: fact.person,
            taskId: fact.id,
            successProgress: fact.taskPlan.person == fact.person && fact.status == TaskStatus.DONE.status ? 1 : 0,
            illProgress: fact.taskPlan.person == fact.person && fact.status == TaskStatus.ILL.status ? 1 : 0,
            otherProgress: fact.taskPlan.person != fact.person && fact.status == TaskStatus.OTHER.status ? 1 : 0,
            schedule: fact.taskPlan.schedule,
        )
    ).toList();
    /**
     * Get all actual fact tasks progresses
     */
    rez = _getPersonTaskProgress(personStatsPlan, personStatsFact);
    return rez;
  }

  PersonTaskProgress getPersonProgressByDateInterval(Person person, DateTime dtBegin, DateTime dtEnd) {
    List<PersonTaskProgress> rez = [];
    /**
     * Get all plan tasks
     */
    List<TaskPlan> plans = TaskPlanData().getData();
    plans.forEach((plan) {
      plan.schedule.sort((sched1, sched2) => sched1.date.compareTo(sched2.date));
    });
    /**
     * Get all fact tasks
     */
    List<TaskFact> facts = TaskFactData().getData();
    facts.sort((fact1, fact2) => fact1.dtPlan.compareTo(fact2.dtPlan));
    /**
     * Get all actual plan tasks progresses
     */
    List<PersonTaskProgress> personStatsPlan = plans
        .where((plan) => plan.person == person && plan.status == STATUS_ACTUAL
        && (DateInterval(LocalDate.dateTime(dtBegin), LocalDate.dateTime(dtEnd))
            .intersection(DateInterval(LocalDate.dateTime(plan.schedule.first.date), LocalDate.dateTime(plan.schedule.last.date))) != null)
    )
        .map((plan) =>
        PersonTaskProgress(
          person: plan.person!,
          taskId: plan.id,
          allProgress: plan.schedule.map((sched) => sched.count > 1 ? sched.count : 1).reduce((value, element) => value + element),
          schedule: plan.schedule,
        )
    ).toList();
    /**
     * Get all actual fact tasks progresses
     */
    List<PersonTaskProgress> personStatsFact = facts
        .where((fact) => fact.status == STATUS_ACTUAL && fact.taskPlan.person == person &&  personStatsPlan.where((plan) => plan.taskId == fact.taskPlan.id).isNotEmpty
    )
        .map((fact) =>
        PersonTaskProgress(
          person: fact.person,
          taskId: fact.id,
          successProgress: fact.taskPlan.person == fact.person && fact.status == TaskStatus.DONE.status ? 1 : 0,
          illProgress: fact.taskPlan.person == fact.person && fact.status == TaskStatus.ILL.status ? 1 : 0,
          otherProgress: fact.taskPlan.person != fact.person && fact.status == TaskStatus.OTHER.status ? 1 : 0,
          schedule: fact.taskPlan.schedule,
        )
    ).toList();
    /**
     * Get all actual fact tasks progresses
     */
    rez = _getPersonTaskProgress(personStatsPlan, personStatsFact);
    if (rez.isEmpty) {
      rez.add(PersonTaskProgress(person: person, taskId: 0, successProgress: 0, failProgress: 0, allProgress: 0, schedule: []));
    }
    return rez.first;
  }

  Map<TaskIdActivity, Tuple4<int, int, int, int>> getActualPersonProgressByDate(Person person, DateTime curDate) {
    Map<TaskIdActivity, Tuple4<int, int, int, int>> rez = {};
    /**
     * Get all plan tasks
     */
    List<TaskPlan> plans = TaskPlanData().getData();
    /**
     * Get all fact tasks
     */
    List<TaskFact> facts = TaskFactData().getData();
    /**
     * Get all actual plan tasks progresses
     */
    Map<TaskIdActivity, int> planProgress = HashMap();
    plans.where((plan) => plan.person == person && plan.status == STATUS_ACTUAL
        && plan.schedule.where((sched) => sched.date.isSameDate(curDate)).length > 0
      ).forEach((plan) {
        planProgress[TaskIdActivity(plan.id, plan.activity)] = plan.schedule.where((sched) => sched.date.isSameDate(curDate)).map((sched) => sched.count > 1 ? sched.count : 1).reduce((value, element) => value + element);
      });
    /**
     * Get all actual fact tasks progresses
     */
    List<Map<TaskIdActivity, Tuple3<int, int, int>>> factProgress = facts
        .where((fact) => fact.taskPlan.person == person && fact.status != TaskStatus.INVALID.status && fact.dtPlan.isSameDate(curDate))
        .map((fact) {
          TaskIdActivity taskIdActivity = TaskIdActivity(fact.taskPlan.id, fact.taskPlan.activity);
          Map<TaskIdActivity, Tuple3<int, int, int>> map = HashMap();
          map[taskIdActivity] = Tuple3(fact.status == TaskStatus.DONE.status ? 1 : 0, fact.status == TaskStatus.ILL.status ? 1 : 0, fact.status == TaskStatus.OTHER.status ? 1 : 0, );
          return map;
        }
    ).toList();
    factProgress.forEach((fact) {
      fact.forEach((key, value) {
        Tuple4<int, int, int, int> oldVal = Tuple4(0, 0, 0, 0);
        if (rez[key] != null) {
          oldVal = rez[key]!;
        }
        rez[key] = Tuple4(planProgress[key]!, oldVal.item1 + value.item1, oldVal.item2 + value.item2, oldVal.item3 + value.item3);
      });
    });
    if (rez.isEmpty) {
      rez[TaskIdActivity(0, Activity(id: 0, name: "????????????"))] = Tuple4(0, 0, 0, 0);
    }
    return rez;
  }

}