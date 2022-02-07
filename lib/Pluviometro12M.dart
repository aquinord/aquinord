class Pluviometro12M{
  String _medicao = "";
  String _hora = "";
  String _data_dia = "";
  String _mes = "";
  String _ano = "";
  String _ano_anterior = "";
  String _medicao_ano_anterior = "";

  Pluviometro12M(this._medicao, this._hora, this._data_dia, this._mes,
      this._ano, this._ano_anterior, this._medicao_ano_anterior);

  String get medicao_ano_anterior => _medicao_ano_anterior;

  set medicao_ano_anterior(String value) {
    _medicao_ano_anterior = value;
  }

  String get ano_anterior => _ano_anterior;

  set ano_anterior(String value) {
    _ano_anterior = value;
  }

  String get ano => _ano;

  set ano(String value) {
    _ano = value;
  }

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