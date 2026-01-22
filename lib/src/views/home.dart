import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:note_bucket/src/res/strings.dart';
import 'package:note_bucket/src/views/widget/create_note.dart';
import 'package:note_bucket/src/views/widget/empty_widget.dart';
import 'package:note_bucket/src/views/widget/note_grid_item.dart';
import 'package:note_bucket/src/views/widget/note_list_item.dart';
import 'package:note_bucket/src/views/widget/notes_grid.dart';
import 'package:note_bucket/src/views/widget/notes_list.dart';

import '../model/note.dart';
import '../res/assets.dart';
import '../services/local_db.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isListView = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.AppName,
                    style: GoogleFonts.poppins(fontSize: 24),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isListView = !isListView;
                      });
                    },
                    icon: Icon(
                      isListView ? Icons.splitscreen_outlined : Icons.grid_view,
                    ),
                  ),
                ],
              ),
            ),
            // EmptyWidget()
            Expanded(
              child: StreamBuilder(
                  stream: LocalDbServices().listenAllNotes(),
                  builder: (context, snapshot) {
                    if(snapshot.data==null){
                      return EmptyWidget();
                    }
                    final notes = snapshot.data!;

                    // if(isListView){
                    //   return NotesList(notes: notes);
                    // }
                    // return NotesGrid(notes: notes);

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isListView ? NotesList(notes: notes) : NotesGrid(notes: notes),
                    );
                  }
              ),
            )
                ],
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Adding a simple print to verify the click works in the console
          debugPrint("FAB Clicked!");

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreateNoteWidget()),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.grey),
      ),
    );
  }
}
