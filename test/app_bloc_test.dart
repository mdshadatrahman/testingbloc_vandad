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

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptedEmail;
  final String accpetedPassword;
  final LoginHandle handleToReturn;

  const DummyLoginApi({
    required this.acceptedEmail,
    required this.accpetedPassword,
    required this.handleToReturn,
  });

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        accpetedPassword = '',
        handleToReturn = const LoginHandle.fooBar();

  @override
  Future<LoginHandle?> login({required String email, required String password}) async {
    if (email == acceptedEmail && password == accpetedPassword) {
      return handleToReturn;
    } else {
      return null;
    }
  }
}

const acceptedLoginHandle = LoginHandle(token: 'ABC');

void main() {
  blocTest<AppBloc, AppState>(
    'Initial state of the bloc should be AppState.empty()',
    build: () => AppBloc(
      loginApi: const DummyLoginApi.empty(),
      notesApi: const DummyNotesApi.empty(),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    verify: (appState) => expect(appState.state, const AppState.empty()),
  );

  blocTest<AppBloc, AppState>(
    'Can we login with correct credentials',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: 'shadat@gmail.com',
        accpetedPassword: '123123',
        handleToReturn: acceptedLoginHandle,
      ),
      notesApi: const DummyNotesApi.empty(),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(email: 'shadat@gmail.com', password: '123123'),
    ),
    expect: () => [
      const AppState(isLoading: true, loginErrors: null, loginHandle: null, fetchedNote: null),
      const AppState(isLoading: false, loginErrors: null, loginHandle: acceptedLoginHandle, fetchedNote: null),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Should not be logged in with invalid credentials',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: 'rahman@gmail.com',
        accpetedPassword: '123123',
        handleToReturn: acceptedLoginHandle,
      ),
      notesApi: const DummyNotesApi.empty(),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(email: 'shadat@gmail.com', password: '123123'),
    ),
    expect: () => [
      const AppState(isLoading: true, loginErrors: null, loginHandle: null, fetchedNote: null),
      const AppState(isLoading: false, loginErrors: LoginErrors.invalidHandle, loginHandle: null, fetchedNote: null),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Load notes with a valid login',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: 'shadat@gmail.com',
        accpetedPassword: '123123',
        handleToReturn: acceptedLoginHandle,
      ),
      notesApi: const DummyNotesApi(
        acceptLoginHandle: acceptedLoginHandle,
        notesToReturnForAcceptedLoginHandle: mockNotes,
      ),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    act: (appBloc) {
      appBloc.add(
        const LoginAction(email: 'shadat@gmail.com', password: '123123'),
      );
      appBloc.add(
        const LoadNotesAction(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
        loginErrors: null,
        loginHandle: null,
        fetchedNote: null,
      ),
      const AppState(
        isLoading: false,
        loginErrors: null,
        loginHandle: acceptedLoginHandle,
        fetchedNote: null,
      ),
      const AppState(
        isLoading: true,
        loginErrors: null,
        loginHandle: acceptedLoginHandle,
        fetchedNote: null,
      ),
      const AppState(
        isLoading: false,
        loginErrors: null,
        loginHandle: acceptedLoginHandle,
        fetchedNote: mockNotes,
      ),
    ],
  );
}
