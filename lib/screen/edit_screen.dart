import 'package:flutter/material.dart';
import 'package:flutter_to_do_list/const/colors.dart';
import 'package:flutter_to_do_list/data/firestor.dart';
import 'package:flutter_to_do_list/model/notes_model.dart';

class Edit_Screen extends StatefulWidget {
  Note _note;
  Edit_Screen(this._note, {super.key});

  @override
  State<Edit_Screen> createState() => _Edit_ScreenState();
}

class _Edit_ScreenState extends State<Edit_Screen> {
  TextEditingController? title;
  TextEditingController? subtitle;
  TimeOfDay? selectedTime;
  String time = "";
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  int indexx = 0;
  @override
  void initState() {
    // TODO: implement initState
       time = TextEditingController(text: widget._note.time).text.toString();
     super.initState();
    title = TextEditingController(text: widget._note.title);
    subtitle = TextEditingController(text: widget._note.subtitle);
  }

  Widget build(BuildContext context) {
    Widget TimeRow(BuildContext context) {
      return ListTile(
        tileColor: Colors.transparent,
        leading: Icon(Icons.access_alarm, color: custom_green), // Icône à gauche du texte
        title: Text(
          'Selected Time: ${time}', // Texte affichant l'heure sélectionnée
          style: TextStyle(fontSize: 16), // Style du texte
        ),
        onTap: () {
          selectTime(context); // Afficher le sélecteur de temps lors du clic sur le ListTile
        },
      );
    }

    return Scaffold(
      backgroundColor: backgroundColors,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title_widgets(),
            SizedBox(height: 20),
            subtite_widgets(),
            SizedBox(height: 20),
            TimeRow(context),
            SizedBox(height: 20),
            imagess(),
            SizedBox(height: 20),
            button()
          ],
        ),
      ),
    );
  }
  Widget button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            //primary: custom_green,
            minimumSize: Size(170, 48),
          ),
          onPressed: () {
            Firestore_Datasource().Update_Note(
                widget._note.id, indexx, title!.text, subtitle!.text , selectedTime!.replacing());
            Navigator.pop(context);
          },
          child: Text('Update task'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            //primary: Colors.red,
            minimumSize: Size(170, 48),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  Container imagess() {
    return Container(
      height: 180,
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                indexx = index;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(left: index == 0 ? 7 : 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: indexx == index ? custom_green : Colors.grey,
                  ),
                ),
                width: 140,
                margin: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Image.asset('images/${index}.png'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget title_widgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Title', // Étiquette pour le champ de saisie de titre
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8), // Espacement entre l'étiquette et le champ de saisie
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              controller: title,
              focusNode: _focusNode1,
              style: TextStyle(fontSize: 18, color: Colors.black),
              decoration: InputDecoration(
                contentPadding:
                EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                hintText: 'Enter title',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color(0xffc5c5c5),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: custom_green,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding subtite_widgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subtitle', // Étiquette pour le champ de saisie de sous-titre
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8), // Espacement entre l'étiquette et le champ de saisie
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              maxLines: 3,
              controller: subtitle,
              focusNode: _focusNode2,
              style: TextStyle(fontSize: 18, color: Colors.black),
              decoration: InputDecoration(
                contentPadding:
                EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                hintText: 'Enter subtitle',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color(0xffc5c5c5),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: custom_green,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),

    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        time=selectedTime!.hour.toString() +":"+ selectedTime!.minute.toString()  ;
      });
  }

}
