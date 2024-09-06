class Todo {
  int? _id;
  String _title;
  String _description;

  Todo(this._title, [this._description = '']);

  Todo.withId(this._id, this._title, [this._description = '']);

  int? get id => _id;

  String get title => _title;

  String get description => _description;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    return map;
  }

  Todo.fromMapObject(Map<String, dynamic> map)
      : _id = map['id'],
        _title = map['title'],
        _description = map['description'] ?? '';
}
