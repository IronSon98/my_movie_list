import 'package:flutter/material.dart';
import 'package:my_movie_list/models/filme.dart';
import 'package:my_movie_list/utils/helper_bd.dart';
import 'package:my_movie_list/pages/adicionar_filme.dart';
import 'package:my_movie_list/utils/utils.dart';

class FilmesNaoAssistidosPage extends StatefulWidget {
  @override
  _FilmesNaoAssistidosPageState createState() =>
      _FilmesNaoAssistidosPageState();
}

class _FilmesNaoAssistidosPageState extends State<FilmesNaoAssistidosPage> {
  HelperBd _db = HelperBd();

  List<Filme> filmesNaoAssistidos = List();

  @override
  void initState() {
    super.initState();

    atualizaLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: criarAppBar("Filmes não assistidos"),
        body: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: filmesNaoAssistidos.length,
            itemBuilder: (context, index) {
              return filmeCard(context, filmesNaoAssistidos, index,
                  _showFilmePage, _showOptions);
            }),
        backgroundColor: Colors.white);
  }

  void _showFilmePage(Filme filme, BuildContext context) async {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdicionarFilmePage(filme: filme)))
        .whenComplete(() {
      atualizaLista();
    });
  }

  void atualizaLista() {
    _db.listarFilmes(false).then((list) {
      setState(() {
        filmesNaoAssistidos = list;
        filmesNaoAssistidos.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
      });
    });
  }

  void _showOptions(BuildContext context, int index, List<Filme> filmes,
      Function _showFilmePage) {
    showModalBottomSheet(
        backgroundColor: Colors.blueGrey,
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.edit, color: Colors.white),
                      title:
                          Text('Editar', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pop(context);
                        _showFilmePage(filmes[index], context);
                      }),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.white),
                    title:
                        Text('Excluir', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      _db.excluirFilme(filmes[index].id);
                      filmes.removeAt(index);
                      atualizaLista();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
