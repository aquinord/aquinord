import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Localidades.dart';
import 'package:mapas_e_geolocalizacao/Strings.dart';
import 'package:mapas_e_geolocalizacao/Ocorrencia.dart';

double pluvMaxHora = 50;
double pluvMaxDia = 0;
double pluvMax5d = 0;
double pluvMaxMes = 500;
double pluvMax12M = 2000;
double minDistPluv = 2000;
List<Localidades> localidades = [
  Localidades('Ouro Preto',0, -20.38546, -43.5057957),
  Localidades('Cachoeira do Campo',3, -20.3493745, -43.6811939),
  Localidades('Amarantina',1, -20.313571, -43.7075527),
  Localidades('Antônio Pereira',0, -20.3031639, -43.4890354),
  Localidades('Santo Antônio do Salto',0, -20.4987157, -43.4658473),
  Localidades('Rodrigo Silva',4, -20.4235839, -43.6244724),
];

Ocorrencia ocorrencia = Ocorrencia(true, "a", "b", "c", "d", "e", "f");

List<String> tipoIncidente = []; //<String>['Alagamento',  'Deslizamento de terra',  'Inundação',  'Queda de árvore',  'Queda de muro',  'Outro'];
//List<String> tipoIncidente = [];
Map<String,int> mapIncidentes = {};
//List<Map<String,String>> mapIncidentes = [];



String infoAlerta(double medicao)  {
  if (medicao >= 128) return Strings.vermelho;
  else if (medicao >= 22) return Strings.laranja;
  else if (medicao >= 1) return Strings.verde;
  else return Strings.verde;

}

String infoAlertaNivel(String nivel)  {
  if (nivel == "4") return Strings.vermelho;
  else if (nivel == "3") return Strings.laranja;
  else if (nivel == "2") return Strings.verde;
  else return Strings.verde;

}










String sobre = "O aplicativo Defesa Civil - Ouro Preto busca facilitar a comunicação da Defesa Civil de Ouro Preto com os cidadãos, enviando alertas em tempo real sobre possíveis alterações geológicas e situações de risco urgentes."
    "\n\nTotalmente desenvolvido pela equipe própria de Tecnologia da Prefeitura de Ouro Preto, o aplicativo mostra todas as áreas de risco do município, de acordo com o mapeamento feito pela Companhia de Pesquisa de Recursos Minerais (CPRM)."
"\n\nO aplicativo também mostra em tempo real as informações sobre as chuvas na região. Isso é possível graças à integração dos sistemas da Prefeitura e do Centro Nacional de Monitoramento e Alertas de Desastres Naturais (Cemaden), por meio dos dados coletados em tempo real pelos pluviômetros espalhados pelo Município."
"\n\nA população poderá também colaborar, enviando fotos e informações de eventos que venham a acontecer, de forma a informar a Defesa Civil e alertar a população.";

