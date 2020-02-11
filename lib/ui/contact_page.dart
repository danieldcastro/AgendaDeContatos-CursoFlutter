import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masked_text/masked_text.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _phoneFocus = FocusNode();
  bool _userEdited = false;

  Contact _editedContact;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
    }

    _nameController.text = _editedContact.name;
    _emailController.text = _editedContact.email;
    _phoneController.text = _editedContact.phone;


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(1000, 253, 56, 98),
              title: Text(_editedContact.name ?? "Novo Contato",
                  style: TextStyle(color: Colors.white)),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if(_editedContact.phone !=  null && _editedContact.phone.isNotEmpty) {
                    Navigator.pop(context, _editedContact);
                  } else {
                    FocusScope.of(context).requestFocus(_phoneFocus);
                  }
                },
                child: Icon(Icons.save),
                backgroundColor: Color.fromARGB(1000, 253, 56, 98)
            ),
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: GestureDetector(
                      onTap:() => ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                        if (file == null) return;
                        setState(() {
                          _editedContact.img = file.path;
                        });
                      }),
                      child: CircleAvatar(
                        minRadius: 80.0,
                        maxRadius: 80.0,
                        backgroundImage: _editedContact.img != null
                            ? FileImage(File(_editedContact.img))
                            : AssetImage("images/avatar.png"),
                      ),
                    ),
                  ),
                  Padding (
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: TextField(
                      controller: _nameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Nome",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        _userEdited = true;
                        setState(() {
                          _editedContact.name = text;
                        });
                      },
                    ),
                  ),
                  Padding (
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: TextField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        _userEdited = true;
                        _editedContact.email = text;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Padding (
                    padding: EdgeInsets.only(bottom: 15.0),
                    child:  MaskedTextField(
                      maskedTextFieldController: _phoneController,
                      mask: "(xx)x xxxx-xxxxx",
                      maxLength: 15,
                      focusNode: _phoneFocus,
                      inputDecoration: InputDecoration(
                        fillColor: Color.fromARGB(1000, 253, 56, 98) ,
                        filled: true,
                        labelText: "Celular",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      onChange: (text) {
                        _userEdited = true;
                        _editedContact.phone = text;
                      },
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
            )),
    );
  }

  Future<bool>_requestPop() {
    if (_userEdited) {
      showDialog(context: context,
      builder: (context) => AlertDialog (
          title: Text("Descartar Alterações?"),
        content: Text("Se sair as alterações serão perdidas."),
        actions: <Widget>[
          FlatButton (
            child: Text ("Cancelar"),
            onPressed:() => Navigator.pop(context)
          ),
          FlatButton (
            child: Text ("Sim"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }
          )
        ],
      ),
      );
      return Future.value(false);
      } else {
      return Future.value(true);
    }
    }
  }

