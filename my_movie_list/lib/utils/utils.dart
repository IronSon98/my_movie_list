import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_movie_list/models/filme.dart';

Widget filmeCard(BuildContext context, List<Filme> filmes, int index,
    Function _showFilmePage, Function _showOptions) {
  return GestureDetector(
    child: Card(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                    width: 90.0,
                    height: 90.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: filmes[index].urlImagem != null
                                ? FileImage(File(filmes[index].urlImagem))
                                : AssetImage("imagens/icone_assistir.jpg")))),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          filmes[index].nome,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800]),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          filmes[index].status ? "Assistido" : "Não assistido",
                          style: TextStyle(
                              fontSize: 15.0, color: Colors.blueGrey[800]),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
        color: Colors.white,
        shadowColor: Colors.blueGrey[900],
        elevation: 15),
    onTap: () {
      _showOptions(context, index, filmes, _showFilmePage);
    },
  );
}

void showErrorMessageImagem(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Nenhuma imagem foi selecionada",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
          ),
          content: Text("É necessário informar uma imagem",
              style: TextStyle(color: Colors.blueGrey[800])),
          actions: <Widget>[
            FlatButton(
              color: Colors.blueGrey[900],
              child: Text("Ok", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      });
}

Future<bool> requestAlertDialog(
    bool paginaEditada, BuildContext context) async {
  if (paginaEditada) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Descartar alterações?",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
            content: Text("As alterações serão perdidas.",
                style: TextStyle(color: Colors.blueGrey[800])),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text("Cancelar", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Colors.green,
                child: Text("Sim", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });

    return Future.value(false);
  } else {
    return Future.value(true);
  }
}

Widget criarAppBar(String labelText) {
  return AppBar(
    title: Text(
      labelText,
      style: TextStyle(fontSize: 20, color: Colors.white),
    ),
    centerTitle: true,
    backgroundColor: Colors.blueGrey[800],
    toolbarHeight: 50,
  );
}
