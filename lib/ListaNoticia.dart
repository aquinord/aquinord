import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:mapas_e_geolocalizacao/Noticia.dart';
import 'package:flutter/material.dart';

var dadosJson;
Color corAlerta = Colors.grey;

class ListaNoticia extends StatefulWidget {
  const ListaNoticia({Key? key}) : super(key: key);

  @override
  _ListaNoticiaState createState() => _ListaNoticiaState();
}

class _ListaNoticiaState extends State<ListaNoticia> {
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  http.Client sgmClient() {
    var ioClient = new HttpClient()..badCertificateCallback = _certificateCheck;

    return new IOClient(ioClient);
  }

  String urlbase = "https://sgm.ouropreto.mg.gov.br/apps/defesa_civil/";

  Future<Noticia> _recuperarNoticia() async {
    var client = sgmClient();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    var response;
    try {
      response = await client.post(Uri.parse(urlbase + "noticia.php?id="+args['id']));
    } finally {
      client.close();
    }


    print(response.body);

    var dadosJson = json.decode(response.body);

    Noticia noticia = Noticia(
      dadosJson["id"].toString(),
      dadosJson["titulo"].toString(),
      dadosJson["texto"].toString(),
      dadosJson["img"].toString(),
      dadosJson["capa_interna"].toString(),
      dadosJson["album"].toString(),
    );

    return noticia;
  }

  //_post() {}

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(44, 24, 96, 1),
        title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Image.asset(
            "images/ic_launcher.png",
            fit: BoxFit.fitHeight,
          ),
          Text("Notícia", textScaleFactor: 1),
        ]),
      ),
      body: FutureBuilder<Noticia>(
        future: _recuperarNoticia(),
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
              print("teste");
              if (snapshot.hasError) {
                print("snapshot: ");
                print(snapshot);
                print("//snapshot");
                resultado = "Erro ao carregar dados";
              } else {
                resultado = "Dados ok";
                double acc = 0.0;
                double accAux = 0.0;
                Noticia? noticia = snapshot.data;
                Noticia not = noticia!;

                return SingleChildScrollView(

                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      (not.img).replaceAll("https", "http"),
                    ),



                    Text(
                      not.titulo + "\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text("     " + not.texto.replaceAll("\n", "\n\n     "),
                        //prev.acc24h,
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          //color: corEstado,
                          fontSize: 15,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.justify,


                      ),
                    ),




                  ],
                ));
              }
              break;
          }
          return Text(resultado);
        },
      ),
    );
  }
}
