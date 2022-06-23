import 'package:score_system/vocabulary/constant.dart';

class BaseEntity{
  final int id;
  String? name;
  String? desc;

  BaseEntity({required this.id, this.name, this.desc});

  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "id" : id,
      "name" : name,
      "desc" : desc,
    };
  }
}

class HierarchEntity extends BaseEntity{
  int status;
  String? parentIdList;

  HierarchEntity({required int id, String? name, String? desc, String? parentIdList, int status = 0}) :
        this.status = status,
        this.parentIdList = parentIdList,
        super(id: id, name: name, desc: desc);


  Map<String,dynamic> toMap(){ // used when inserting data to the database
    return <String,dynamic>{
      "id" : id,
      "name" : name,
      "parentIdList" : parentIdList,
      "status" : status,
      "desc" : desc,
    };
  }
}

class HierarchEntityUtil<T extends HierarchEntity> {

  List<T> getChildrenData(T entity, List<T> srcList) {
    return srcList.where((element) => element.parentIdList != null && element.parentIdList!.split(STRING_DELIMETER).map((e) => int.parse(e)).contains(entity.id)).toList();
  }

  List<T> getTopData(List<T> srcList) {
    return srcList.where((element) => element.parentIdList == null || element.parentIdList!.isEmpty).toList();
  }

}
