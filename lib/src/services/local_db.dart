import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:note_bucket/src/model/note.dart';

class LocalDbServices {
  // Singleton instance
  static final LocalDbServices _instance = LocalDbServices._internal();
  factory LocalDbServices() => _instance;

  LocalDbServices._internal() {
    _db = _openDB();
  }

  late Future<Isar> _db;

  Future<Isar> _openDB() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [NoteSchema],
        inspector: true,
        name: 'notes',
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance('notes'));
  }

  Future<Isar> get db async => _db;

  /// Save a note
  Future<void> saveNote({required Note note}) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.notes.put(note);
    });
  }

  /// Listen to all notes
  Stream<List<Note>> listenAllNotes() async* {
    final isar = await db;
    yield* isar.notes.where().watch(fireImmediately: true);
  }
}
