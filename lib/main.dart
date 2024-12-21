import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes/data/local/db_helper.dart';
import 'package:notes/readNotes.dart';
import 'package:notes/updateData.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xiaomiNotes',
      debugShowCheckedModeBanner: false,
      //themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;
  late bool longPressed = false;
  late bool selectTap = false;
  late int? selectedNo;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void getNotes() async {
    allNotes = await dbRef!.getALlNotes();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF000000),
        actions: [
          FaIcon(FontAwesomeIcons.folderClosed),
          SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings_outlined,
                size: 30,
                color: Colors.white,
              )),
          //FaIcon(FontAwesomeIcons.cog)
        ],
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color(0xFF000000),
          child: mainBody()),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 20, right: 20),
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadNotes(
                    onNoteAdded: getNotes,
                  ),
                ));
            longPressed =false;
            selectTap =false;
            // dbRef!.addNotes(mTitle: 'Hello',  mDesc: "Hello this is desc",);
            // getNotes();
          },
          child: Icon(
            Icons.add,
            size: 30,
          ),
          shape: CircleBorder(),
          backgroundColor: Colors.yellow.shade700,
        ),
      ),
      bottomNavigationBar: Container(
          //color: Colors.blue,
          height: 70,
          decoration: BoxDecoration(
              color: Color(0xFF000000),
              border: Border(
                  top: BorderSide(width: 0.3, color: Colors.grey.shade900))),
          child: longPressed ? deleteClose() : notesTasks()),
    );
  }

  Widget mainBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add the Text at the Top
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
            child: Text(
              "Notes",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                  color: Colors.white),
            ),
          ),
          searchBox(),

          // Notes List
          allNotes.isNotEmpty
              ? noteDisplayPart()
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Text(
                      'No Notes yet!!!',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget noteDisplayPart() {
    return Column(
      children: List.generate(
        allNotes.length,
        (index) => InkWell(
          onTap: () {
            longPressed
                ? selectedNo = index
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateData(onNoteAdded: getNotes, index: index,),
                    ));
            selectTap = true;
            getNotes();
          },
          onLongPress: () {
            longPressed = true;
            setState(() {});
          },
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 5),
            height: 103,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(22)),
            child: Padding(
              padding: const EdgeInsets.all(17),
              child: Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      allNotes[index][DBHelper.columnTitle],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      '${allNotes[index][DBHelper.columnDescription]}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      '${allNotes[index][DBHelper.columnMonth]} ${allNotes[index][DBHelper.columnDay].toString().replaceAll(RegExp(r'[(){}]'), '')}',
                      style: TextStyle(fontSize: 12, color: Color(0x62FFFFFF)),
                    ),
                  ],
                ),
                //longPressed ? greyTickCircle() : blankWidget(),
                longPressed ? selectTap?yellowTickCircle():greyTickCircle() : blankWidget()
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget searchBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 23, bottom: 10),
      child: TextField(
        focusNode: _searchFocusNode,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search notes",
          hintStyle: TextStyle(fontSize: 20, color: Color(0x50FFFFFf)),
          contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          prefixIcon: Icon(
            Icons.search,
            size: 24,
            color: Color(0x8AFFFFFF),
          ),
          filled: true,
          fillColor: Colors.grey.shade900,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(width: 0.5, color: Colors.grey.shade900),
          ),
        ),
        //style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget yellowTickCircle() {
    return Positioned(
        right: 15,
        top: 20,
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.amber.shade500,
          ),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 20,
          ),
        ));

    // Positioned(
    //   right: 15,
    //   top: 20,
    //   child: Icon(
    //     Icons.check_circle_rounded,
    //     size: 27,
    //     color: Colors.amber.shade500,
    //   ));
  }

  Widget greyTickCircle() {
    return Positioned(
        right: 15,
        top: 20,
        child: CircleAvatar(
          radius: 13,
          backgroundColor: Colors.grey.shade700,
        ));
  }

  Widget notesTasks() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notes_outlined,
                  size: 27,
                  color: Colors.grey,
                )),
            Positioned(
                top: 35,
                right: 8,
                child: Text('Notes',
                    style: TextStyle(color: Colors.white, fontSize: 12)))
          ]),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(children: [
            IconButton(
                onPressed: () {
                  getNotes();
                  print('Get notes called');
                },
                icon: Icon(
                  Icons.task,
                  size: 26,
                  color: Colors.grey,
                )),
            Positioned(
                top: 35,
                right: 8,
                child: Text(
                  'Tasks',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )),
            //FaIcon(FontAwesomeIcons.noteSticky, color: Colors.white,)
          ]),
        ],
      ),
    ]);
  }

  Widget deleteClose() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(children: [
            IconButton(
                onPressed: () {
                  longPressed = false;
                  selectTap = false;
                  selectedNo = null;
                  setState(() {});
                },
                icon: Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white,
                )),
            Positioned(
                top: 35,
                right: 9,
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )),
            //FaIcon(FontAwesomeIcons.noteSticky, color: Colors.white,)
          ]),
        ]),
        Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(children: [
            IconButton(
                onPressed: () async {
                  if (selectTap) {
                    bool check = await dbRef!.deleteNote(
                        sno: allNotes[selectedNo!][DBHelper.columnSNo]);
                    if (check) {
                      getNotes();
                    }
                  }
                },
                icon: Icon(
                  Icons.delete_outline,
                  size: 27,
                  color: Colors.grey,
                )),
            Positioned(
                top: 35,
                right: 6,
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )),
            //FaIcon(FontAwesomeIcons.noteSticky, color: Colors.white,)
          ]),
        ]),
      ],
    );
  }

  Widget blankWidget() {
    return Positioned(
        right: 15,
        top: 20,
        child: CircleAvatar(
          radius: 13,
          backgroundColor: Colors.grey.shade900,
        ));
  }
}
