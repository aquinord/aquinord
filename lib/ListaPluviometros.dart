import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:mapas_e_geolocalizacao/Parametros.dart';
import 'Pluviometro.dart';
//import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';

var dadosJsonAlerta;
Color corAlerta = Colors.grey;

class ListaPluviometros extends StatefulWidget {
  const ListaPluviometros({Key? key}) : super(key: key);

  @override
  _ListaPluviometrosState createState() => _ListaPluviometrosState();
}

class _ListaPluviometrosState extends State<ListaPluviometros> {
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  http.Client sgmClient() {
    var ioClient = new HttpClient()..badCertificateCallback = _certificateCheck;

    return new IOClient(ioClient);
  }

  String urlbase = "https://sgm.ouropreto.mg.gov.br/apps/defesa_civil/";

  Future<List<Pluviometro>> _recuperarPluviometro() async {
    var client = sgmClient();

    var response, getAlerta;
    try {
      response = await client.post(Uri.parse(urlbase + "pluviometros.php"));
      getAlerta = await client.post(Uri.parse(urlbase + "getAlerta.php"));
    } finally {
      client.close();
    }

    //print(getAlerta.body);

    var dadosJson = json.decode(response.body);
    dadosJsonAlerta = json.decode(getAlerta.body);
    //print(dadosJsonAlerta[0]["descricao"]);
    List<Pluviometro> pluviometro = [];

    for (var prev in dadosJson) {
      Pluviometro p = Pluviometro(
        prev["id"].toString(),
        prev["codEstacao"].toString(),
        prev["latitude"].toString(),
        prev["longitude"].toString(),
        prev["cidade"].toString(),
        prev["nome"].toString(),
        prev["uf"].toString(),
        prev["bool_ativo"].toString(),
        prev["acc24h"].toString(),
        prev["acc5d"].toString(),
        prev["acc12m"].toString(),
        prev["qtd_leituras"].toString(),
      );
      if (p.bool_ativo == "1") pluviometro.add(p);
    }
    return pluviometro;
  }

