class Informativo{
  String _texto = "";
  String _nome_cidadao = "";
  String _foto_cidadao = "";
  String _foto  = "";
  String _dt = "";
  String _bool_publicacao_defesa_civil = "";
  String _bool_anonimo = "";
  String _descricao = "";
  String _latitude = "";
  String _longitude = "";

  Informativo(
      this._texto,
      this._nome_cidadao,
      this._foto_cidadao,
      this._foto,
      this._dt,
      this._bool_publicacao_defesa_civil,
      this._bool_anonimo,
      this._descricao,
      this._latitude,
      this._longitude);

  String get longitude => _longitude;

  set longitude(String value) {
    _longitude = value;
  }

  String get latitude => _latitude;

  set latitude(String value) {
    _latitude = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get bool_anonimo => _bool_anonimo;

  set bool_anonimo(String value) {
    _bool_anonimo = value;
  }

  String get bool_publicacao_defesa_civil => _bool_publicacao_defesa_civil;

  set bool_publicacao_defesa_civil(String value) {
    _bool_publicacao_defesa_civil = value;
  }

  String get dt => _dt;

  set dt(String value) {
    _dt = value;
  }

  String get foto => _foto;

  set foto(String value) {
    _foto = value;
  }

  String get foto_cidadao => _foto_cidadao;

  set foto_cidadao(String value) {
    _foto_cidadao = value;
  }

  String get nome_cidadao => _nome_cidadao;

  set nome_cidadao(String value) {
    _nome_cidadao = value;
  }

  String get texto => _texto;

  set texto(String value) {
    _texto = value;
  }
}