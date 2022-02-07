class PrevisaoCptec{
  String _dia = "";
  String _data = "";
  String _ico = "";
  String _desc = "";
  String _texto = "";
  String _min = "";
  String _max = "";
  String _prob = "";
  String _sunrise = "";
  String _sunset = "";
  String _uv = "";

  PrevisaoCptec(this._dia, this._data, this._ico, this._desc, this._texto,
      this._min, this._max, this._prob, this._sunrise, this._sunset, this._uv);

  String get uv => _uv;

  set uv(String value) {
    _uv = value;
  }

  String get sunset => _sunset;

  set sunset(String value) {
    _sunset = value;
  }

  String get sunrise => _sunrise;

  set sunrise(String value) {
    _sunrise = value;
  }

  String get prob => _prob;

  set prob(String value) {
    _prob = value;
  }

  String get max => _max;

  set max(String value) {
    _max = value;
  }

  String get min => _min;

  set min(String value) {
    _min = value;
  }

  String get texto => _texto;

  set texto(String value) {
    _texto = value;
  }

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }

  String get ico => _ico;

  set ico(String value) {
    _ico = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get dia => _dia;

  set dia(String value) {
    _dia = value;
  }
}