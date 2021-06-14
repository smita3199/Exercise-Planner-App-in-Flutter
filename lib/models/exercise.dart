class Exercise {

  int _id;
  String _name;
  String _weight;
  int _sets;
  int _reps;

  Exercise(this._name,this._sets,this._reps,[this._weight]);

  Exercise.withId(this._id,this._name,this._sets,this._reps,[this._weight]);

  int get id => _id;
  String get name => _name;
  String get weight => _weight;
  int get sets => _sets;
  int get reps => _reps;

  set name(String newName){
    if (newName.length <= 255)
    this._name = newName;
  }

  set weight(String newWeight){
    if (newWeight.length <= 255)
      this._weight = newWeight;
  }

  set sets(int newSets){
      this._sets = newSets;
  }

  set reps(int newReps){
      this._reps = newReps;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if(id != null) {
      map["id"] = _id;
    }
    map["name"] = _name;
    map["weight"] = _weight;
    map["sets"] = _sets;
    map["reps"] = _reps;

    return map;
  }

  Exercise.fromMapObject(Map<String, dynamic> map){

    this._id = map["id"];
    this._name = map["name"];
    this._weight = map["weight"];
    this._sets = map["sets"];
    this._reps = map["reps"];
  }

}