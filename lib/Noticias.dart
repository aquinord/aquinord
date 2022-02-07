class Noticias{
  String _id = "";
  String _titulo = "";
  String _dt = "";
  String _img = "";

  Noticias(this._id, this._titulo, this._dt, this._img);

  String get img => _img;

  set img(String value) {
    _img = value;
  }

  String get dt => _dt;

  set dt(String value) {
    _dt = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}