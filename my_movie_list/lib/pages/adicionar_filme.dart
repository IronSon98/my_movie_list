import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_movie_list/models/filme.dart';
import 'package:my_movie_list/utils/helper_bd.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_movie_list/widgets/app_button.dart';
import 'package:validadores/validadores.dart';
import 'package:my_movie_list/utils/utils.dart';

class AdicionarFilmePage extends StatefulWidget {
  final Filme filme;
  AdicionarFilmePage({this.filme});

  @override
  _AdicionarFilmePageState createState() => _AdicionarFilmePageState();
}

class _AdicionarFilmePageState extends State<AdicionarFilmePage> {
  final _formKey = GlobalKey<FormState>();

  var _db = HelperBd();

  ImagePicker _picker = ImagePicker();

  final _tNome = TextEditingController();
  final _tAutor = TextEditingController();
  final _tAno = TextEditingController();

  bool _filmeAssistido = false;
  bool _paginaEditada = false;

  Filme _filmeEditado;

  void _getImagem(ImageSource source) {
    _picker.getImage(source: source).then((file) {
      if (file == null) {
        return;
      } else {
        setState(() {
          _filmeEditado.urlImagem = file.path;
        });
      }
    });
  }

  _escolhaOrigemImagem(String origemEscolhida) {
    switch (origemEscolhida) {
      case "Câmera":
        _getImagem(ImageSource.camera);
        break;
      case "Galeria":
        _getImagem(ImageSource.gallery);
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.filme == null)
      _filmeEditado = Filme();
    else {
      _filmeEditado = Filme.fromMap(widget.filme.toMap());
      _filmeEditado.id = widget.filme.id;

      _tNome.text = _filmeEditado.nome;
      _tAutor.text = _filmeEditado.autor;
      _tAno.text = _filmeEditado.ano;
      _filmeAssistido = _filmeEditado.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => requestAlertDialog(_paginaEditada, context),
        child: Scaffold(
            appBar: criarAppBar("Adicionar filme"),
            body: _criarSingleChildScrollViewAddFilme(context),
            backgroundColor: Colors.white));
  }

  SingleChildScrollView _criarSingleChildScrollViewAddFilme(
      BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _criarGestureDetectorImagem(context),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                _criarTextFormField(
                    _tNome, "Nome", TextInputType.text, _validarNome),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                _criarTextFormField(
                    _tAutor, "Autor", TextInputType.text, _validarAutor),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                _criarTextFormField(
                    _tAno, "Ano", TextInputType.number, _validarAno),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                _criarSwitchListTile(),
                AppButton(
                  "SALVAR",
                  onPressed: () {
                    _adicionarFilme();
                  },
                ),
              ],
            )));
  }

  GestureDetector _criarGestureDetectorImagem(BuildContext context) {
    return GestureDetector(
      child: Container(
          width: 200.0,
          height: 200.0,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  image: _filmeEditado.urlImagem != null
                      ? FileImage(File(_filmeEditado.urlImagem))
                      : AssetImage("imagens/icone_assistir.jpg")))),
      onTap: () {
        _mostrarOpcoesGaleriaOuCamera(context);
      },
    );
  }

  void _mostrarOpcoesGaleriaOuCamera(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.blueGrey,
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo, color: Colors.white),
                      title: Text('Galeria',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _escolhaOrigemImagem("Galeria");
                        Navigator.of(context).pop();
                      }),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.camera_alt, color: Colors.white),
                    title:
                        Text('Câmera', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      _escolhaOrigemImagem("Câmera");
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  SwitchListTile _criarSwitchListTile() {
    return SwitchListTile(
      title: Text(
        'Assistido',
        style: TextStyle(
          color: Colors.blueGrey[800],
          fontWeight: FontWeight.bold,
        ),
      ),
      contentPadding: EdgeInsets.only(left: 5.0),
      activeColor: Colors.blueGrey[800],
      inactiveThumbColor: Colors.blueGrey[300],
      value: _filmeAssistido,
      onChanged: (bool value) {
        setState(() {
          _paginaEditada = true;
          _filmeAssistido = value;
          _filmeEditado.status = value;
        });
      },
    );
  }

  TextFormField _criarTextFormField(
      TextEditingController controller,
      String labelTextInputDecoration,
      TextInputType textInputType,
      Function validacao) {
    return TextFormField(
      controller: controller,
      decoration: _criarInputDecoration(labelTextInputDecoration),
      keyboardType: textInputType,
      validator: (value) => validacao(value),
      textCapitalization: TextCapitalization.sentences,
      cursorColor: Colors.blueGrey[800],
      style: TextStyle(color: Colors.blueGrey[800]),
      onChanged: (text) {
        _paginaEditada = true;

        switch (labelTextInputDecoration) {
          case "Nome":
            setState(() {
              _filmeEditado.nome = text;
            });
            break;
          case "Autor":
            setState(() {
              _filmeEditado.autor = text;
            });
            break;
          case "Ano":
            setState(() {
              _filmeEditado.ano = text;
            });
            break;
        }
      },
    );
  }

  InputDecoration _criarInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey[800],
      ),
    );
  }

  void limparElementos() {
    setState(() {});

    _tNome.text = "";
    _tAutor.text = "";
    _tAno.text = "";

    _filmeAssistido = false;
    _paginaEditada = false;

    _filmeEditado.nome = null;
    _filmeEditado.autor = null;
    _filmeEditado.ano = null;
    _filmeEditado.status = null;
    _filmeEditado.urlImagem = null;
  }

//Validadores

  String _validarNome(String nome) {
    return Validador()
        .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
        .valido(nome);
  }

  String _validarAutor(String autor) {
    return Validador()
        .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
        .valido(autor);
  }

  String _validarAno(String ano) {
    return Validador()
        .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
        .minLength(4)
        .maxLength(4)
        .valido(ano);
  }

  void _adicionarFilme() async {
    //Validação do formulário
    bool formOk = _formKey.currentState.validate();
    if (!formOk) {
      return;
    }

    if (_filmeEditado.urlImagem == null || _filmeEditado.urlImagem.isEmpty) {
      showErrorMessageImagem(context);
    } else {
      if (widget.filme == null) {
        await _db.salvarFilme(_filmeEditado);
        FocusScope.of(context).offset;
        limparElementos();
      } else {
        await _db.editarFilme(_filmeEditado);
        Navigator.pop(context);
      }
    }
  }
}
