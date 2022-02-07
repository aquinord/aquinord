class Pluviometro24hs{
  String _medicao = "";
  String _hora = "";
  String _data_dia = "";
  String _mes = "";

  Pluviometro24hs(this._medicao, this._hora, this._data_dia, this._mes);

  String get mes => _mes;

  set mes(String value) {
    _mes = value;
  }

  String get data_dia => _data_dia;

  set data_dia(String value) {
    _data_dia = value;
  }

  String get hora => _hora;

  set hora(String value) {
    _hora = value;
  }

  String get medicao => _medicao;

  set medicao(String value) {
    _medicao = value;
  }
}