import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:agenda_contatos/ui/home_page.dart';


void main(){
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primaryColor: Colors.white,
        cursorColor: Colors.white, //cor do cursor piscando de textfilds
        textSelectionHandleColor: Color.fromARGB(200, 253, 56, 98), //cor das pazinhas de seleção de texto
        textSelectionColor: Color.fromARGB(200, 253, 56, 98), //cor do texto selecionado//cor de primeiro plano para widgets (botões, texto, efeito de borda de deslocamento excessivo, etc.).
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(1000, 253, 56, 98))))
    ),
  ));
}

