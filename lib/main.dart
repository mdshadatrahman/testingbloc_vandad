import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_vandad/apis/login_api.dart';
import 'package:testing_bloc_vandad/apis/notes_api.dart';
import 'package:testing_bloc_vandad/bloc/actions.dart';
import 'package:testing_bloc_vandad/bloc/app_bloc.dart';
import 'package:testing_bloc_vandad/bloc/app_state.dart';
import 'package:testing_bloc_vandad/dialogs/generic_dialog.dart';
import 'package:testing_bloc_vandad/dialogs/loading_screen.dart';
import 'package:testing_bloc_vandad/models.dart';
import 'package:testing_bloc_vandad/strings.dart';
import 'package:testing_bloc_vandad/views/iterable_list_view.dart';
import 'package:testing_bloc_vandad/views/login_view.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
        acceptedLoginHandle: const LoginHandle.fooBar(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            //loading screen
            if (appState.isLoading) {
              LoadingScreen.instance().show(context: context, text: pleaseWait);
            } else {
              LoadingScreen.instance().hide();
            }

            //display possible errors
            final loginError = appState.loginErrors;
            if (loginError != null) {
              showGenericDialog<bool>(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionsBuilder: () => {ok: true},
              );
            }

            //if we are logged in, but no notes were fetched, fetch them
            if (appState.isLoading == false &&
                appState.loginErrors == null &&
                appState.loginHandle == const LoginHandle.fooBar() &&
                appState.fetchedNote == null) {
              context.read<AppBloc>().add(const LoadNotesAction());
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchedNote;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
