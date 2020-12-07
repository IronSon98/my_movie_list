import 'package:my_movie_list/models/filme.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HelperBd {
  static final _dataBaseName = "MyMovieList.db";
  static final _dataBaseVersion = 1;

  static final table = "Filmes";
  static final columnId = "id";
  static final columnNome = "nome";
  static final columnAutor = "autor";
  static final columnAno = "ano";
  static final columnStatus = "status";
  static final columnImagem = "urlImagem";

  static final HelperBd _helperBd = HelperBd.internal();
  factory HelperBd() {
    return _helperBd;
  }
  HelperBd.internal();

  Database _db;

  Future<Database> get db async {
    //Apenas inicializa o banco de dados quando não tiver uma instância configurada
    if (_db != null) {
      return _db;
    } else {
      _db = await _recuperarBancoDeDados();
      return _db;
    }
  }

  //Recupera o banco de dados
  Future<Database> _recuperarBancoDeDados() async {
    final caminhoBancoDeDados = await getDatabasesPath();
    final localBancoDeDados = join(caminhoBancoDeDados, _dataBaseName);

    return await openDatabase(localBancoDeDados,
        version: _dataBaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnNome TEXT NOT NULL,
        $columnAutor TEXT NOT NULL,
        $columnAno TEXT NOT NULL,
        $columnStatus INTEGER NOT NULL,
        $columnImagem TEXT NOT NULL
      )
    ''');
  }

  //Salvar filme no banco de dados
  Future<Filme> salvarFilme(Filme filme) async {
    try {
      var bd = await db;

      filme.id = await bd.insert(table, filme.toMap());
      return filme;
    } catch (erro) {
      print(erro);
      return null;
    }
  }

  //Listar filmes assistidos do banco de dados
  Future<List<Filme>> listarFilmes(bool filmesAssistidos) async {
    try {
      Database db = await _helperBd.db;
      int status = filmesAssistidos ? 1 : 0;
      String sql = "SELECT * FROM $table WHERE status = $status";
      List filmes = await db.rawQuery(sql);

      List<Filme> listaFilmes = List();

      for (Map map in filmes) {
        listaFilmes.add(Filme.fromMap(map));
      }

      return listaFilmes;
    } catch (erro) {
      print(erro);
      return null;
    }
  }

  //Excluir filme do banco de dados
  Future<int> excluirFilme(int id) async {
    try {
      Database db = await _helperBd.db;
      return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
    } catch (erro) {
      print(erro);
      return null;
    }
  }

  //Editar filme do banco de dados
  Future<int> editarFilme(Filme filme) async {
    try {
      Database db = await _helperBd.db;

      return await db.update(table, filme.toMap(),
          where: "$columnId = ?", whereArgs: [filme.id]);
    } catch (erro) {
      print(erro);
      return null;
    }
  }

  Future close() async {
    Database db = await _helperBd.db;
    db.close();
  }
}
