import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
    _getAllContacts();
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos", style: TextStyle (color: Colors.white),),
        backgroundColor: Color.fromARGB(1000, 253, 56, 98),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions> (
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>> [
              const PopupMenuItem<OrderOptions> (
                  child: Text("Ordenar de A-Z"),
                  value: OrderOptions.orderaz
              ),
              const PopupMenuItem<OrderOptions> (
                  child: Text("Ordenar de Z-A"),
                  value: OrderOptions.orderza
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: _showContactPage,
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(1000, 253, 56, 98),
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }
      ),
    );
  }
    Widget _contactCard(BuildContext context, int index) {
     return GestureDetector (
       onTap: () {
         _showOptions(context, index);
       },
       child: Card(
         child:
         Padding(
          padding: EdgeInsets.all(10.0),
          child: Row (
            children: <Widget>[
              CircleAvatar (
                minRadius: 40.0,
                backgroundImage: contacts[index].img != null ?
                FileImage(File(contacts[index].img)) :
                  AssetImage("images/avatar.png"),
              ),
              Padding (
                padding: EdgeInsets.only(left: 10.0),
                child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text (contacts[index].name ?? "",
                      style: TextStyle(fontSize: 22.0,
                          fontWeight: FontWeight.bold)),
                    Text (contacts[index].phone ?? "",
                        style: TextStyle(fontSize: 18.0,)),
                    Text (contacts[index].email ?? "",
                        style: TextStyle(fontSize: 18.0,)),
                  ],
                ),
              )
            ],
          ),
         ),
       ),
     );
    }

    void _showOptions (BuildContext context, int index) {
      showModalBottomSheet(
          context: context,
          builder: (context) => BottomSheet (
            onClosing: (){},
            builder: (context) => Container (
              padding: EdgeInsets.only(left: 30.0),
              child: Row (
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row (
                    children: <Widget>[
                      Icon (Icons.delete, color: Colors.red),
                      FlatButton (
                        child: Text ("Excluir",
                            style: TextStyle(color: Colors.red, fontSize: 20.0)
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          helper.deleteContact(contacts[index].id);
                          setState(() {
                            contacts.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                  Row (
                    children: <Widget>[
                      Icon (Icons.edit),
                      FlatButton (
                        child: Text ("Editar",
                            style: TextStyle(color: Colors.black, fontSize: 20.0)
                            ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                      ),
                    ],
                  ),
                  Row (
                    children: <Widget>[
                      Icon (Icons.call, color: Colors.green),
                      FlatButton (
                        child: Text ("Ligar",
                            style: TextStyle(color: Colors.green, fontSize: 20.0)
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          launch("tel:${contacts[index].phone}");
                        }
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
      );
    }

    void _showContactPage({Contact contact}) async {
      final recContact = await Navigator.push(context,
      MaterialPageRoute (builder: (context) => ContactPage(contact: contact))
      );

      if (recContact != null) {
        if (contact != null) {
          await helper.updateContact(recContact);
        } else {
          await helper.saveContact(recContact);
        }
        _getAllContacts();
      }
    }

    void _getAllContacts() {
      helper.getAllContacts().then((list){
        setState(() {
          contacts = list;
        });
      });
    }

    void _orderList (OrderOptions result) {
      switch(result) {
        case OrderOptions.orderaz:
          contacts.sort((a,b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
          break;
        case OrderOptions.orderza:
          contacts.sort((a,b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
          break;
      }
      setState(() {

      });
    }
}
