import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:xml2json/xml2json.dart';
import 'package:mapas_e_geolocalizacao/PrevisaoCptec.dart';

class PrevisaoTempo extends StatefulWidget {
  const PrevisaoTempo({Key? key}) : super(key: key);

  @override
  _PrevisaoTempoState createState() => _PrevisaoTempoState();
}

class _PrevisaoTempoState extends State<PrevisaoTempo> {
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  http.Client sgmClient() {
    var ioClient = new HttpClient()..badCertificateCallback = _certificateCheck;

    return new IOClient(ioClient);
  }

  //String urlbase = "https://sgm.ouropreto.mg.gov.br/apps/defesa_civil";
  //String urlbase = "https://blockchain.info/ticker";
  //String urlbase = "https://sgm.ouropreto.mg.gov.br/apps/defesa_civil/getAreasRisco.php";
  String urlbase = "http://servicos.cptec.inpe.br/apptempo/3672";

  Future<List<PrevisaoCptec>> _recuperarPrevisao() async {
    var client = sgmClient();

    var response;
    try {
      response = await client.post(Uri.parse(urlbase));
      //print(await client.get(uriResponse.bodyFields['uri']));
    } finally {
      client.close();
    }

    //http.Response response = await http.get(Uri.parse(urlbase + "/getAreasRisco.php"));
    //http.Response response = await http.get(Uri.parse(urlbase));
    print(response.body);
    print("teste");
    final myTransformer = Xml2Json();
    var goodXmlString = response.body;

    // Parse a simple XML string

    myTransformer.parse(goodXmlString);
    print('XML string');
    print(goodXmlString);
    print('');

    // Transform to JSON using Parker
    var json1 = myTransformer.toParker();
    print('Parker');
    print('');
    print(json1);
    print('');

    /* // Transform to JSON using ParkerWithAttrs
    json1 = myTransformer.toParkerWithAttrs();
    print('ParkerWithAttrs');
    print('');
    print(json1);
    print('');

    // Transform to JSON using ParkerWithAttrs
    // A node in XML should be an array, but if there is only one element in the array,
    // it will only be parsed into an object, so we need to specify the node as an array
    json1 = myTransformer.toParkerWithAttrs(array: ['contact']);
    print('ParkerWithAttrs, specify the node as an array');
    print('');
    print(json1);*/
   // print('dec..............................');
    var dadosJson1 = json.decode(json1);
    //print('dec..............................');

    //print(dadosJson1["cidade"]["previsao"][1]["dia"].toString());
    //print('dec..............................');

    List<PrevisaoCptec> previsao = [];

    for (var prev in dadosJson1["cidade"]["previsao"]) {
      //print("dia: " + prev["dia"].toString());


      //print(encoded.toString());
      PrevisaoCptec p = PrevisaoCptec(
        prev["dia"].toString(),
        prev["data"].toString(),
        prev["ico"].toString(),
        prev["desc"].toString(),
        prev["texto"].toString(),
        prev["min"].toString(),
        prev["max"].toString(),
        prev["prob"].toString(),
        prev["sunrise"].toString(),
        prev["sunset"].toString(),
        prev["uv"].toString(),
      );
      //print("dia: " + p.dia);
      previsao.add(p);
    }
    return previsao;
  }

  _post() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(44, 24, 96, 1),
        title: Text("Previsão do Tempo"),
        /*actions: [
          IconButton(
              onPressed: () {
                //Navigator.pushNamed(context, "/");
              },
              icon: Icon(Icons.list)),
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],*/
      ),
      body: FutureBuilder<List<PrevisaoCptec>>(
        future: _recuperarPrevisao(),
        builder: (context, snapshot) {
          String resultado = "";
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              print("conexão none");
              break;
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
              print("conexão activa");
              break;
            case ConnectionState.done:
              print("conexão realizada");
              if (snapshot.hasError) {
                print("snapshot: ");
                print(snapshot);
                print("//snapshot");
                resultado = "Erro ao carregar dados";
              } else {
                resultado = "Dados ok";
                return ListView.builder(
                    itemCount: snapshot.data!.length + 1,
                    itemExtent: 100,
                    itemBuilder: (context, index) {
                      if (index == snapshot.data!.length) {

                        return ListTile(

                          title: Text("Dados fornecidos por CPTEC/INPE",
                          textAlign: TextAlign.center,),
                          subtitle: Text("http://www.cptec.inpe.br/",
                            textAlign: TextAlign.center,),
                          dense: false,
                          visualDensity:
                          VisualDensity(horizontal: 0.0, vertical: 4.0),
                        );



                      }else{
                        List<PrevisaoCptec>? previsao = snapshot.data;
                        PrevisaoCptec prev = previsao![index];

                        return ListTile(
                          leading: Column(
                            children: [
                              Flexible(
                                flex: 4,
                                child: Image.network(
                                  "http://img0.cptec.inpe.br/~rgrafico/icones_principais/tempo/icones/" +
                                      prev.ico +
                                      ".png",
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              Flexible(
                                  flex: 1,
                                  //fit: FlexFit.tight,
                                  child: Text(prev.dia)),
                              /*Flexible(
                              flex:1,
                              child: Text(prev.data),
                            ),*/
                            ],
                          ),
                          trailing: Column(
                            children: [
                              Text(prev.max+"°C",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 20,
                                  )
                              ),
                              Text(
                                  prev.min+"°C",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontSize: 18,
                                  )

                              ),
                            ],
                          ),
                          title: Text(

                            prev.desc.replaceAll("Ã³", "ó").
                            replaceAll("Ã¡", "á").
                            replaceAll("Ã£", "ã").
                            replaceAll("Ã", "í").
                            replaceAll("Ã©", "é").
                            replaceAll("Ã§", "ç"),
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text("Probabilidade de chuva: " + prev.prob,
                            textAlign: TextAlign.center),
                          dense: false,
                          visualDensity:
                          VisualDensity(horizontal: 0.0, vertical: 4.0),
                        );




                      }



                    });
              }
              break;
          }
          return Text(resultado);
        },
      ),
    );
  }
}
