import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../model/note.dart';
import '../../services/local_db.dart';

class CreateNoteWidget extends StatefulWidget {
  const CreateNoteWidget({super.key, this.note});

  final Note? note;

  @override
  State<CreateNoteWidget> createState() => _CreateNoteWidgetState();
}

class _CreateNoteWidgetState extends State<CreateNoteWidget> {
  final _formKey = GlobalKey<FormState>();
  final localDb = LocalDbServices();
late  bool update = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSaving = false; // <-- track saving state
  Future<void> _saveNote() async {
    setState(() => _isSaving = true); // show progress

    try {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
//if not null
      if (widget.note != null) {
        // Update the note
         update = true;

        final updatedNote = widget.note!.copyWith(
          title: title,
          description: description,
          lastMod: DateTime.now(),
        );
        await localDb.saveNote(note: updatedNote);
        // Success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Note updated successfully',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
            ),
            backgroundColor: Colors.green.shade700, // minimalistic
            behavior: SnackBarBehavior.floating, // appears above bottom
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            duration: const Duration(seconds: 2),
          ),
        );


        Navigator.pop(context, true); // return true to indicate success
        return;
      }
      if (title.isEmpty && description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot save empty note')),
        );
        return;
      }

      final newNote = Note(
        title: title,
        description: description,
        lastMod: DateTime.now(),
        id: Isar.autoIncrement,
      );

      await localDb.saveNote(note: newNote);

      // Success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Note saved successfully',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Colors.green.shade700, // minimalistic
          behavior: SnackBarBehavior.floating, // appears above bottom
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration: const Duration(seconds: 2),
        ),
      );


      Navigator.pop(context, true); // return true to indicate success
    } catch (e) {
      log('Error saving note: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save note',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Colors.red.shade700, // subtle error color
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false); // hide progress
    }
  }
  @override
  void dispose() {
    log('dispose called');
    log('title controller ${_titleController.text}');
    log('description controller ${_descriptionController.text}');
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.note != null) {
      update = true;
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(update ? 'Update Note' : 'Create Note', style: GoogleFonts.poppins()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 22),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none, // no border
                ),
              ),
              style: GoogleFonts.poppins(
                  fontSize: 24, color: Colors.black87, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 18),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: GoogleFonts.poppins(
                    fontSize: 20, color: Colors.black87, height: 1.5),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade300, // your color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _isSaving ? null : _saveNote,
                  child:  _isSaving
                  ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                )
                    :Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        update ? 'Update' : 'Save',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
