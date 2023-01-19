import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_vandad/bloc/bloc_actions.dart';
import 'package:testing_bloc_vandad/bloc/person.dart';

extension IsEqualToIgnoringOrdering<T> on Iterable<T> {
  bool isEqualToIgnoringOrdering(Iterable<T> other) => length == other.length && {...this}.intersection({...other}).length == length;
}

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrieveFromCache;

  const FetchResult({
    required this.persons,
    required this.isRetrieveFromCache,
  });

  @override
  String toString() => 'FetchResult (isRetrieveFromCache = $isRetrieveFromCache, persons = $persons)';

  @override
  bool operator ==(covariant FetchResult other) =>
      persons.isEqualToIgnoringOrdering(other.persons) && isRetrieveFromCache == other.isRetrieveFromCache;

  @override
  int get hashCode => Object.hash(persons, isRetrieveFromCache);
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};
  PersonsBloc() : super(null) {
    on<LoadPersonsAction>(
      (event, emit) async {
        final url = event.url;
        if (_cache.containsKey(url)) {
          final cachedPersons = _cache[url]!;
          final result = FetchResult(persons: cachedPersons, isRetrieveFromCache: true);
          emit(result);
        } else {
          final loader = event.personsLoader;
          final persons = await loader(url);
          _cache[url] = persons;
          final result = FetchResult(persons: persons, isRetrieveFromCache: false);
          emit(result);
        }
      },
    );
  }
}
