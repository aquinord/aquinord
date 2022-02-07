class Ocorrencia{
  bool _anonimo = true;
  String? _nome_cidadao = "";
  String? _id_usuario = "";
  String? _email = "";
  String? _foto_cidadao = "";
  String? _foto_name = "";
  String? _token = "";

  Ocorrencia(this._anonimo, this._nome_cidadao, this._id_usuario, this._email, this._foto_cidadao,
      this._foto_name, this._token);

  bool get anomino => _anonimo;

  set anomino(bool value) {
    _anonimo = value;
  }

  String get token => _token ?? "";

  set token(String? value) {
    _token = value;
  }

  String get foto_name => _foto_name ?? "";

  set foto_name(String? value) {
    _foto_name = value;
  }

  String get foto_cidadao => _foto_cidadao ?? "";

  set foto_cidadao(String? value) {
    _foto_cidadao = value;
  }

  String get email => _email ?? "";

  set email(String? value) {
    _email = value;
  }

  String get id_usuario => _id_usuario ?? "";

  set id_usuario(String? value) {
    _id_usuario = value;
  }

  String get nome_cidadao => _nome_cidadao ?? "";

  set nome_cidadao(String? value) {
    _nome_cidadao = value;
  }
}





