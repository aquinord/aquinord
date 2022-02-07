import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Cadastro.dart';
import 'Incidentes.dart';
import 'Usuario.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mapas_e_geolocalizacao/Parametros.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _controllerEmail = TextEditingController(text: "");
  TextEditingController _controllerSenha = TextEditingController(text: "");
  String _mensagemErro = "";


  _validarCampos(){

    //Recupera dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if( email.isNotEmpty && email.contains("@") ){

      if( senha.isNotEmpty ){

        setState(() {
          _mensagemErro = "";
        });

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario( usuario );


      }else{
        setState(() {
          _mensagemErro = "Preencha a senha!";
        });
      }

    }else{
      setState(() {
        _mensagemErro = "Preencha o E-mail utilizando @";
      });
    }

  }

  _logarUsuario( Usuario usuario ) async{

    await Firebase.initializeApp();

    FirebaseAuth auth = await FirebaseAuth.instance;


    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser) async{
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



      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Incidentes()
          )
      );

    }).catchError((error){

      setState(() {
        _mensagemErro = "Erro ao autenticar usuário, verifique e-mail e senha e tente novamente!";
      });

    });

  }

  Future _verificarUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();

    var usuarioLogado = await auth.currentUser;

    if( usuarioLogado != null ){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Incidentes()
          )
      );
    }

  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(44, 24, 96, 1),
        title: Text("Fazer Login"),

      ),
      body: Container(
        //decoration: BoxDecoration(color: Color(0xff075E54)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                /*Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "images/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),*/
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.green,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)
                      ),
                      onPressed: () {
                        _validarCampos();
                      }),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                        "Não tem conta? Clique aqui e cadastre-se!",
                        style: TextStyle(
                            color: Colors.blueAccent
                        )
                    ),
                    onTap: (){
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Cadastro()
                          )
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
