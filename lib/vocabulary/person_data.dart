import 'package:score_system/model/person.dart';
import 'package:score_system/vocabulary/abstract_list_voc.dart';
import 'package:score_system/vocabulary/constant.dart';

class PersonData extends EntitiesData<Person>{

  PersonData() :
        super(isDbMode: IS_DB_MODE);

  @override
  List<Person> getDbData() {
    // TODO: Imlement db query
    // TODO: implement getDbData
    throw UnimplementedError();
  }

  @override
  List<Person> getLocalData() {
    return [
      Person(
        id: 1,
        name: 'Виталий',
        family: 'Ермилов',
        secName: 'Юрьевич',
        avaPath: AVA_PATH + "Vitaliy.png",
      ),
      Person(
        id: 2,
        name: 'Екатерина',
        family: 'Ермилова',
        secName: 'Евгеньевна',
        avaPath: AVA_PATH + "Kate.png",
      ),
      Person(
        id: 3,
        name: 'Елизавета',
        family: 'Ермилова',
        secName: 'Витальевна',
        avaPath: AVA_PATH + "Liza.png",
      ),
      Person(
        id: 4,
        name: 'Ксения',
        family: 'Ермилова',
        secName: 'Витальевна',
        avaPath: AVA_PATH + "Ksenia.png",
      ),
      Person(
        id: 5,
        name: 'Полина',
        family: 'Ермилова',
        secName: 'Витальевна',
        avaPath: AVA_PATH + "Polya.png",
      ),
      Person(
        id: 6,
        name: 'Юлия',
        family: 'Ермилова',
        secName: 'Витальевна',
        avaPath: AVA_PATH + "Julia.png",
      ),
    ];
  }

}