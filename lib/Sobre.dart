import 'package:flutter/material.dart';
import 'package:mapas_e_geolocalizacao/Parametros.dart';
import 'package:url_launcher/url_launcher.dart';

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceWebView: true);
  } else {
    throw 'Could not launch $url';
  }
}

class Sobre extends StatefulWidget {
  const Sobre({Key? key}) : super(key: key);

  @override
  _SobreState createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
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
            Text("Sobre", textScaleFactor: 1),
          ]),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Image.asset(
              "images/pmop_logo.png",
              height: 100,
              //fit: BoxFit.fitHeight,
            ),
            Text(
              "\nDEFESA CIVIL - OURO PRETO\n",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
              textScaleFactor: 1.3,
            ),
            Text(
              sobre,
              textAlign: TextAlign.justify,
              textScaleFactor: 1.2,
            ),
            /*new Center(
              child: ElevatedButton(
                onPressed: () {
                  const url = 'https://google.com';
                  launchURL(url);
                },
                child: new Text('Política de Privacidade'),
              ),
            ),*/
          ]),
        ));
  }
}
