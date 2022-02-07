import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/io_client.dart';
import 'Pluviometro12M.dart';
//import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';
import 'Parametros.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:mapas_e_geolocalizacao/PluviometroPersonalizado.dart';
import 'package:intl/intl.dart';




String dropdownValue = '12 meses';
String periodo1 = "Início: " + DateFormat('dd-MM-yyyy').format(DateTime(DateTime.now().subtract(Duration(days:5)).year, DateTime.now().subtract(Duration(days:5)).month, DateTime.now().subtract(Duration(days:5)).day)) + "\nFim: "+
    DateFormat('dd-MM-yyyy').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));


String periodo2 = "Início: " + DateFormat('dd-MM-yyyy').format(DateTime(DateTime.now().subtract(Duration(days:5)).year, DateTime.now().subtract(Duration(days:5)).month, DateTime.now().subtract(Duration(days:5)).day)) + "\nFim: "+
    DateFormat('dd-MM-yyyy').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));


String inicioURL1 = DateTime.now().subtract(Duration(days:5)).year.toString()+ "-"+DateTime.now().subtract(Duration(days:5)).month.toString() +"-"+(DateTime.now().subtract(Duration(days:5)).day).toString();
String fimURL1 = DateTime.now().year.toString()+ "-"+DateTime.now().month.toString() +"-"+(DateTime.now().day).toString();


String inicioURL2 = DateTime.now().subtract(Duration(days:5)).year.toString()+ "-"+DateTime.now().subtract(Duration(days:5)).month.toString() +"-"+(DateTime.now().subtract(Duration(days:5)).day).toString();
String fimURL2 = DateTime.now().year.toString()+ "-"+DateTime.now().month.toString() +"-"+(DateTime.now().day).toString();
double medicaoPeriodo1 = 0;
double medicaoPeriodo2 = 0;
//List<String> medicaoPersonalizada = [];

String tituloAccAtual = 'Últimos 12 meses';
String tituloAccAnterior = '12 meses anteriores';

String anoAtual = "";
String anoAnterior = "";
var now = DateTime.now();

Map<String, String> mes = {
  '01': 'Janeiro',
  '02': 'Fevereiro',
  '03': 'Março',
  '04': 'Abril',
  '05': 'Maio',
  '06': 'Junho',
  '07': 'Julho',
  '08': 'Agosto',
  '09': 'Setembro',
  '10': 'Outubro',
  '11': 'Novembro',
  '12': 'Dezembro'
};
var dadosJsonAlerta;
Color corAlerta = Colors.grey;




void _escolherPeriodos(BuildContext context) async {
  // Navigator.push returns a Future that completes after calling
  // Navigator.pop on the Selection Screen.
  final result = await Navigator.pushNamed(context, "/periodo");

}



class ListaPluviometro12M extends StatefulWidget {
  const ListaPluviometro12M({Key? key}) : super(key: key);

  @override
  _ListaPluviometro12MState createState() => _ListaPluviometro12MState();
}

class _ListaPluviometro12MState extends State<ListaPluviometro12M> {
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  http.Client sgmClient() {
    var ioClient = new HttpClient()..badCertificateCallback = _certificateCheck;

    return new IOClient(ioClient);
  }

  String urlbase = "https://sgm.ouropreto.mg.gov.br/apps/defesa_civil/";

