import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable; 
import 'package:testing_bloc_vandad/models.dart';

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginErrors;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNote;

  const AppState({
    required this.isLoading,
    required this.loginErrors,
    required this.loginHandle,
    required this.fetchedNote,
  });

  const AppState.empty()
      : isLoading = false,
        loginErrors = null,
        loginHandle = null,
        fetchedNote = null;

  @override
  String toString() => {
        'isLoading': isLoading,
        'loginErrors': loginErrors,
        'loginHandle': loginHandle,
        'fetchedNote': fetchedNote,
      }.toString();

  @override
  bool operator ==(covariant AppState other) {
    final otherPropertiesAreEqual = isLoading == other.isLoading && loginErrors == other.loginErrors && loginHandle == other.loginHandle;
    if (fetchedNote == null && other.fetchedNote == null) {
      return otherPropertiesAreEqual;
    } else {
      return otherPropertiesAreEqual && (fetchedNote?.isEqualTo(other.fetchedNote) ?? false);
    }
  }

  @override
  int get hashCode => Object.hash(isLoading, loginErrors, loginHandle, fetchedNote);
}

extension UnorderedEquality on Object {
  bool isEqualTo(other) => const DeepCollectionEquality.unordered().equals(this, other);
}
