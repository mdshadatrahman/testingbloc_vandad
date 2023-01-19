import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc_vandad/bloc/person.dart';

const person1Url = 'http://10.0.2.2:5500/api/persons1.json';
const person2Url = 'http://10.0.2.2:5500/api/persons2.json';

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonsLoader personsLoader;

  const LoadPersonsAction({required this.url, required this.personsLoader}) : super();
}
