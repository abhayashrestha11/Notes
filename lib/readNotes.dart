import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/data/local/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:notes/main.dart';

class ReadNotes extends StatelessWidget {
  var titleInput = TextEditingController();
  var descInput = TextEditingController();
  final Function onNoteAdded;

  ReadNotes({required this.onNoteAdded, super.key});

  DBHelper? dbRef = DBHelper.getInstance;
  var time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF000000),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.share,
                color: Colors.white,
                size: 30,
              )),
          SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
      body: Container(
        color: Color(0xFF000000),
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleInput,
                  decoration: InputDecoration(
                      hintText: 'Title', border: InputBorder.none),
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '${DateFormat('MMMM').format(time)}  ${time.day}  ${DateFormat('hh:mm a').format(time)}',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: descInput,
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText: 'Start typing', border: InputBorder.none),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        child: FloatingActionButton(
          backgroundColor: Colors.amber.shade500,
          shape: CircleBorder(),
          onPressed: () {
            var title = titleInput.text;
            var desc = descInput.text;

            if (title.isNotEmpty && desc.isNotEmpty){
              dbRef!.addNotes(mDesc: desc, mTitle: title, mMonth:DateFormat('MMMM').format(time), mDay: {time.day}.toString(),);
              onNoteAdded();
              Navigator.pop(context, MaterialPageRoute(builder: (context) => MyHomePage(),));
            }


          },
          child: Icon(Icons.check,size: 45,color: Colors.white,),
        ),
      ),
    );
  }
}
