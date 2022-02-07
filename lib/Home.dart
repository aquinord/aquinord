import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:mapas_e_geolocalizacao/ImagemArea.dart';
import 'package:mapas_e_geolocalizacao/AreaRisco.dart';
import 'package:mapas_e_geolocalizacao/Parametros.dart';
import 'package:mapas_e_geolocalizacao/Strings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as  maps_toolkit;
import 'package:mapas_e_geolocalizacao/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool info = false;
bool dadosOk = false;
var dadosJsonAlerta, dadosJsonPluviometros, dadosJsonIncidentes;
int localAtual = 0;
Color corAlerta = Colors.black12;
double acc5d = 0;
double acc24h = 0;





class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;



  http.Client sgmClient() {
    var ioClient = new HttpClient()..badCertificateCallback = _certificateCheck;
    return new IOClient(ioClient);
  }


  Color _corNivel(String nivel){
    Color cor = Colors.black12;
    switch (nivel) {
      case "1":
        cor = Colors.green;
        break;
      case "2":
        cor = Colors.yellowAccent;
        break;
      case "3":
        cor = Colors.orange;
        break;
      case "4":
        cor = Colors.red;
        // do something else
        break;
    }




    return cor;
  }


  Map<String,String> _dadosPluviometro(int local){
    String risco = "";
    String pluv24hs = "0.0";
    String pluv5d = "0.0";
    String nivel = "1";
    double medicao = 0;
    double pluv24hsD = 0;
    double pluv5dD = 0;
    int pluvAtivos = 0;
    double minDist = -1;
    double distancia =0;
    int i =0;


    print(localidades[local].local);
    maps_toolkit.LatLng coordenadasLocal = maps_toolkit.LatLng(localidades[local].lat,localidades[local].long);
    maps_toolkit.LatLng coordenadasPluviometro = maps_toolkit.LatLng(localidades[local].lat,localidades[local].long);

    for (var dado in dadosJsonPluviometros) {
      if(dado["bool_ativo"] == "1" && dado["qtd_leituras"] != "0") {
        coordenadasPluviometro = maps_toolkit.LatLng(
            double.parse(dado["latitude"]), double.parse(dado["longitude"]));
        distancia = maps_toolkit.SphericalUtil.computeDistanceBetween(
            coordenadasLocal, coordenadasPluviometro).toDouble();

        if (minDist == -1)
          minDist = distancia;
        else if (distancia < minDist)
          minDist = distancia;
      }
        };
    i=0;
    pluvAtivos = 0;
    pluv24hsD = 0;
    pluv5dD = 0;
    medicao = 0;


    for (var dado in dadosJsonPluviometros) {
      coordenadasPluviometro = maps_toolkit.LatLng(double.parse(dado["latitude"]),double.parse(dado["longitude"]));
      distancia = maps_toolkit.SphericalUtil.computeDistanceBetween(coordenadasLocal, coordenadasPluviometro).toDouble();


      if ((distancia <= minDist + minDistPluv) && dado["bool_ativo"] == "1" && dado["qtd_leituras"] != "0") {
        print('Distância $distancia m.');
        print(dado["nome"]);
        //print(dadosJsonPluviometros[i]["acc24h"]);
        if (dadosJsonPluviometros[i]["acc24h"] != null) pluv24hsD += double.parse(dadosJsonPluviometros[i]["acc24h"]!);
        if (dadosJsonPluviometros[i]["acc5d"] != null) pluv5dD += double.parse(dadosJsonPluviometros[i]["acc5d"]!);
        pluvAtivos +=1;

      }
      i++;


    };

    if (pluvAtivos >0){
      pluv5d = (pluv5dD/pluvAtivos).toStringAsFixed(2);
      pluv24hs = (pluv24hsD/pluvAtivos).toStringAsFixed(2);
    }
    else {
      if (pluvAtivos >0){
        pluv5d = "0.00";
        pluv24hs = "0.00";
      }
    }

    //maps_toolkit.LatLng coordenadasPluviometro = maps_toolkit.LatLng(double.parse(dadosJsonPluviometros[i]["latitude"]),double.parse(dadosJsonPluviometros[i]["longitude"]));








/*    if (dadosJsonPluviometros[localidades[local].id]["bool_ativo"] == "1" && localidades[local].id!=0)
      {

        pluv5d = dadosJsonPluviometros[localidades[local].id]["acc5d"];
        pluv5d.length > 5? pluv5d = pluv5d.substring(0, 5):null;
        pluv24hs = dadosJsonPluviometros[localidades[local].id]["acc24h"];
        pluv24hs.length > 5? pluv24hs = pluv24hs.substring(0, 5):null;

      };*/




   /* if (localidades[local].id==0)
    {
      if (dadosJsonPluviometros[6]["bool_ativo"] == "1")
      {
        //pluv24hsD += double.parse(dadosJsonPluviometros[6]["acc24h"]!);
        pluv5dD += double.parse(dadosJsonPluviometros[6]["acc5d"]!);
        pluvAtivos +=1;

      }

      if (dadosJsonPluviometros[7]["bool_ativo"] == "1")
          {
            pluv24hsD += double.parse(dadosJsonPluviometros[7]["acc24h"]!);
            pluv5dD += double.parse(dadosJsonPluviometros[7]["acc5d"]!);
            pluvAtivos +=1;

          }
      if (dadosJsonPluviometros[8]["bool_ativo"] == "1")
      {
        pluv24hsD += double.parse(dadosJsonPluviometros[8]["acc24h"]!);
        pluv5dD += double.parse(dadosJsonPluviometros[8]["acc5d"]!);
        pluvAtivos +=1;

      }
      if (dadosJsonPluviometros[9]["bool_ativo"] == "1")
      {
        //pluv24hsD += double.parse(dadosJsonPluviometros[9]["acc24h"]!);
        pluv5dD += double.parse(dadosJsonPluviometros[9]["acc5d"]!);
        pluvAtivos +=1;

      }
      if (dadosJsonPluviometros[10]["bool_ativo"] == "1")
      {
        pluv24hsD += double.parse(dadosJsonPluviometros[10]["acc24h"]!);
        pluv5dD += double.parse(dadosJsonPluviometros[10]["acc5d"]!);
        pluvAtivos +=1;

      }
      if (pluvAtivos >0){
        pluv5d = (pluv5dD/pluvAtivos).toStringAsFixed(2);
        pluv24hs = (pluv24hsD/pluvAtivos).toStringAsFixed(2);


      }

*//*      pluv5d = dadosJsonPluviometros[localidades[local].id]["acc5d"];
      pluv5d.length > 5? pluv5d = pluv5d.substring(0, 5):null;
      pluv24hs = dadosJsonPluviometros[localidades[local].id]["acc24h"];
      pluv24hs.length > 5? pluv24hs = pluv24hs.substring(0, 5):null;*//*

    };*/



    if (pluv5d != "null")  medicao =  double.parse(pluv5d);


    if(localidades[local].id==0){
      risco = dadosJsonAlerta[0]["nome"];
      nivel = dadosJsonAlerta[0]["nivel"];



    }
    else {


        if (medicao >= 128) {
          risco = "Alerta Máximo";
          nivel = "4";
        }
        else if (medicao >= 22) {
          risco = "Estado de Alerta";
          nivel = "3";
        }
        else if (medicao >= 1) {
          risco = "Estado de Atenção";
          nivel = "2";
        } else {
          risco = "Estado de Observação";
          nivel = "1";
        }

          if (pluvAtivos == 0)
          {
            risco = "Pluviometro Inativo";

          };




    }



    Map<String,String> dados = {"risco":risco,"24hs":pluv24hs,"5d":pluv5d, "nivel":nivel};

    return dados;
  }

  Map<String,int> _dadosIncidentes(){
    Map<String,int> dados = {};


    for (var dado in dadosJsonIncidentes) {
      dados.addAll({dado["descricao"]:int.parse(dado["id"])});
      tipoIncidente.add(dado["descricao"]);



    };
    tipoIncidente.sort();


    print(dados);
    return dados;
  }

  int _maxPercentual(double acc){
    int pluvMax = 20;
    if (acc > pluvMax){
      pluvMax=(((acc/100).toInt()+1)*100);
    }
    return pluvMax;
  }

  Color _corRisco(int descricaoRisco) {
    switch (descricaoRisco) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Color.fromRGBO(243, 127, 2, 1.0);
      case 4:
        return Colors.red;
    }
    return Colors.grey;
  }

  String urlbase = "https://sgm.ouropreto.mg.gov.br/apps/defesa_civil";
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};
  Set<Polygon> _polygons = {};
  Set<Polygon> _listaPolygons = {};

  Future<List<AreaRisco>> _recuperarAreasRisco() async {
    var client = sgmClient();
    final CarouselController _ccontroller = CarouselController();

    var response, getPluviometros, getAlerta, getIncidentes;
    try {
      response = await client.post(Uri.parse(urlbase + "/getAreasRisco.php"));
      //print(await client.get(uriResponse.bodyFields['uri']));
      getPluviometros = await client.post(Uri.parse(urlbase + "/pluviometros.php"));
      getAlerta = await client.post(Uri.parse(urlbase + "/getAlerta.php"));
      getIncidentes = await client.post(Uri.parse(urlbase + "/tipos_ocorrencias.php"));
    } finally {
      client.close();
      dadosOk = true;
    }

    //http.Response response = await http.get(Uri.parse(urlbase + "/getAreasRisco.php"));
    var dadosJson = json.decode(response.body);
    dadosJsonAlerta = json.decode(getAlerta.body);
    dadosJsonPluviometros = json.decode(getPluviometros.body);
    dadosJsonIncidentes = json.decode(getIncidentes.body);
    print(dadosJsonIncidentes);

    mapIncidentes =  _dadosIncidentes();
    print(mapIncidentes);



    //print(dadosJsonAlerta);
    //print(dadosJsonPluviometros);

    List<AreaRisco> areasRisco = [];
    List<ImagemArea> imagens = [];
    List<String> coordenadas = [];
    List<LatLng> pontos = [];
    List<String> tiposIncidentes= [];
    //List<NetworkImage> urlImagens = [];

    //print(response.body);
    for (var area in dadosJson) {
      pontos = [];
      imagens = [];
      //urlImagens = [];
      for (var imagem in area["imagens"]) {
        //print("imagem: " + imagem["nome_arquivo"].toString());
        ImagemArea img =
            ImagemArea(int.parse(imagem["idArea"]), imagem["nome_arquivo"]);
        imagens.add(img);
        /*urlImagens
            .add(NetworkImage(Strings.url_imagem + img.nome_arquivo + ".jpg"));*/
      }
      AreaRisco a = AreaRisco(
          int.parse(area["id"]),
          int.parse(area["id_tipo_risco"]),
          area["localizacao"].toString(),
          area["descricao_risco"].toString(),
          area["tipo_risco"].toString(),
          area["coordenadas"].toString(),
          area["qtd_pessoas_risco"].toString(),
          area["qtd_imoveis_risco"].toString(),
          area["observacoes"].toString(),
          imagens);
      //print("id: " + area["id"]);
      areasRisco.add(a);
      coordenadas = a.coordenadas.split(" ");
      for (String coordenada in coordenadas) {
        List<String> coord = coordenada.split(",");
        pontos.add(LatLng(double.parse(coord[1]), double.parse(coord[0])));
      }

      Polygon polygon = Polygon(
          polygonId: PolygonId(a.id.toString()),
          fillColor: _corRisco(a.id_tipo_risco),
          strokeWidth: 1,
          strokeColor: _corRisco(a.id_tipo_risco),
          points: pontos,
          consumeTapEvents: true,

          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("DETALHES"),
                  content: Text(Strings.fonte_cprm, textScaleFactor: 0.7),
                  actions: <Widget>[


                    CarouselSlider.builder(
                      itemCount: imagens.length,
                      options: CarouselOptions(
                          autoPlay: false,
                          enlargeCenterPage: true,
                          pageSnapping: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          viewportFraction: 0.8,
                          aspectRatio: 16/9,
                          initialPage: 0,


                          onPageChanged: (index, reason) {
                            _ccontroller.stopAutoPlay();
                          }),
                      carouselController: _ccontroller,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          Container(
                        child: GestureDetector(
                          onTap: (){

                            Navigator.pushNamed(context, "/imagemfull", arguments:  {
                              'url_imagem':Strings.url_imagem +
                                  a.imagens[itemIndex].nome_arquivo +
                                  ".jpg",
                            },
                            );
                          },
                          child: Image.network(
                          Strings.url_imagem +
                              a.imagens[itemIndex].nome_arquivo +
                              ".jpg",
                          //height: 200,
                        ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: TextButton(
                            onPressed: () => _ccontroller.previousPage(),
                            child: Icon(Icons.navigate_before),
                          ),
                        ),
                        Flexible(
                          child: TextButton(
                            onPressed: () => _ccontroller.nextPage(),
                            child: Icon(Icons.navigate_next),


                          ),
                        ),

                      ],
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LOCAL: " + a.localizacao,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "TIPO DE RISCO: " + a.tipo_risco,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "NÍVEL DE RISCO: " + a.descricao_risco,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Icon(Icons.add), //new Text("+ Informações"),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Column(
                                    children: [
                                      CarouselSlider.builder(
                                        itemCount: imagens.length,
                                        options: CarouselOptions(
                                          autoPlay: false,
                                          enlargeCenterPage: true,
                                          pageSnapping: true,
                                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                                          viewportFraction: 0.8,
                                          aspectRatio: 16/9,
                                          initialPage: 0,

                                        ),
                                        carouselController: _ccontroller,

                                        itemBuilder: (BuildContext context,
                                            int itemIndex, int pageViewIndex) =>
                                            Container(
                                              child: GestureDetector(
                                                onTap: (){

                                                  Navigator.pushNamed(context, "/imagemfull", arguments:  {
                                                    'url_imagem':Strings.url_imagem +
                                                        a.imagens[itemIndex].nome_arquivo +
                                                        ".jpg",
                                                  },
                                                  );
                                                },
                                                child: Image.network(
                                                  Strings.url_imagem +
                                                      a.imagens[itemIndex].nome_arquivo +
                                                      ".jpg",
                                                  height: 100,
                                                ),
                                              ),

                                            ),

                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            child: TextButton(
                                              onPressed: () => _ccontroller.previousPage(),
                                              child: Icon(Icons.navigate_before),
                                            ),
                                          ),
                                          Flexible(
                                            child: TextButton(
                                              onPressed: () => _ccontroller.nextPage(),
                                              child: Icon(Icons.navigate_next),


                                            ),
                                          ),

                                        ],
                                      ),



                                    ],

                                  ),



                                  content: SingleChildScrollView(
                                    child: Container(
                                      child: Column(
                                        children: [

                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "OBSERVAÇÕES: ",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),

                                              ),
                                              Text(
                                                a.observacoes,
                                                textAlign: TextAlign.justify,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "IMÓVEIS EM RISCO: " +
                                                  a.qtd_imoveis_risco,
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              "PESSOAS EM RISCO: " +
                                                  a.qtd_pessoas_risco,
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        TextButton(
                                          child: Icon(Icons.done),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        TextButton(
                          child: Icon(Icons.done), //new Text("+ Informações"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
            //print(a.localizacao);
          },
          zIndex: 2);
      _listaPolygons.add(polygon);
    }



    setState(() {
      _polygons = _listaPolygons;
    });

    return areasRisco;
  }

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
    _recuperarAreasRisco();
  }

  _movimentarCamera(double lat, double lng) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(lat, lng),
          zoom: 14,
          tilt: 0,
          bearing: 0),
    ));
  }

