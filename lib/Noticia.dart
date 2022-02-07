class Noticia{
  String _id = "";
  String _titulo = "";
  String _texto = "";
  String _img = "";
  String _capa_interna = "";
  String _album = "";

  Noticia(this._id, this._titulo, this._texto, this._img, this._capa_interna,
      this._album);

  String get album => _album;

  set album(String value) {
    _album = value;
  }

  String get capa_interna => _capa_interna;

  set capa_interna(String value) {
    _capa_interna = value;
  }

  String get img => _img;

  set img(String value) {
    _img = value;
  }

  String get texto => _texto;

  set texto(String value) {
    _texto = value;
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