  Future<List<Pluviometro12M>> _recuperarPluviometro() async {
    var client = sgmClient();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    var response, medicao1, medicao2;
    try {
      response = await client.post(Uri.parse(
          urlbase + "pluviometro.php?id=" + args['id'] + "&interval=2"));
      medicao1 = await client.post(Uri.parse(
          urlbase + "pluviometro.php?id=" + args['id'] + "&interval=3&inicio="+inicioURL1+"&fim="+fimURL1));
      medicao2 = await client.post(Uri.parse(
          urlbase + "pluviometro.php?id=" + args['id'] + "&interval=3&inicio="+inicioURL2+"&fim="+fimURL2));


    } finally {
      client.close();
    }
    //print(getAlerta.body);
    var dadosJson = json.decode(response.body);

    List<Pluviometro12M> pluviometro = [];

    for (var pluv in dadosJson) {
      Pluviometro12M p = Pluviometro12M(
        pluv["medicao"].toString(),
        pluv["hora"].toString(),
        pluv["data_dia"].toString(),
        pluv["mes"].toString(),
        pluv["ano"].toString(),
        pluv["ano_anterior"].toString(),
        pluv["medicao_ano_anterior"].toString(),
      );
      pluviometro.add(p);
      anoAtual = p.ano;
      anoAnterior = p.ano_anterior;
    }
    medicaoPeriodo1 = 0;
    medicaoPeriodo2 = 0;

    dadosJson = json.decode(medicao1.body);
    for (var pluv in dadosJson) {
      medicaoPeriodo1 += double.parse(pluv["medicao"]);
      //medicaoPersonalizada.add(pluv["medicao"]);
    }

    dadosJson = json.decode(medicao2.body);
    for (var pluv in dadosJson) {
      medicaoPeriodo2 += double.parse(pluv["medicao"]);
      //medicaoPersonalizada.add(pluv["medicao"]);
    }

    //print(medicaoPersonalizada);
    print(medicaoPeriodo1.toString());







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
      body: FutureBuilder<List<Pluviometro12M>>(
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
                //double acc = 0.0;
                double acc1 = 0.0;
                double acc2 = 0.0;
                double acc5d = 0.0;
                //int acc24h = 0;
                double medicaoAnoAnterior = 0;
                double medicao = 0;
                double pluvMaxAno = 100;
                double pluvMaxAcc = 100;

                //double pluvMaxAnoAnterior = 100;

                List<Pluviometro12M>? pluviometro = snapshot.data;
                for (Pluviometro12M pluv in pluviometro!) {
                  if (pluv.medicao != "null") {
                    if (dropdownValue == "Ano") {
                      if (pluv.ano == anoAtual) {
                        acc1 += double.parse(pluv.medicao);
                      }
                    } else {
                      acc1 += double.parse(pluv.medicao);
                    }
                  }
                  if (pluv.medicao_ano_anterior != "null") {
                    if (dropdownValue == "Ano") {
                      if (pluv.ano_anterior == anoAnterior) {
                        acc2 += double.parse(pluv.medicao_ano_anterior);
                      }
                    } else {
                      acc2 += double.parse(pluv.medicao_ano_anterior);
                    }
                  }

                  if (dropdownValue == "Personalizado") {
                    acc1 = medicaoPeriodo1;
                    acc2 = medicaoPeriodo2;

                  }



                  if (acc1 > pluvMaxAcc) {
                    pluvMaxAcc = (((acc1 / 500).toInt() + 1) * 500);
                  }
                  if (acc2 > pluvMaxAcc) {
                    pluvMaxAcc = (((acc2 / 500).toInt() + 1) * 500);
                  }
                }

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length + 1,
                    //itemExtent: 100,
                    itemBuilder: (context, index) {
                      //print("teste");
                      Pluviometro12M pluv =
                          pluviometro[snapshot.data!.length - 1];

                      if (index == 0) {
                        return ListTile(
                          title: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 2,
                            child: Column(
                              children: [
                                ListTile(
                                  //leading: Icon(Icons.arrow_drop_down_circle),
                                  title: Text(
                                    "Acumulado",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,

                                      //fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  subtitle: DropdownButton<String>(

                                    alignment: AlignmentDirectional.topCenter,
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 0,
                                    style: const TextStyle(
                                        color: Colors.black),
                                    /*underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),*/
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                        if (dropdownValue == "Ano") {
                                          tituloAccAtual = pluv.ano;
                                          tituloAccAnterior = pluv.ano_anterior;
                                        } else if (dropdownValue == "Personalizado"){
                                          tituloAccAtual = periodo1;
                                          tituloAccAnterior = periodo2;



                                        }else{
                                          tituloAccAtual = "Últimos 12 meses";
                                          tituloAccAnterior =
                                              "12 meses anteriores";
                                        }
                                      });
                                    },
                                    items: <String>["Ano", "12 meses", "Personalizado"]
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }).toList(),
                                  ),
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
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(tituloAccAtual),
                                            Text(
                                              "\n" +
                                                  pluvMaxAcc
                                                      .toInt()
                                                      .toString() +
                                                  " mm",
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
                                                    maxValue:
                                                        pluvMaxAcc.toInt(),
                                                    size: 10,
                                                    direction: Axis.vertical,
                                                    verticalDirection:
                                                        VerticalDirection.up,
                                                    currentValue:
                                                        acc1.toInt(),

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
                                                  width: 60,
                                                  height: 100,
                                                  child: Text(acc1
                                                      .toInt()
                                                      .toString()),
                                                  alignment: Alignment.lerp(
                                                      Alignment.bottomLeft,
                                                      Alignment.topLeft,
                                                      acc1 / pluvMaxAcc),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "0",
                                              style: TextStyle(
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.black,

                                                fontSize: 11,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ],
                                        ),

                                        VerticalDivider(
                                          //width: 1,
                                          thickness: 3,

                                          color: Colors.black12,
                                        ),


                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(tituloAccAnterior),
                                            Text(
                                              "\n" +
                                                  pluvMaxAcc
                                                      .toInt()
                                                      .toString() +
                                                  " mm",
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
                                                    maxValue:
                                                        pluvMaxAcc.toInt(),
                                                    size: 10,
                                                    direction: Axis.vertical,
                                                    verticalDirection:
                                                        VerticalDirection.up,
                                                    currentValue: acc2.toInt(),

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
                                                  width: 60,
                                                  height: 100,
                                                  child: Text(
                                                      acc2.toInt().toString()),
                                                  alignment: Alignment.lerp(
                                                      Alignment.bottomLeft,
                                                      Alignment.topLeft,
                                                      acc2 / pluvMaxAcc),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "0",
                                              style: TextStyle(
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.black,

                                                fontSize: 11,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                dropdownValue == "Personalizado"? Center(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      await Navigator.pushNamed(context, "/periodo");

                                      setState(() {
                                        tituloAccAtual = periodo1;
                                        tituloAccAnterior = periodo2;

                                      });

                                    },
                                    child: const Text('Escolher Períodos'),
                                  ),
                                ): Text(""),



                              ],
                            ),
                          ),
                          minVerticalPadding: 40,
                        );
                      } else {
                        pluv = pluviometro[snapshot.data!.length - index];
                        String estado = "";

                        Color corEstado = Colors.blueAccent;

                        if (pluv.medicao != "null") {
                          medicao = double.parse(pluv.medicao);
                        } else
                          estado = "inativo";
                        if (pluv.medicao_ano_anterior != "null") {
                          medicaoAnoAnterior =
                              double.parse(pluv.medicao_ano_anterior);
                        }

                        pluvMaxAno = 100;
                        //pluvMaxAnoAnterior = 100;

                        if (medicaoAnoAnterior > pluvMaxAno) {
                          pluvMaxAno =
                              (((medicaoAnoAnterior / 100).toInt() + 1) * 100);
                        }
                        if (medicao > pluvMaxAno) {
                          pluvMaxAno = (((medicao / 100).toInt() + 1) * 100);
                        }

                        return ListTile(
                          minLeadingWidth: 0,
                          title: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 2,
                            child: Column(
                              children: [
                                ListTile(
                                    //leading: Icon(Icons.arrow_drop_down_circle),
                                    title: Text(
                                      mes[pluv.mes].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,

                                        //fontSize: 15,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    subtitle: index == 1
                                        ? Text(
                                            'Dados de ' +
                                                anoAtual +
                                                ": até dia " +
                                                now.day.toString(),
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6)),
                                          )
                                        : Text("")),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(pluv.ano),
                                            Text(
                                              "\n" +
                                                  pluvMaxAno
                                                      .toInt()
                                                      .toString() +
                                                  " mm",
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
                                                    maxValue:
                                                        pluvMaxAno.toInt(),
                                                    size: 10,
                                                    direction: Axis.vertical,
                                                    verticalDirection:
                                                        VerticalDirection.up,
                                                    currentValue:
                                                        medicao.toInt(),

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
                                                  width: 60,
                                                  height: 100,
                                                  child: Text(medicao
                                                      .toInt()
                                                      .toString()),
                                                  alignment: Alignment.lerp(
                                                      Alignment.bottomLeft,
                                                      Alignment.topLeft,
                                                      medicao / pluvMaxAno),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "0",
                                              style: TextStyle(
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.black,

                                                fontSize: 11,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ],
                                        ),
                                        index == 1
                                            ? VerticalDivider(
                                                //width: 1,
                                                thickness: 3,

                                                color: Colors.black12,
                                              )
                                            : VerticalDivider(
                                                //width: 1,
                                                thickness: 3,

                                                color: Colors.black12,
                                              ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(pluv.ano_anterior),
                                            Text(
                                              "\n" +
                                                  pluvMaxAno
                                                      .toInt()
                                                      .toString() +
                                                  " mm",
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
                                                    maxValue:
                                                        pluvMaxAno.toInt(),
                                                    size: 10,
                                                    direction: Axis.vertical,
                                                    verticalDirection:
                                                        VerticalDirection.up,
                                                    currentValue:
                                                        medicaoAnoAnterior
                                                            .toInt(),

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
                                                  width: 60,
                                                  height: 100,
                                                  child: Text(medicaoAnoAnterior
                                                      .toInt()
                                                      .toString()),
                                                  alignment: Alignment.lerp(
                                                      Alignment.bottomLeft,
                                                      Alignment.topLeft,
                                                      medicaoAnoAnterior /
                                                          pluvMaxAno),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "0",
                                              style: TextStyle(
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.black,

                                                fontSize: 11,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ],
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
                      ;
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
                  "/listapluviometro5d",
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
                  "/listapluviometrolocal",
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
        //unselectedItemColor: Colors.blueAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back_ios),
            label: '5 dias',
            //backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline_sharp),
            label: '12 meses',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward_ios_sharp),
            label: '24 horas',
            //backgroundColor: Colors.blueAccent,
          ),
        ],
        //currentIndex: _selectedIndex,
        //selectedItemColor: Colors.amber[800],
        //onTap: _onItemTapped,
      ),
    );
  }
}