/*  _carregarMarcadores() {
    //List<String> coordenadas = [];

*//*    Set<Marker> marcadoresLocal = {};
    Marker marcadorShopping = Marker(
        markerId: MarkerId("marcador-shopping"),
        position: LatLng(-20.385441, -43.504193),
        infoWindow: InfoWindow(
          title: "Armazem Rural"
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueMagenta
        ),
        rotation: 45,
        onTap: (){
          print("Armazem Rural");
        }
    );


    Marker marcador2 = Marker(
      markerId: MarkerId("marcador-2"),
      position: LatLng(-20.386441, -43.504193),
        infoWindow: InfoWindow(
            title: "Marcador 2"
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue
        ),
        rotation: -45,
        onTap: (){
          print("Marcador 2");
        }
    );
    marcadoresLocal.add(marcadorShopping);
    marcadoresLocal.add(marcador2);

    setState(() {
      _marcadores = marcadoresLocal;
    });

*//*

*//*    Polygon polygon1 = Polygon(
        polygonId: PolygonId("polygon1"),
        fillColor: Colors.green,
        strokeWidth: 1,
        strokeColor: Colors.green,
        points: [
          LatLng(-20.38489922069448, -43.50345765139863),
          LatLng(-20.384864021435767, -43.503028497957864),
          LatLng(-20.38499476149902, -43.50301240470383),
          LatLng(-20.385029960727866, -43.50339864280052),
        ],
        consumeTapEvents: true,
        onTap: () {
          print("clicado na área");
        },
        zIndex: 2);*//*

    Polygon polygon2 = Polygon(
        polygonId: PolygonId("polygon2"),
        fillColor: Colors.purple,
        strokeWidth: 1,
        strokeColor: Colors.green,
        points: [
          LatLng(-20.38489922069448, -43.60345765139863),
          LatLng(-20.384864021435767, -43.503028497957864),
          LatLng(-20.38499476149902, -43.50301240470383),
          LatLng(-20.385029960727866, -43.50339865280052),
        ],
        consumeTapEvents: true,
        onTap: () {
          print("clicado na área");
        },
        zIndex: 1);
    //_listaPolygons.add( polygon1 );
    //_listaPolygons.add( polygon2 );
    setState(() {
      _polygons = _listaPolygons;
    });
  }*/

  @override
  void initState() {
    super.initState();
    //print("dados ok");
    //_recuperarAreasRisco();
    /*FutureBuilder<List<AreaRisco>>(
      future: _recuperarAreasRisco(),
      builder: (context, snapshot){
        String resultado = "";
        switch(snapshot.connectionState){
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
            if(snapshot.hasError){
              resultado = "Erro ao carregar dados";
            }else{
              resultado = "Dados ok";
              print("dados ok");
              List<AreaRisco>? areasRisco = snapshot.data;
              List<LatLng> pontos = [];

              */ /*for(var area in areasRisco!) {
                coordenadas = area.coordenadas.split(" ");
                for (String coordenada in coordenadas) {
                  List<String> coord = coordenada.split(",");
                  String lat = coord[0];
                  String long = coord[1];
                  pontos.add(
                      LatLng(
                          double.parse(coord[0]),
                          double.parse(coord[1])
                      )
                  );
                  double lat1 = double.parse(lat);
                  print("latitude: " + lat1.toString());
                  print("Longitude: " + long);
                }


                Polygon polygonAR = Polygon(
                    polygonId: PolygonId(area.id.toString()),
                    fillColor: Colors.green,
                    strokeWidth: 1,
                    strokeColor: Colors.green,
                    points: pontos,
                    consumeTapEvents: true,
                    onTap: (){
                      print("clicado na área");
                    },
                    zIndex: 2
                );
                _listaPolygons.add( polygonAR );
              }
              setState(() {
                _polygons = _listaPolygons;
              });*/ /*


              */ /*return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){
                    List<AreaRisco>? areasRisco = snapshot.data;
                    AreaRisco area = areasRisco![index];

                    return ListTile(
                      title: Text(area.localizacao),
                      subtitle: Text(area.coordenadas.toString()),
                    );
                  }
              );*/ /*
            }
            break;
        }
        return Text(resultado);
      },
    );*/

    //_carregarMarcadores();




  }

  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(44, 24, 96, 1),
                ),
                child: Image.asset(
                  "images/logo_defesa_civil_ouro_preto.png",
                  fit: BoxFit.fitHeight,
                ),
              ),
              ListTile(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/listapluviometros");
                    },
                    icon: Icon(WeatherIcons.rain)),
                title: const Text('Pluviômetros'),
                onTap: () {
                  Navigator.pushNamed(context, "/listapluviometros");

                },
              ),

              ListTile(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    icon: Icon(Icons.announcement_outlined)),
                title: const Text('Relatar Incidente'),
                onTap: () {
                  Navigator.pushNamed(context, "/login");

                },
              ),
              ListTile(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/listanoticias");
                    },
                    icon: Icon(Icons.wysiwyg_outlined)),
                title: const Text('Notícias'),
                onTap: () {
                  Navigator.pushNamed(context, "/listanoticias");

                },
              ),
              ListTile(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/listainformativos");
                    },
                    icon: Icon(Icons.info_outline)),
                title: const Text('Informativos'),
                onTap: () {
                  Navigator.pushNamed(context, "/listainformativos");

                },
              ),
              ListTile(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/previsaotempo");
                    },
                    icon: Icon(WeatherIcons.day_cloudy)),
                title: const Text('Previsão do Tempo'),
                onTap: () {
                  Navigator.pushNamed(context, "/previsaotempo");

                },
              ),
              /*ListTile(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    icon: Icon(Icons.login)),
                title: const Text('Login'),
                onTap: () {
                  info = !info;
                  Navigator.pushNamed(context, "/login");

                },
              ),*/
              ListTile(
                leading: IconButton(
                    onPressed: () {
                      //Navigator.pushNamed(context, "/sobre");
                    },
                    icon: Icon(Icons.help_sharp)),
                title: const Text('Sobre'),
                onTap: () {
                  info = !info;
                  //Navigator.pushNamed(context, "/sobre");

                },
              ),
              ListTile(
                leading: IconButton(
                    onPressed: () {
                      //Navigator.pushNamed(context, "/privacidade");
                    },
                    icon: Icon(Icons.lock)),
                title: const Text('Política de Privacidade'),
                onTap: () {
                  //Navigator.pushNamed(context, "/privacidade");

                },
              ),
            ],
          ),
        ),



      appBar: AppBar(
          backgroundColor: Color.fromRGBO(44, 24, 96, 1),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context:  context,
                    useSafeArea: true,
                    builder:  (BuildContext context) {
                      return AlertDialog(

                        title: Text("Localidades"),
                        content: ListView.builder(
                            itemCount: localidades.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  _movimentarCamera(localidades[index].lat,localidades[index].long);
                                  setState(() {
                                    localAtual = index;
                                    print("local atual: "+localAtual.toString());
                                  });
                                  Navigator.of(context).pop();

                                  /*Navigator.pushNamed(context, "/listanoticia", arguments:  {
                                    'id':not.id,
                                  },);*/

                                },
                                //minLeadingWidth: 0,

                                title: Text(
                                  localidades[index].local,
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    color: Colors.black,

                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),

                              );

                            }),




                        actions: <Widget>[



                        ],
                      );
                    },
                  );
                  //Navigator.pushNamed(context, "/listapluviometros");
                },
                icon: Icon(Icons.directions_run)),
            /*IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/listapluviometros");
                },
                icon: Icon(Icons.waves)),*/
          ],
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Image.asset(
              "images/ic_launcher.png",
              fit: BoxFit.fitHeight,
            ),
            Text("Defesa Civil", textScaleFactor: 0.8),
          ])
      ),

  /*    floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(44, 24, 96, 1),


        child: Icon(WeatherIcons.day_cloudy),
        onPressed: (){
          setState(() {
            info = !info;
          });

          //Navigator.pushNamed(context, "/previsaotempo");

           *//*showDialog(
            context:  context,
            useSafeArea: true,
            builder:  (BuildContext context) {
              return AlertDialog(

                title: Text("PREVISÃO DO TEMPO"),
                content: Text(
                    Strings.fonte_cprm,
                    textScaleFactor: 0.7
                ),
                actions: <Widget>[



                ],
              );
            },
          );*//*




        },


        //_recuperarAreasRisco,

        // _movimentarCamera,
      ),*/

      body: Container(
        child: Stack(
          children: [
            GoogleMap(
            mapType: MapType.normal,
            //mapType: MapType.hybrid,
            //mapType: MapType.none,
            //mapType: MapType.satellite,
            //mapType: MapType.terrain,
            //-23.562436, -46.655005
            initialCameraPosition:
                CameraPosition(target: LatLng(-20.385441, -43.504193), zoom: 14),
            onMapCreated: _onMapCreated,
            markers: _marcadores,
            polygons: _polygons,
          ),
            Positioned(
              top: 5,
              right: 5,
              key: ValueKey('info'),

              child: info? Container(
                
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),

                ),
                //height: 150,
                //width: 220,
                //color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(localidades[localAtual].local,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                        IconButton(
                          color: Colors.blueAccent,
                          icon: const Icon(Icons.clear),
                          //tooltip: 'Mostar dados',
                          onPressed: () {
                            setState(() {
                              info = !info;
                            });
                          },
                        ),
                      ],
                    ),
                    dadosOk?Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /*CircleAvatar(
                          backgroundColor: _corNivel(_dadosPluviometro(localAtual)["nivel"].toString()),
                          radius: 10,
                          child: null,
                        ),*/
                         Text("   "+_dadosPluviometro(localAtual)["risco"].toString()),


                      ],

                    ):Text("Aguardando conexão") ,



                    dadosOk?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 15,
                          color: Colors.green,
                          margin: EdgeInsets.all(2),
                          child: _corNivel(_dadosPluviometro(localAtual)["nivel"].toString()) == Colors.green ?Icon(Icons.arrow_downward_outlined,
                            color: Colors.white,
                            size: 17,):null,


                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          width: 40,
                          height: 15,
                          color: Colors.yellowAccent,
                          child: _corNivel(_dadosPluviometro(localAtual)["nivel"].toString()) == Colors.yellowAccent?Icon(Icons.arrow_downward_outlined,
                            color: Colors.white,
                            size: 17,):null,

                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          width: 40,
                          height: 15,
                          color: Colors.orange,
                          //decoration: BoxDecoration(color: Colors.orange),
                          child: _corNivel(_dadosPluviometro(localAtual)["nivel"].toString()) == Colors.orange?Icon(Icons.arrow_downward_outlined,
                            color: Colors.white,
                            size: 17,):null,
                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          width: 40,
                          height: 15,
                          color: Colors.red,
                          child: _corNivel(_dadosPluviometro(localAtual)["nivel"].toString()) == Colors.red?Icon(Icons.arrow_downward_outlined,
                            color: Colors.white,
                            size: 17,):null,
                        ),
                      ],
                    ):Text(""),
                    dadosOk?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 15,
                          //color: Colors.green,
                          margin: EdgeInsets.all(2),
                          child: Text("0",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              //color: Colors.black,
                              fontSize: 11,
                            ),),

                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          width: 40,
                          height: 15,
                          child: Text("1 a 22",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              //color: Colors.black,
                              fontSize: 11,
                            ),),
                          //color: Colors.yellowAccent,

                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          width: 50,
                          height: 15,
                          child: Text("22 a 128",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              //color: Colors.black,
                              fontSize: 11,
                            ),

                          ),
                          //color: Colors.orange,
                          //decoration: BoxDecoration(color: Colors.orange),

                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          width: 40,
                          height: 15,
                          child: Text(">128",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              //color: Colors.black,
                              fontSize: 11,
                            ),),
                          //color: Colors.red,
                        ),
                      ],
                    ):Text(""),



                    //Text(dadosJsonPluviometros[localidades[localAtual].id]["acc5d"]),


                    //dadosOk? Text(_dadosPluviometro(localAtual)["risco"].toString()):Text(""),
                    //dadosOk? Text("\nAC 24H: " + _dadosPluviometro(localAtual)["24hs"].toString() ): Text(""),
                    dadosOk?Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("AC 24H: "),
                            Container(
                          width: 100,
                          height: 9,
                          child: FAProgressBar(
                            maxValue: _maxPercentual(double.parse(_dadosPluviometro(localAtual)["5d"]!)),
                            size: 10,
                            direction: Axis.horizontal,
                            verticalDirection:
                            VerticalDirection.up,
                            currentValue: double.parse(_dadosPluviometro(localAtual)["24hs"]!).toInt(),

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
                        Text(_dadosPluviometro(localAtual)["24hs"].toString() )
                      ],
                    ):Text(""),
                    dadosOk?Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("AC    5d: "),
                        Container(
                          width: 100,
                          height: 9,
                          child: FAProgressBar(
                            maxValue: _maxPercentual(double.parse(_dadosPluviometro(localAtual)["5d"]!)),
                            size: 10,
                            direction: Axis.horizontal,
                            verticalDirection:
                            VerticalDirection.up,
                            currentValue: double.parse(_dadosPluviometro(localAtual)["5d"]!).toInt(),

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
                        Text(_dadosPluviometro(localAtual)["5d"].toString() )
                      ],
                    ):Text(""),

                    //dadosOk? Text("AC 5d: " + _dadosPluviometro(localAtual)["5d"].toString()): Text(""),


                    Row(
                      children: [
                        dadosOk? TextButton(
                          child: Text("Saiba mais"),
                          onPressed: (){

                            showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: SingleChildScrollView(
                                        child: Container(
                                            child: Column(
                                              children: [
                                                Text(
                                                  //Strings.observacaoPluv+ "\n\n"+
                                                      infoAlertaNivel(_dadosPluviometro(localAtual)["nivel"]!),
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

                        ):Text(""),
                        TextButton(
                          child: Text("Pluviômetros"),
                          onPressed: (){
                            Navigator.pushNamed(context, "/listapluviometros");

                          },

                        )

                      ],
                    ),
                  ],
                ),
              ) :Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                
                height: 60,
                //width: 50,]
                alignment: Alignment.topCenter,
                child: IconButton(
                  color: dadosOk?_corNivel(_dadosPluviometro(localAtual)["nivel"].toString()):Colors.blueAccent,
                  icon: const Icon(WeatherIcons.rain),
                  //tooltip: 'Mostar dados',
                  onPressed: () {
                    setState(() {
                      info = !info;
                    });
                  },
                ),
              ),
            )
        ]
        ),
      ),
    );
  }
}
