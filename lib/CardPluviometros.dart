import 'dart:ffi';

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
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:mapas_e_geolocalizacao/Strings.dart';

var dadosJsonAlerta;
Color corAlerta = Colors.grey;


int _nivelAlerta(double medicao)  {
  if (medicao >= 128) return 4;
  else if (medicao >= 22) return 3;
  else if (medicao >= 1) return 2;
  else return 1;


}


String _estadoAlerta(double medicao)  {
  if (medicao >= 128) return "Alerta Máximo";
  else if (medicao >= 22) return "Alerta";
  else if (medicao >= 1) return "Atenção";
  else return "Observação";

}



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
                          minLeadingWidth: 0,

                          title: Card(



                          clipBehavior: Clip.antiAlias,
                          elevation: 2,
                          //dense: true,
                          /*onTap: () {
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
                                    ))),
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
                          },*/
                          //visualDensity: VisualDensity(vertical: 4, horizontal: 4),
                          child: Column(
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Ouro Preto - Sede",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              Text(
                                dadosJsonAlerta[0]["nome"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),



                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 25,
                                    color: Colors.green,
                                    margin: EdgeInsets.all(2),
                                    child: corAlerta == Colors.green ?Icon(Icons.arrow_downward_outlined,
                                      color: Colors.white,
                                      size: 20,):null,


                                  ),
                                  Container(
                                    margin: EdgeInsets.all(2),
                                    width: 60,
                                    height: 25,
                                    color: Colors.yellowAccent,
                                    child: corAlerta == Colors.yellowAccent?Icon(Icons.arrow_downward_outlined,
                                      color: Colors.white,
                                      size: 20,):null,

                                  ),
                                  Container(
                                    margin: EdgeInsets.all(2),
                                    width: 60,
                                    height: 25,
                                    color: Colors.orange,
                                    //decoration: BoxDecoration(color: Colors.orange),
                                    child: corAlerta == Colors.orange?Icon(Icons.arrow_downward_outlined,
                                      color: Colors.white,
                                      size: 20,):null,
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(2),
                                    width: 60,
                                    height: 25,
                                    color: Colors.red,
                                    child: corAlerta == Colors.red?Icon(Icons.arrow_downward_outlined,
                                      color: Colors.white,
                                      size: 20,):null,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 25,
                                    //color: Colors.green,
                                    margin: EdgeInsets.all(2),
                                    child: Text("0",
                                      textAlign: TextAlign.center,),

                                  ),
                                  Container(
                                    margin: EdgeInsets.all(2),
                                    width: 60,
                                    height: 25,
                                    child: Text("1 a 22",
                                      textAlign: TextAlign.center,),
                                    //color: Colors.yellowAccent,

                                  ),
                                  Container(
                                    margin: EdgeInsets.all(2),
                                    width: 60,
                                    height: 25,
                                    child: Text("22 a 128",
                                      textAlign: TextAlign.center,),
                                    //color: Colors.orange,
                                    //decoration: BoxDecoration(color: Colors.orange),

                                  ),
                                  Container(
                                    margin: EdgeInsets.all(2),
                                    width: 60,
                                    height: 25,
                                    child: Text(">128",
                                      textAlign: TextAlign.center,),
                                    //color: Colors.red,
                                  ),
                                ],
                              ),


                              OutlinedButton(
                                child: Text("Saiba Mais"),
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
                                                        dadosJsonAlerta[0]["descricao"]+"\n\n"+Strings.importante,
                                                        textAlign: TextAlign.justify,
                                                        style: TextStyle(
                                                          //fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                          //fontSize: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ))),
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





                            ],
                          ),



                          /*Text(
                            dadosJsonAlerta[0]["nome"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),*/
                          //minVerticalPadding: 20,
                          //minLeadingWidth: 50,
                          /*leading: Icon(
                            Icons.waves,
                            color: corAlerta,
                            //size: 40,
                          ),*/
                          /*trailing: TextButton(
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
                                      ))),
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
                          ),*/
                        ),

                          dense: false,
                          visualDensity:
                          VisualDensity(horizontal: 0.0, vertical: 4.0),
                        );



















                      } else {
                        List<Pluviometro>? pluviometro = snapshot.data;
                        Pluviometro pluv = pluviometro![index - 1];
                        String estado = "";
                        double acc5d = 0.0;
                        double acc12M = 850;

                        Color corEstado = Colors.blueAccent;
                        int acc24h = 0;
                        pluvMax5d=100;
                        pluvMaxDia=100;
                        pluvMax12M=100;


                        if (pluv.bool_ativo == "1") {
                          if (pluv.acc5d != "null" && pluv.acc24h != "null" && pluv.acc12M != "null") {
                            acc5d = double.parse(pluv.acc5d);
                            acc24h = double.parse(pluv.acc24h).toInt();
                            acc12M = double.parse(pluv.acc12M);


                          } else
                            estado = "inativo";
                        } else
                          estado = "inativo";
                        if (acc5d > pluvMax5d){

                          pluvMax5d=(((acc5d/100).toInt()+1)*100);
                        }
                        if (acc24h > pluvMaxDia){

                          pluvMaxDia=(((acc24h/100).toInt()+1)*100);
                        }
                        if (acc12M > pluvMax12M){

                          pluvMax12M=(((acc12M/500).toInt()+1)*500);
                        }

                        return ListTile(
                          minLeadingWidth: 0,
                          /*onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/listapluviometro12M",
                              arguments: {
                                'id': pluv.id,
                                'local': pluv.nome,
                              },
                            );
                          },*/


                          title: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 2,
                            child: Column(
                              children: [
                                ListTile(
                                  //leading: Icon(Icons.arrow_drop_down_circle),
                                  title: Text(
                                    pluv.nome,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,

                                      //fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  /*subtitle: Text(
                                    'Secondary Text',
                                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                  ),*/
                                ),


                                Text(
                                  "Estado de "+_estadoAlerta(acc5d),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),



                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 25,
                                      color: Colors.green,
                                      margin: EdgeInsets.all(2),
                                      child: _nivelAlerta(acc5d) == 1?Icon(Icons.arrow_downward_outlined,
                                          color: Colors.white,
                                          size: 20,):null,

                                      
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(2),
                                      width: 60,
                                      height: 25,
                                      color: Colors.yellowAccent,
                                      child: _nivelAlerta(acc5d) == 2?Icon(Icons.arrow_downward_outlined,
                                        color: Colors.white,
                                        size: 20,):null,

                                    ),
                                    Container(
                                      margin: EdgeInsets.all(2),
                                      width: 60,
                                      height: 25,
                                      color: Colors.orange,
                                      //decoration: BoxDecoration(color: Colors.orange),
                                      child: _nivelAlerta(acc5d) == 3?Icon(Icons.arrow_downward_outlined,
                                        color: Colors.white,
                                        size: 20,):null,
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(2),
                                      width: 60,
                                      height: 25,
                                      color: Colors.red,
                                      child: _nivelAlerta(acc5d) == 4?Icon(Icons.arrow_downward_outlined,
                                        color: Colors.white,
                                        size: 20,):null,
                                    ),
                                  ],
                                ),



                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 25,
                                      //color: Colors.green,
                                      margin: EdgeInsets.all(2),
                                      child: Text("0",
                                      textAlign: TextAlign.center,),

                                    ),
                                    Container(
                                      margin: EdgeInsets.all(2),
                                      width: 60,
                                      height: 25,
                                      child: Text("1 a 22",
                                        textAlign: TextAlign.center,),
                                      //color: Colors.yellowAccent,

                                    ),
                                    Container(
                                      margin: EdgeInsets.all(2),
                                      width: 60,
                                      height: 25,
                                      child: Text("22 a 128",
                                        textAlign: TextAlign.center,),
                                      //color: Colors.orange,
                                      //decoration: BoxDecoration(color: Colors.orange),
                                     
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(2),
                                      width: 60,
                                      height: 25,
                                      child: Text(">128",
                                        textAlign: TextAlign.center,),
                                      //color: Colors.red,
                                    ),
                                  ],
                                ),
                                OutlinedButton(
                                  child: Text("Saiba Mais"),
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
                                                          Strings.observacaoPluv+ "\n\n"+ infoAlerta(acc5d),
                                                          textAlign: TextAlign.justify,
                                                          style: TextStyle(
                                                            //fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            //fontSize: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    ))),
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





                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              "/listapluviometrolocal",
                                              arguments: {
                                                'id': pluv.id,
                                                'local': pluv.nome,
                                              },
                                            );
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text("24 horas"),
                                              Text(
                                                "\n" +
                                                    pluvMaxDia.toInt().toString() + " mm",
                                                style: TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.black,

                                                  fontSize: 11,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    height: 100,
                                                    child: FAProgressBar(
                                                      maxValue: pluvMaxDia.toInt(),
                                                      size: 10,
                                                      direction: Axis.vertical,
                                                      verticalDirection:
                                                          VerticalDirection.up,
                                                      currentValue: acc24h,

                                                      //int.parse(pluv.acc24h),
                                                      //displayText: 'mm',
                                                      progressColor:
                                                          Colors.blueAccent,
                                                      //border: BoxBorder.lerp(a, b, t),
                                                      backgroundColor:
                                                          Colors.black12,
                                                      //displayTextStyle: TextStyle(color: Colors.black,),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40,
                                                    height: 100,
                                                    child: Text(
                                                        acc24h.toStringAsFixed(1)),
                                                    alignment: Alignment.lerp(
                                                        Alignment.bottomLeft,
                                                        Alignment.topLeft,
                                                        acc24h / pluvMaxDia),
                                                  ),
                                                ],
                                              ),

                                              Text("0",
                                                style: TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.black,

                                                  fontSize: 11,
                                                ),
                                                textAlign:
                                                TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ),

                                        VerticalDivider(
                                          //width: 1,
                                          thickness: 3,

                                          color: Colors.black12,
                                        ),

                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              "/listapluviometro5d",
                                              arguments: {
                                                'id': pluv.id,
                                                'local': pluv.nome,
                                              },
                                            );
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text("5 dias"),
                                              Text(
                                                "\n" +
                                                    pluvMax5d.toInt().toString() + " mm",
                                                style: TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.black,

                                                  fontSize: 11,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    height: 100,
                                                    child: FAProgressBar(
                                                      maxValue: pluvMax5d.toInt(),
                                                      size: 10,
                                                      direction: Axis.vertical,
                                                      verticalDirection:
                                                          VerticalDirection.up,
                                                      currentValue: acc5d.toInt(),

                                                      //int.parse(pluv.acc24h),
                                                      //displayText: 'mm',
                                                      progressColor:
                                                          Colors.blueAccent,
                                                      //border: BoxBorder.lerp(a, b, t),
                                                      backgroundColor:
                                                          Colors.black12,
                                                      //displayTextStyle: TextStyle(color: Colors.black,),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40,
                                                    height: 100,
                                                    child: Text(
                                                        acc5d.toStringAsFixed(1)),
                                                    alignment: Alignment.lerp(
                                                        Alignment.bottomLeft,
                                                        Alignment.topLeft,
                                                        acc5d / pluvMax5d),
                                                  ),
                                                ],
                                              ),

                                                Text("0",
                                                style: TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.black,

                                                  fontSize: 11,
                                                ),
                                                textAlign:
                                                TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                        VerticalDivider(
                                          //width: 1,
                                          thickness: 3,

                                          color: Colors.black12,
                                        ),

                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              "/listapluviometro12M",
                                              arguments: {
                                                'id': pluv.id,
                                                'local': pluv.nome,
                                              },
                                            );
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text("12 meses"),
                                              Text(
                                                "\n" +
                                                    pluvMax12M.toInt().toString() + " mm",
                                                style: TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.black,

                                                  fontSize: 11,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    height: 100,
                                                    child: FAProgressBar(
                                                      maxValue: pluvMax12M.toInt(),
                                                      size: 10,
                                                      direction: Axis.vertical,
                                                      verticalDirection:
                                                      VerticalDirection.up,
                                                      currentValue: acc12M.toInt(),

                                                      //int.parse(pluv.acc24h),
                                                      //displayText: 'mm',
                                                      progressColor:
                                                      Colors.blueAccent,
                                                      //border: BoxBorder.lerp(a, b, t),
                                                      backgroundColor:
                                                      Colors.black12,
                                                      //displayTextStyle: TextStyle(color: Colors.black,),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40,
                                                    height: 100,
                                                    child: Text(
                                                        acc12M.toStringAsFixed(0)),
                                                    alignment: Alignment.lerp(
                                                        Alignment.bottomLeft,
                                                        Alignment.topLeft,
                                                        acc12M / pluvMax12M),
                                                  ),
                                                ],
                                              ),

                                              Text("0",
                                                style: TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.black,

                                                  fontSize: 11,
                                                ),
                                                textAlign:
                                                TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ),


                                      ],
                                    ),

                                  ),
                                ),


                              ],
                            ),
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
