import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:mapas_e_geolocalizacao/Ocorrencia.dart';
import 'package:location/location.dart';
import 'package:mapas_e_geolocalizacao/Parametros.dart';
import 'package:mapas_e_geolocalizacao/Login.dart';

Location location = new Location();


void LogPrint(Object object) async {
  int defaultPrintLength = 1020;
  if (object == null || object.toString().length <= defaultPrintLength) {
    print(object);
  } else {
    String log = object.toString();
    int start = 0;
    int endIndex = defaultPrintLength;
    int logLength = log.length;
    int tmpLogLength = log.length;
    while (endIndex < logLength) {
      print(log.substring(start, endIndex));
      endIndex += defaultPrintLength;
      start += defaultPrintLength;
      tmpLogLength -= defaultPrintLength;
    }
    if (tmpLogLength > 0) {
      print(log.substring(start, logLength));
    }
  }
}

String dropdownValue = "Outro";
bool imagemOK = false;
String incidente = "";
late XFile _imagem;
String _img64 = "";
final _formKey = GlobalKey<FormState>();
int indexTipoIncidente = 6;



class Incidentes extends StatefulWidget {
  const Incidentes({Key? key}) : super(key: key);

  @override
  _IncidentesState createState() => _IncidentesState();
}

class _IncidentesState extends State<Incidentes> {
  Future _recuperarImagem(bool daCamera) async {
    XFile imagemSelecionada;
    if (daCamera) {
      //camera

      imagemSelecionada =
          (await ImagePicker.platform.getImage(source: ImageSource.camera))!;
    } else {
      //galeria
      imagemSelecionada =
          (await ImagePicker.platform.getImage(source: ImageSource.gallery))!;
    }

    setState(() {
      _imagem = imagemSelecionada;
      ocorrencia.foto_name = imagemSelecionada.name;
      print(ocorrencia.foto_name);
      final bytes = File(imagemSelecionada.path).readAsBytesSync();
      _img64 = base64.encode(bytes);

      //LogPrint(_img64);
      imagemOK = true;
    });
  }

  //String urlbase = "https://sgm.ouropreto.mg.gov.br/apps/defesa_civil";
  //String urlbase = "https://blockchain.info/ticker";
  //String urlbase = "https://sgm.ouropreto.mg.gov.br/apps/defesa_civil/getAreasRisco.php";
  String urlbase = "http://servicos.cptec.inpe.br/apptempo/3672";

