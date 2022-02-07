class Pluviometro{
  String _id = "";
  String _codEstacao = "";
  String _latitude = "";
  String _longitude = "";
  String _cidade = "";
  String _nome = "";
  String _uf = "";
  String _bool_ativo = "";
  String _acc24h = "";
  String _acc5d = "";
  String _acc12M = "";
  String _qtd_leituras = "";

  Pluviometro(
      this._id,
      this._codEstacao,
      this._latitude,
      this._longitude,
      this._cidade,
      this._nome,
      this._uf,
      this._bool_ativo,
      this._acc24h,
      this._acc5d,
      this._acc12M,
      this._qtd_leituras);

  String get qtd_leituras => _qtd_leituras;

  set qtd_leituras(String value) {
    _qtd_leituras = value;
  }

  String get acc5d => _acc5d;

  set acc5d(String value) {
    _acc5d = value;
  }

  String get acc24h => _acc24h;

  set acc24h(String value) {
    _acc24h = value;
  }

  String get acc12M => _acc12M;

  set acc12M(String value) {
    _acc12M = value;
  }

  String get bool_ativo => _bool_ativo;

  set bool_ativo(String value) {
    _bool_ativo = value;
  }

  String get uf => _uf;

  set uf(String value) {
    _uf = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get longitude => _longitude;

  set longitude(String value) {
    _longitude = value;
  }

  String get latitude => _latitude;

  set latitude(String value) {
    _latitude = value;
  }

  String get codEstacao => _codEstacao;

  set codEstacao(String value) {
    _codEstacao = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}