import 'package:bloc/bloc.dart';
import 'package:testing_bloc_vandad/apis/login_api.dart';
import 'package:testing_bloc_vandad/apis/notes_api.dart';
import 'package:testing_bloc_vandad/bloc/actions.dart';
import 'package:testing_bloc_vandad/bloc/app_state.dart';
import 'package:testing_bloc_vandad/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;
  final LoginHandle acceptedLoginHandle;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
    required this.acceptedLoginHandle,
  }) : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) async {
        //start loading
        emit(
          const AppState(
            isLoading: true,
            loginErrors: null,
            loginHandle: null,
            fetchedNote: null,
          ),
        );

        //log the user in
        final loginHandle = await loginApi.login(
          email: event.email,
          password: event.password,
        );
        emit(
          AppState(
            isLoading: false,
            loginErrors: loginHandle == null ? LoginErrors.invalidHandle : null,
            loginHandle: loginHandle,
            fetchedNote: null,
          ),
        );
      },
    );
    on<LoadNotesAction>(
      (event, emit) async {
        //start loading
        emit(
          AppState(
            isLoading: true,
            loginErrors: null,
            loginHandle: state.loginHandle,
            fetchedNote: null,
          ),
        );

        //get the login handle
        final loginHandle = state.loginHandle;
        if (loginHandle != acceptedLoginHandle) {
          //invalid login handle, can not fetch notes
          emit(
            AppState(
              isLoading: false,
              loginErrors: LoginErrors.invalidHandle,
              loginHandle: loginHandle,
              fetchedNote: null,
            ),
          );
          return;
        }
        //we have a valid login handle and want to fetch notes
        final notes = await notesApi.getNotes(
          loginHandle: loginHandle!,
        );
        emit(
          AppState(
            isLoading: false,
            loginErrors: null,
            loginHandle: loginHandle,
            fetchedNote: notes,
          ),
        );
      },
    );
  }
}
