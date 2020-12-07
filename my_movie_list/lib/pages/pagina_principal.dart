import 'package:flutter/material.dart';
import 'package:my_movie_list/pages/adicionar_filme.dart';
import 'package:my_movie_list/pages/filmes_assistidos.dart';
import 'package:my_movie_list/pages/filmes_nao_assistidos.dart';

class PaginaPrincipal extends StatefulWidget {
  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int _indexSelecionado = 0;

  List<Widget> _opcoesDePaginas = <Widget>[
    AdicionarFilmePage(),
    FilmesAssistidosPage(),
    FilmesNaoAssistidosPage()
  ];

  void _onItemSelecionado(int index) {
    setState(() {
      _indexSelecionado = index;
    });
  }

  BottomNavigationBarItem _criarBottomNavigationBarItem(
      IconData icone, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icone),
      // ignore: deprecated_member_use
      title: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _opcoesDePaginas.elementAt(_indexSelecionado),
      ),
      bottomNavigationBar: _criarBottomNavigationBar(),
      backgroundColor: Colors.blueGrey[800],
    );
  }

  BottomNavigationBar _criarBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        _criarBottomNavigationBarItem(Icons.playlist_add, "Adicionar"),
        _criarBottomNavigationBarItem(Icons.playlist_add_check, "Assistidos"),
        _criarBottomNavigationBarItem(Icons.playlist_play, "Assistir"),
      ],
      currentIndex: _indexSelecionado,
      selectedItemColor: Colors.blueGrey[300],
      unselectedItemColor: Colors.white,
      backgroundColor: Colors.blueGrey[800],
      onTap: _onItemSelecionado,
    );
  }
}
