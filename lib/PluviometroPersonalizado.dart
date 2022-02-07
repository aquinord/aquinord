class PluviometroPersonalizado{
  List<String> _medicao = [];

  PluviometroPersonalizado(this._medicao);

  List<String> get medicao => _medicao;

  set medicao(List<String> value) {
    _medicao = value;
  }
}


