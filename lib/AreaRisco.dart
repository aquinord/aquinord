import 'package:mapas_e_geolocalizacao/ImagemArea.dart';

class AreaRisco{
  int _id = 1;
  int _id_tipo_risco = 1;
  String _localizacao = "";
  String _descricao_risco = "";
  String _tipo_risco = "";
  String _coordenadas = "";
  String _qtd_pessoas_risco = "";
  String _qtd_imoveis_risco = "";
  String _observacoes = "";
  List<ImagemArea> _imagens = [];

  AreaRisco(
      this._id,
      this._id_tipo_risco,
      this._localizacao,
      this._descricao_risco,
      this._tipo_risco,
      this._coordenadas,
      this._qtd_pessoas_risco,
      this._qtd_imoveis_risco,
      this._observacoes,
      this._imagens);

  List<ImagemArea> get imagens => _imagens;

  set imagens(List<ImagemArea> value) {
    _imagens = value;
  }

  String get observacoes => _observacoes;

  set observacoes(String value) {
    _observacoes = value;
  }

  String get qtd_imoveis_risco => _qtd_imoveis_risco;

  set qtd_imoveis_risco(String value) {
    _qtd_imoveis_risco = value;
  }

  String get qtd_pessoas_risco => _qtd_pessoas_risco;

  set qtd_pessoas_risco(String value) {
    _qtd_pessoas_risco = value;
  }

  String get coordenadas => _coordenadas;

  set coordenadas(String value) {
    _coordenadas = value;
  }

  String get tipo_risco => _tipo_risco;

  set tipo_risco(String value) {
    _tipo_risco = value;
  }

  String get descricao_risco => _descricao_risco;

  set descricao_risco(String value) {
    _descricao_risco = value;
  }

  String get localizacao => _localizacao;

  set localizacao(String value) {
    _localizacao = value;
  }

  int get id_tipo_risco => _id_tipo_risco;

  set id_tipo_risco(int value) {
    _id_tipo_risco = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}