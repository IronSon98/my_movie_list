class Filme {
  int id;
  String nome;
  String autor;
  String ano;
  bool status;
  String urlImagem;

  Filme({this.nome, this.autor, this.ano, this.status, this.urlImagem});

  Filme.fromMap(Map<String, dynamic> filmes) {
    id = filmes["id"];
    nome = filmes['nome'];
    autor = filmes['autor'];
    ano = filmes['ano'];
    status = filmes['status'] > 0;
    urlImagem = filmes['urlImagem'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = null;
    data['nome'] = nome;
    data['autor'] = autor;
    data['ano'] = ano;
    data['status'] = status != null && status ? 1 : 0;
    data['urlImagem'] = urlImagem;

    if (id != null) {
      data['id'] = id;
    }

    return data;
  }
}
