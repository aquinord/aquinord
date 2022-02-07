
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';



class ImagemFull extends StatefulWidget {
  const ImagemFull({Key? key}) : super(key: key);

  @override
  _ImagemFullState createState() => _ImagemFullState();
}

class _ImagemFullState extends State<ImagemFull> {
  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(44, 24, 96, 1),
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Image.asset(
              "images/ic_launcher.png",
              fit: BoxFit.fitHeight,
            ),
            Text("Defesa Civil Ouro Preto", textScaleFactor: 0.7),
          ])),
      body: Center(
        child: PhotoView(
            imageProvider: NetworkImage(args['url_imagem'])
        ),
      ),
    );
  }
}