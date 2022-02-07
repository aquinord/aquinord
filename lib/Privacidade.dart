import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:io';
//import 'package:html/dom.dart';

import 'dart:async';



String urlbase =
    "https://ouropreto.mg.gov.br/apps/defesa-civil/politica-privacidade.html";


class Privacidade extends StatefulWidget {
  const Privacidade({Key? key}) : super(key: key);

  @override
  _PrivacidadeState createState() => _PrivacidadeState();
}

class _PrivacidadeState extends State<Privacidade> {
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  http.Client sgmClient() {
    var ioClient = new HttpClient()..badCertificateCallback = _certificateCheck;
    return new IOClient(ioClient);
  }

  Future<String> _recuperarPolitica() async {
    var client = sgmClient();
    var response;
    try {
      response = await client.post(
        Uri.parse(urlbase),
        //encoding: SystemEncoding(),
      );

    } finally {
      client.close();
    }
    print(response.body);
    var codificado  = Latin1Codec(allowInvalid: true).encode(response.body);
    var decodificado = utf8.decode(codificado,allowMalformed: true);


    return decodificado;
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(44, 24, 96, 1),
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Image.asset(
              "images/ic_launcher.png",
              fit: BoxFit.fitHeight,
            ),
            Text("Privacidade", textScaleFactor: 1),
          ]),
        ),
        body: FutureBuilder<String>(
            future: _recuperarPolitica(),
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
                    String? politica = snapshot.data;




                    

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/pmop_logo.png",
                              height: 100,
                              //fit: BoxFit.fitHeight,
                            ),
                            /*Text(
                              "\nPolítica de Privacidade\n",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                              textScaleFactor: 1.3,
                            ),*/
                            Html(data: politica!.replaceAll("<a href=\"https://www.freeprivacypolicy.com/\">", ""),



                            ),

                          ]),
                    );
                  }
                  ;
              }
              return Text(resultado);
            }));
  }
}
