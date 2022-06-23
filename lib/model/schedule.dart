import 'package:score_system/model/entity.dart';

class Schedule extends HierarchEntity{
  final DateTime date;
  final int count;

  Schedule({required int id, String? name, String? desc, int status = 0,
          required DateTime date, int? count}) :
        this.date = date,
        this.count = count ?? 1,
        super(id: id, name: name, desc: desc, status: status);

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic> {
      "id" : id,
      "name" : name,
      "desc" : desc,
      "date" : date,
      "count" : count,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Schedule
              && runtimeType == other.runtimeType
              && name == other.name
              && id == other.id
              && desc == other.desc
              && status == other.status
              && date == other.date
              && count == other.count;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + name.hashCode;
    result = 37 * result + id.hashCode;
    result = 37 * result + desc.hashCode;
    result = 37 * result + status.hashCode;
    result = 37 * result + date.hashCode;
    result = 37 * result + count.hashCode;
    return result;
  }

}