import 'package:score_system/model/entity.dart';

abstract class EntitiesData<T extends HierarchEntity> {

  final bool isDbMode;

  EntitiesData({required bool isDbMode}) :
    this.isDbMode = isDbMode;

  List<T> getData(){
    return isDbMode ? getDbData() : getLocalData();
  }

  List<T> getDbData();
  List<T> getLocalData();
}


