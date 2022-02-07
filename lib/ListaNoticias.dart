import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:mapas_e_geolocalizacao/Noticias.dart';
import 'package:flutter/material.dart';


var dadosJson;
Color corAlerta = Colors.grey;

class ListaNoticias extends StatefulWidget {
  const ListaNoticias({Key? key}) : super(key: key);

  @override
  _ListaNoticiasState createState() => _ListaNoticiasState();
}

class _ListaNoticiasState extends State<ListaNoticias> {
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  http.Client sgmClient() {
    var ioClient = new HttpClient()..badCertificateCallback = _certificateCheck;

    return new IOClient(ioClient);
  }

  String urlbase = "https://sgm.ouropreto.mg.gov.br/apps/defesa_civil/";

  Future<List<Noticias>> _recuperarNoticia() async {
    var client = sgmClient();
    //final args = ModalRoute.of(context)!.settings.arguments as Map;
    var response;
    try {
      response = await client.post(Uri.parse(
          urlbase + "noticias.php"));
    } finally {
      client.close();
    }

    print(response.body);

    var dadosJson = json.decode(response.body);

    List<Noticias> noticia = [];

    for (var not in dadosJson) {
      Noticias p = Noticias(
        not["id"].toString(),
        not["titulo"].toString(),
        not["dt"].toString(),
        not["img"].toString(),
      );
      noticia.add(p);

    }
    return noticia;
  }

  //_post() {}

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(44, 24, 96, 1),
        title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Image.asset(
            "images/ic_launcher.png",
            fit: BoxFit.fitHeight,
          ),
          Text("Notícias", textScaleFactor: 1),
        ]),

      ),
      body: FutureBuilder<List<Noticias>>(
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
                List<Noticias>? noticia = snapshot.data;



                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    //itemExtent: 100,
                    itemBuilder: (context, index) {


                      Noticias not =
                      noticia![index];

                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, "/listanoticia", arguments:  {
                            'id':not.id,
                          },);

                        },
                        minLeadingWidth: 0,
                        leading: Image.network((not.img).replaceAll("https", "http"),
                          height: 70,
                        ),


                        title: Text(
                          not.titulo,
                          style: TextStyle(
                            //fontWeight: FontWeight.bold,
                            color: Colors.black,

                            fontSize: 15,
                            height: 1.2,

                          ),
                          textAlign: TextAlign.justify,
                        ),
                        subtitle: Text(not.dt,
                                //prev.acc24h,
                                style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  //color: corEstado,
                                  fontSize: 13,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.end),


                        dense: false,
                        visualDensity:
                        VisualDensity(horizontal: 0.0, vertical: 4.0),
                      );

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
