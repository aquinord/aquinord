class ImagemArea{
  int _idArea = 0;
  String _nome_arquivo = "";

  ImagemArea(this._idArea, this._nome_arquivo);

  String get nome_arquivo => _nome_arquivo;

  set nome_arquivo(String value) {
    _nome_arquivo = value;
  }

  int get idArea => _idArea;

  set idArea(int value) {
    _idArea = value;
  }
}