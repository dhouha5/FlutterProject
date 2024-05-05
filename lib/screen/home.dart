import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_to_do_list/const/colors.dart';
import 'package:flutter_to_do_list/screen/add_note_screen.dart';
import 'package:flutter_to_do_list/widgets/stream_note.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({Key? key}) : super(key: key);

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  bool _showFab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: custom_green,
        title:Text('ToDo List',
          style: TextStyle(

              color: Colors.black,
              fontWeight: FontWeight.bold),),
         actions: [
           IconButton(onPressed: (){_signOut();}, icon: Icon(Icons.logout,color: Colors.black,)
           )],
      ),
      backgroundColor: backgroundColors,
      floatingActionButton: AnimatedOpacity(
        opacity: _showFab ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Add_screen(),
            ));
          },
          backgroundColor: custom_green,
          child: Icon(Icons.add, size: 30, color: Colors.black,),
        ),
      ),
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollStartNotification) {
              // L'utilisateur a commencé à faire défiler
            } else if (notification is ScrollUpdateNotification) {
              // L'utilisateur est en train de faire défiler
              if (notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
                // L'utilisateur fait défiler vers le bas
                setState(() {
                  _showFab = false; // Masque le bouton flottant
                });
              } else if (notification.metrics.pixels <= notification.metrics.minScrollExtent) {
                // L'utilisateur fait défiler vers le haut
                setState(() {
                  _showFab = true; // Affiche le bouton flottant
                });
              }
            } else if (notification is ScrollEndNotification) {
              // L'utilisateur a terminé de faire défiler
            }
            return true;
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'ToDo',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Stream_note(false),
                Text(
                  'IsDone',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold),
                ),
                Stream_note(true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}