  var txtIncidente = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(44, 24, 96, 1),
          title: Text("Relatar Incidentes"),
          /*actions: [
          IconButton(
              onPressed: () {
                //Navigator.pushNamed(context, "/");
              },
              icon: Icon(Icons.list)),
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],*/
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Row(
                  children: [
                    Text("Tipo de ocorrência: "),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      /*underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),*/
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          //indexTipoIncidente = tipoIncidente.indexOf(newValue);

                          print(newValue);
                          print(mapIncidentes[newValue]);
                          indexTipoIncidente = mapIncidentes[newValue]!;



                        });
                      },
                      items: tipoIncidente.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Selecionar imagem: "),
                        ElevatedButton(
                          child: Text("Camera"),
                          onPressed: () {
                            _recuperarImagem(true);
                          },
                        ),
                        ElevatedButton(
                          child: Text("Galeria"),
                          onPressed: () {
                            _recuperarImagem(false);
                          },
                        ),
                      ],
                    ),
                    imagemOK == false
                        ? Container()
                        : Container(
                            child: Image.file(
                            File(_imagem.path),
                            height: 250,
                          )),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    Text(
                      "\n\nDescrição:",
                      textAlign: TextAlign.left,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            controller: txtIncidente,
                            maxLines: 3,
                            maxLength: 250,

                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Favor digitar a descrição do indicente';
                              }
                              incidente = value;
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                /*ElevatedButton(
                                  onPressed: () async{

                                    await Firebase.initializeApp();
                                    String email = "aquinord@yahoo.com.br";
                                    String senha = "1234567";

                                    FirebaseAuth auth = await FirebaseAuth.instance;
                                    *//*auth.createUserWithEmailAndPassword(
                                        email: email,
                                        password: senha
                                    ).then((firebaseUser)
                                    {
                                      print("email: " + firebaseUser.user!.email!);
                                    }
                                    ).catchError((erro){
                                      print("erro " + erro.toString());

                                    });*//*
                                    //await auth.signOut();
                                    auth.signInWithEmailAndPassword(
                                        email: email,
                                        password: senha).then((firebaseUser)
                                    async {
                                      ocorrencia.email = firebaseUser.user?.email!;
                                      //String? teste = firebaseUser.user?.displayName;
                                      ocorrencia.nome_cidadao = firebaseUser.user?.displayName;
                                      ocorrencia.id_usuario = firebaseUser.user?.uid;
                                      ocorrencia.foto_cidadao = firebaseUser.user?.photoURL;
                                      String? token = await firebaseUser.user?.getIdToken();

                                      ocorrencia.token = token;
                                      print ("==========token: $token");
                                      print ("==========token: " + ocorrencia.token);

                                      //String token = await FirebaseMessaging.instance.getToken();




                                      print("retorno: $firebaseUser" );
                                      print("email: " +  ocorrencia.email);
                                      print("nome: " +  ocorrencia.nome_cidadao);
                                      print("id_usuario: " +  ocorrencia.id_usuario);
                                      print("foto_cidadao: " +  ocorrencia.foto_cidadao);
                                      print("foto_name: " +  ocorrencia.foto_name);
                                      //print("token: $firebaseUser.user?.getIdToken()" );



                                    }
                                    ).catchError((erro){
                                      print("erro  de login: " + erro.toString());

                                    });

                                    User? usuarioAtual = await auth.currentUser;

                                    if( usuarioAtual != null ){//logado
                                      print("Usuario atual logado email: " + usuarioAtual.email! );
                                      txtIncidente.text = "Usuario atual logado email: " + usuarioAtual.email!;
                                    }else{//deslogado
                                      print("Usuario atual está DESLOGADO!!");
                                      txtIncidente.text = "Usuario atual está DESLOGADO!!";
                                    }

                                    setState(() {

                                    });
                                  },
                                  child: const Text('Login'),
                                ),*/
                                ElevatedButton(
                                  onPressed: () async{

                                    await Firebase.initializeApp();

                                    FirebaseAuth auth = await FirebaseAuth.instance;

                                    await auth.signOut();

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()
                                        )
                                    );



                                  },
                                  child: const Text('Logout'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    txtIncidente.text = incidente = "";
                                    setState(() {
                                      imagemOK = false;
                                      _img64 = "";
                                    });
                                  },
                                  child: const Text('Apagar'),
                                ),
                                ElevatedButton(
                                  onPressed: () async{
                                    LocationData  _locationData = await location.getLocation();
                                    print(_locationData);



                                    // Validate returns true if the form is valid, or false otherwise.
                                    if (_formKey.currentState!.validate()) {


                                      var incidentesJson = json.encode(
                                          {
                                            "bool_anonimo":ocorrencia.anomino ? "0":"1",
                                            "nome_cidadao":ocorrencia.nome_cidadao,
                                            "latitude":_locationData.latitude,
                                            "longitude":_locationData.longitude,
                                            "id_usuario":ocorrencia.id_usuario,
                                            "texto": incidente,
                                            "email":ocorrencia.email,
                                            "fgk_tipo":indexTipoIncidente,
                                            "foto_cidadao":ocorrencia.foto_cidadao,
                                            "foto_b64":_img64,
                                            "foto_name":ocorrencia.foto_name,
                                            "token":ocorrencia.token,
                                      }
                                      );

                                      String _urlBase = "http://sgm.ouropreto.mg.gov.br/apps/defesa_civil/envia_ocorrencia.php";


                                      http.Response response = await http.post(
                                          Uri.parse(_urlBase),
                                          headers: {
                                            "Content-type": "application/json; charset=UTF-8"
                                          },
                                          body: incidentesJson
                                      );

                                      print("resposta: ${response.statusCode}");
                                      print("resposta: ${response.body}");




                                      // If the form is valid, display a snackbar. In the real world,
                                      // you'd often call a server or save the information in a database.
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text("Enviando dados")),
                                      );
                                    }
                                  },
                                  child: const Text('Enviar'),
                                ),

                              ],
                            ),



                          ),
                          Text("Logado como: "+ ocorrencia.email),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Enviar anônimo "),
                              Checkbox(
                                checkColor: Colors.white,
                                value: ocorrencia.anomino,

                                onChanged: (bool? value) {
                                  setState(() {
                                    ocorrencia.anomino = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
