import 'package:score_system/vocabulary/person_data.dart';

import 'entity.dart';

class Person extends HierarchEntity{

  final String family;
  final String secName;
  final String? avaPath;

  Person({required int id, required String name, String? desc, String? parentIdList, int status = 0, String? family, String? secName, String? avaPath}) :
        this.family = family ?? " ",
        this.secName = secName ?? " ",
        this.avaPath = avaPath,
        super(id: id, name: name, desc: desc, parentIdList: parentIdList, status: status);

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic> {
      "id" : id,
      "name" : name,
      "parentIdList" : parentIdList,
      "status" : status,
      "family" : family,
      "secname" : secName,
      "avaPath" : avaPath,
      "desc" : desc,
    };
  }

  String fio() {
    return family + " " + name! + " " + secName;
  }

  static Person personByFio(String fio) {
    List<String> ar = fio.split(" ");
    return PersonData().getData().where((person) => ar[0] == person.family && ar[1] == person.name && (ar.length > 2 ? ar[2] == person.secName : true)).toList().first;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Person
              && runtimeType == other.runtimeType
              && id == other.id
              && name == other.name
              && family == other.family
              && secName == other.secName
              && avaPath == other.avaPath;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + id.hashCode;
    result = 37 * result + name.hashCode;
    result = 37 * result + family.hashCode;
    result = 37 * result + secName.hashCode;
    result = 37 * result + avaPath.hashCode;
    return result;
  }

}
