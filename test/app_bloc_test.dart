import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:testing_bloc_vandad/bloc/actions.dart';
import 'package:testing_bloc_vandad/bloc/app_bloc.dart';
import 'package:testing_bloc_vandad/bloc/app_state.dart';
import 'package:testing_bloc_vandad/apis/login_api.dart';
import 'package:testing_bloc_vandad/apis/notes_api.dart';
import 'package:testing_bloc_vandad/models.dart';

const Iterable<Note> mockNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3'),
];

@immutable
class DummyNotesApi implements NotesApiProtocol {
  final LoginHandle acceptLoginHandle;
  final Iterable<Note>? notesToReturnForAcceptedLoginHandle;

  const DummyNotesApi({
    required this.acceptLoginHandle,
    required this.notesToReturnForAcceptedLoginHandle,
  });

  const DummyNotesApi.empty()
      : acceptLoginHandle = const LoginHandle.fooBar(),
        notesToReturnForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    if (loginHandle == acceptLoginHandle) {
      return notesToReturnForAcceptedLoginHandle;
    } else {
      return null;
    }
  }
}
