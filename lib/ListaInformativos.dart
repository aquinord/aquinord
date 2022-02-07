import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:mapas_e_geolocalizacao/Informativo.dart';
import 'package:flutter/material.dart';


var dadosJson;
Color corAlerta = Colors.grey;

class ListaInformativos extends StatefulWidget {
  const ListaInformativos({Key? key}) : super(key: key);

  @override
  _ListaInformativosState createState() => _ListaInformativosState();
}

class _ListaInformativosState extends State<ListaInformativos> {
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  http.Client sgmClient() {
    var ioClient = new HttpClient()..badCertificateCallback = _certificateCheck;

    return new IOClient(ioClient);
  }

  String urlbase = "https://sgm.ouropreto.mg.gov.br/apps/defesa_civil/";

  Future<List<Informativo>> _recuperarInformativo() async {
    var client = sgmClient();
    //final args = ModalRoute.of(context)!.settings.arguments as Map;
    var response;
    try {
      response = await client.post(Uri.parse(
          urlbase + "informativos.php"));
    } finally {
      client.close();
    }

    print(response.body);

    var dadosJson = json.decode(response.body);

    List<Informativo> informativo = [];

    for (var inf in dadosJson) {
      Informativo p = Informativo(
        inf["texto"].toString(),
        inf["nome_cidadao"].toString(),
        inf["foto_cidadao"].toString(),
        inf["foto"].toString(),
        inf["dt"].toString(),
        inf["bool_publicacao_defesa_civil"].toString(),
        inf["bool_anonimo"].toString(),
        inf["descricao"].toString(),
        inf["latitude"].toString(),
        inf["longitude"].toString(),


      );
      informativo.add(p);



    }
    return informativo;
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
          Text("Informativos", textScaleFactor: 1),
        ]),

      ),
      body: FutureBuilder<List<Informativo>>(
        future: _recuperarInformativo(),
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
                List<Informativo>? informativo = snapshot.data;
                String fotoPerfil = "";
                String nome = "";



                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    //itemExtent: 100,
                    itemBuilder: (context, index) {


                      Informativo info =
                      informativo![index];

                      bool fotoRede = false;

                      //print("index: " + index.toString() + "def: " + info.bool_publicacao_defesa_civil + "cid: " + info.bool_anonimo);
                      if (info.bool_anonimo == "1"){
                        fotoPerfil = "images/incognito.png";
                        nome = "Anônimo";

                      }else{
                        if(info.bool_publicacao_defesa_civil == "0"){
                          fotoPerfil = (info.foto_cidadao).replaceAll("https", "http");
                          fotoRede = true;
                          nome = info.nome_cidadao;


                        }else {
                          fotoPerfil = "images/ic_launcher.png";
                          nome = "Defesa Civil";

                        }

                      };




                      return ListTile(
                        minLeadingWidth: 0,
                        leading: fotoRede==true? Image.network(fotoPerfil,height: 40,)
                            :Image.asset(fotoPerfil,height: 40,),

                        title: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("\n" + nome,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(info.dt +"\n",
                                //prev.acc24h,
                                style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.end),
                            Text(
                              info.texto +"\n",
                              style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            info.foto != "null"? Image.network(info.foto.replaceAll("https", "http")):Text(""),



                          ],

                        ),
                        /*subtitle: Text(info.dt,
                            //prev.acc24h,
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              //color: corEstado,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.end),*/


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
