import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:testing_bloc_vandad/bloc/bloc_actions.dart';
import 'package:testing_bloc_vandad/bloc/person.dart';
import 'package:testing_bloc_vandad/bloc/persons_bloc.dart';

const mockedPerson1 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];

const mockedPerson2 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];

Future<Iterable<Person>> mockGetPersons1(String _) => Future.value(mockedPerson1);
Future<Iterable<Person>> mockGetPersons2(String _) => Future.value(mockedPerson2);

void main() {
  group('Testing bloc', () {
    late PersonsBloc bloc;

    setUp(() {
      bloc = PersonsBloc();
    });

    blocTest<PersonsBloc, FetchResult?>(
      'Test Initial state',
      build: () => bloc,
      verify: (bloc) => expect(bloc.state, null),
    );

    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving persons from first iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_1',
            personsLoader: mockGetPersons1,
          ),
        );
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_1',
            personsLoader: mockGetPersons1,
          ),
        );
      },
      expect: () => [
        const FetchResult(persons: mockedPerson1, isRetrieveFromCache: false),
        const FetchResult(persons: mockedPerson1, isRetrieveFromCache: true),
      ],
    );

    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving persons from second iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_2',
            personsLoader: mockGetPersons2,
          ),
        );
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_2',
            personsLoader: mockGetPersons2,
          ),
        );
      },
      expect: () => [
        const FetchResult(persons: mockedPerson2, isRetrieveFromCache: false),
        const FetchResult(persons: mockedPerson2, isRetrieveFromCache: true),
      ],
    );
  });
}