  //_post() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(44, 24, 96, 1),
        title: Text("Pluviômetros"),
        /*actions: [
          IconButton(
              onPressed: () {
                //Navigator.pushNamed(context, "/");
              },
              icon: Icon(Icons.arrow_back_ios_sharp)),
          IconButton(
              onPressed: () {}, icon: Icon(Icons.arrow_forward_ios_sharp)),
        ],*/
      ),
      body: FutureBuilder<List<Pluviometro>>(
        future: _recuperarPluviometro(),
        builder: (context, snapshot) {
          double _currentSliderValue = 20;
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


                switch (dadosJsonAlerta[0]["nivel"]) {
                  case "1":
                    corAlerta = Colors.green;
                    break;
                  case "2":
                    corAlerta = Colors.yellowAccent;
                    break;
                  case "3":
                    corAlerta = Colors.orange;
                    break;
                  case "4":
                    corAlerta = Colors.red;
                    // do something else
                    break;
                }


                return ListView.builder(
                    itemCount: snapshot.data!.length + 1,
                    //itemExtent: 200,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ListTile(
                          //dense: true,
                          onTap: () {
                            showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      content: SingleChildScrollView(
                                          child: Container(
                                              child: Column(
                                    children: [
                                      Text(
                                        dadosJsonAlerta[0]["descricao"],
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          //fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  )
                                          )
                                      ),
                                    actions: [
                                      TextButton(
                                        child: Icon(Icons.done),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),

                                    ],
                                  );
                                });
                          },
                          //visualDensity: VisualDensity(vertical: 4, horizontal: 4),
                          title: Text(
                            dadosJsonAlerta[0]["nome"],
                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          minVerticalPadding: 20,
                          minLeadingWidth: 50,
                          leading: Icon(Icons.waves,
                            color: corAlerta,
                            //size: 40,
                          ),
                           trailing: TextButton(
                             child: Icon(Icons.add),
                             onPressed: () {
                               showCupertinoDialog(
                                   context: context,
                                   builder: (BuildContext context) {
                                     return AlertDialog(
                                       content: SingleChildScrollView(
                                           child: Container(
                                               child: Column(
                                                 children: [
                                                   Text(
                                                     dadosJsonAlerta[0]["descricao"],
                                                     textAlign: TextAlign.justify,
                                                     style: TextStyle(
                                                       //fontWeight: FontWeight.bold,
                                                       color: Colors.black,
                                                       //fontSize: 20,
                                                     ),
                                                   ),
                                                 ],
                                               )
                                           )
                                       ),
                                       actions: [
                                         TextButton(
                                           child: Icon(Icons.done),
                                           onPressed: () {
                                             Navigator.of(context).pop();
                                           },
                                         ),

                                       ],
                                     );
                                   });
                             },
                           ),
                        );
                      } else {
                        List<Pluviometro>? pluviometro = snapshot.data;
                        Pluviometro pluv = pluviometro![index - 1];
                        String estado = "";
                        double acc5d = 0.0;
                        Color corEstado = Colors.blueAccent;

                        if (pluv.bool_ativo == "1") {
                          if (pluv.acc5d != "null") {
                            acc5d = double.parse(pluv.acc5d);
                            /*acc5d > 128.0
                                ? {
                                    estado = "Alerta Máximo",
                                    corEstado = Colors.red
                                  }
                                : acc5d > 22.0
                                    ? {
                                        estado = "Alerta",
                                        corEstado = Colors.orange
                                      }
                                    : acc5d > 0
                                        ? {
                                            estado = "Atenção",
                                            corEstado = Colors.yellowAccent
                                          }
                                        : {
                                            estado = "Observação",
                                            corEstado = Colors.green
                                          };*/
                          } else
                            estado = "inativo";
                        } else
                          estado = "inativo";

                        return ListTile(

                          minLeadingWidth: 0,
                          onTap: (){
                            Navigator.pushNamed(context, "/listapluviometro12M",
                              arguments:  {
                                'id':pluv.id,'local':pluv.nome,
                              },);

                          },

                          leading: Container(
                            //width: 200 ,
                            height: 1000,



                            child: RotatedBox(
                                quarterTurns: 3,
                              //width: 200 ,
                              //height: 200,
                                child: LinearPercentIndicator(
                                  //width: 100,
                                  alignment: MainAxisAlignment.start,
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),




                                  leading: RotatedBox(quarterTurns: 1,
                                  child: Text("0",
                                    style: TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.black,

                                      fontSize: 11,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),),


                                  trailing: RotatedBox(quarterTurns: 1,
                                    child: Text(pluvMaxDia.toInt().toString(),
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        color: Colors.black,

                                        fontSize: 11,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),),


                                  percent:
                                  min(1, double.parse(pluv.acc24h) / pluvMaxDia),
                                  progressColor: corEstado,
                                  lineHeight: 8,
                                )),


                          ),

                          /*Icon(Icons.waves,
                                      color: corEstado,
                          //size: 40,
                        ),*/

                          trailing: RotatedBox(
                              quarterTurns: 3,
                              child: LinearPercentIndicator(
                                //width: 100,
                                alignment: MainAxisAlignment.start,
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),




                                leading: RotatedBox(quarterTurns: 1,
                                  child: Text("0",
                                    style: TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.black,

                                      fontSize: 11,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),),


                                trailing: RotatedBox(quarterTurns: 1,
                                  child: Text(pluvMax5d.toInt().toString(),
                                    style: TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.black,

                                      fontSize: 11,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),),


                                percent:
                                min(1, double.parse(pluv.acc5d) / pluvMax5d),
                                progressColor: corEstado,
                                lineHeight: 8,

                              )),
                          title: Text(
                            pluv.nome,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,

                              //fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  pluv.bool_ativo == "1"
                                      ? pluv.acc24h == "null"
                                          ? "24 h: -"
                                          : "24 h: " +
                                              double.parse(pluv.acc24h)
                                                  .toStringAsFixed(2) +
                                              "mm"
                                      : "",
                                  //prev.acc24h,
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    //color: corEstado,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.end),




                              Text(
                                  pluv.bool_ativo == "1"
                                      ? pluv.acc5d == "null"
                                          ? "5 d: -"
                                          : "5 d: " +
                                              double.parse(pluv.acc5d)
                                                  .toStringAsFixed(2) +
                                              "mm"
                                      : "Inativo",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    //color: corEstado,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.start),
                            ],
                          ),
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
