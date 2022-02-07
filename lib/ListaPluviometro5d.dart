import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:mapas_e_geolocalizacao/Pluviometro5d.dart';
//import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';
import 'Parametros.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

var dadosJsonAlerta;
Color corAlerta = Colors.grey;

class ListaPluviometro5d extends StatefulWidget {
  const ListaPluviometro5d({Key? key}) : super(key: key);

  @override
  _ListaPluviometro5dState createState() => _ListaPluviometro5dState();
}

class _ListaPluviometro5dState extends State<ListaPluviometro5d> {
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  http.Client sgmClient() {
    var ioClient = new HttpClient()..badCertificateCallback = _certificateCheck;

    return new IOClient(ioClient);
  }

  String urlbase = "https://sgm.ouropreto.mg.gov.br/apps/defesa_civil/";

  Future<List<Pluviometro5d>> _recuperarPluviometro() async {
    var client = sgmClient();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    var response, getAlerta;
    try {
      response = await client.post(Uri.parse(
          urlbase + "pluviometro.php?id=" + args['id'] + "&interval=1"));
    } finally {
      client.close();
    }

    //print(getAlerta.body);

    var dadosJson = json.decode(response.body);

    List<Pluviometro5d> pluviometro = [];

    for (var pluv in dadosJson) {
      Pluviometro5d p = Pluviometro5d(
        pluv["medicao"].toString(),
        pluv["hora"].toString(),
        pluv["data_dia"].toString(),
        pluv["mes"].toString(),
      );
      pluviometro.add(p);
    }
    return pluviometro;
  }

  //_post() {}

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(44, 24, 96, 1),
        title: Text(args['local']),
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
      body: FutureBuilder<List<Pluviometro5d>>(
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
                List<Pluviometro5d>? pluviometro = snapshot.data;
                for (Pluviometro5d pluv in pluviometro!) {
                  if (pluv.medicao != "null") {
                    accAux += double.parse(pluv.medicao);
                  }
                }
                print(accAux.toString());

                /*switch (dadosJsonAlerta[0]["nivel"]) {
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
                }*/

                return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 250,
                        //childAspectRatio: 3 / 2,
                        //crossAxisSpacing: 20,
                        //mainAxisSpacing: 20,
                    ),
                    itemCount: snapshot.data!.length,
                    //itemExtent: 100,

                    itemBuilder: (context, index) {
                      //print("teste");

                      Pluviometro5d pluv =
                          pluviometro[snapshot.data!.length - index - 1];
                      String estado = "";

                      Color corEstado = Colors.blueAccent;
                      double acc5d = 0.0;
                      double medicao = 0;
                      pluvMax5d=pluvMaxDia=10;

                      if (pluv.medicao != "null") {
                        accAux -= double.parse(pluv.medicao);
                        acc = accAux + double.parse(pluv.medicao);
                        acc = max(0,acc);
                        medicao = double.parse(pluv.medicao);

                      } else
                        estado = "inativo";
                      if (medicao > pluvMaxDia){

                        pluvMaxDia=(((medicao/10).toInt()+1)*10);

                      }

                      return ListTile(
                        minLeadingWidth: 0,



                        title: Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 2,
                          child: Column(

                            children:[ListTile(
                              //leading: Icon(Icons.arrow_drop_down_circle),
                              title: Text(
                                pluv.data_dia,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,

                                  //fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),

                            ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          //Text("24 horas"),
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
                                                width: 20,
                                                height: 100,
                                                child: FAProgressBar(
                                                  maxValue: pluvMaxDia.toInt(),
                                                  size: 10,
                                                  direction: Axis.vertical,
                                                  verticalDirection:
                                                  VerticalDirection.up,
                                                  currentValue: medicao.toInt(),

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
                                                width: 70,
                                                height: 100,
                                                child: Text(
                                                    medicao.toStringAsPrecision(3)),
                                                alignment: Alignment.lerp(
                                                    Alignment.bottomLeft,
                                                    Alignment.topLeft,
                                                    medicao / pluvMaxDia),
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



                                    ],
                                  ),
                                ),
                              ),
                             ]
                          ),
                        ),

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (indice) {
          //Navigator.of(context).pop();
          //Navigator.popAndPushNamed(context, routeName)
          switch (indice) {
            case 0:
              {
                Navigator.popAndPushNamed(
                  context,
                  "/listapluviometrolocal",
                  arguments: {
                    'id': args['id'],
                    'local': args['local'],
                  },
                );
                break;
              }
              ;
            case 2:
              {
                Navigator.popAndPushNamed(
                  context,
                  "/listapluviometro12M",
                  arguments: {
                    'id': args['id'],
                    'local': args['local'],
                  },
                );
              }
          }
        },
        type: BottomNavigationBarType.fixed,
        //fixedColor: Colors.blueAccent,
        //backgroundColor: Colors.blueAccent,
        //unselectedItemColor: Colors.blueAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back_ios),
            label: '24 horas',
            //backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline_sharp),
            label: '5 dias',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward_ios_sharp),
            label: '12 meses',
           // backgroundColor: Colors.blueAccent,
          ),
        ],
        //currentIndex: _selectedIndex,
        //selectedItemColor: Colors.amber[800],
        //onTap: _onItemTapped,
      ),
    );
  }
}
