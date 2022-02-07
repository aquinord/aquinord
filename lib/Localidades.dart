class Localidades{
  String _local = "";
  int _id = 0;
  double _lat = 0;
  double _long = 0;

  Localidades(this._local, this._id, this._lat, this._long);

  double get long => _long;

  set long(double value) {
    _long = value;
  }

  double get lat => _lat;

  set lat(double value) {
    _lat = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get local => _local;

  set local(String value) {
    _local = value;
  }
}