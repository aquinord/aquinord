import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'Home.dart';
import 'PrevisaoTempo.dart';
//import 'ListaPluviometros.dart';
import 'CardPluviometros.dart';
import 'ListaPluviometroLocal.dart';
import 'ListaPluviometro5d.dart';
import 'ListaPluviometro12M.dart';
import 'ImagemFull.dart';
import 'Sobre.dart';
import 'Privacidade.dart';
import 'ListaNoticias.dart';
import 'ListaNoticia.dart';
import 'Incidentes.dart';
import 'package:mapas_e_geolocalizacao/ListaInformativos.dart';
import 'package:mapas_e_geolocalizacao/EscolherPeriodo.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mapas_e_geolocalizacao/ImagePicker.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Login.dart';



void main() async{





  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Defesa Civil de Ouro Preto",
    //home: PrevisaoTempo(),
    initialRoute: "/",
    routes: {
      "/previsaotempo" : (context) => PrevisaoTempo(),
      "/listapluviometros" : (context) => ListaPluviometros(),
      "/listapluviometrolocal" : (context) => ListaPluviometroLocal(),
      "/listapluviometro5d" : (context) => ListaPluviometro5d(),
      "/listapluviometro12M" : (context) => ListaPluviometro12M(),
      "/imagemfull" : (context) => ImagemFull(),
      "/sobre" : (context) => Sobre(),
      "/login" : (context) => Login(),
      "/privacidade" : (context) => Privacidade(),
      "/listanoticias" : (context) => ListaNoticias(),
      "/listainformativos" : (context) => ListaInformativos(),
      "/listanoticia" : (context) => ListaNoticia(),
      "/incidentes" : (context) => Incidentes(),
      "/periodo" : (context) => Escolher(),

    },
    home: Home(),
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],

    supportedLocales: [
      const Locale('en', 'US'), // English
      const Locale('pt', 'BR'), // Hebrew
      // ... other locales the app supports
    ],
    theme: ThemeData(
      primaryColor:  Color.fromRGBO(44, 24, 96, 1),
      //backgroundColor: Color.fromRGBO(44, 24, 96, 1),
      //scaffoldBackgroundColor: Color.fromRGBO(44, 24, 96, 1),


    ),


  ));
}
