import 'package:flutter/foundation.dart' show immutable;
import 'package:testingbloc_course/bloc/person.dart';

// enum PersonUrl {
//   persons1,
//   persons2,
// }

// extension UrlString on PersonUrl {
//   String get urlString {
//     switch (this) {
//       case PersonUrl.persons1:
//         return 'https://raw.githubusercontent.com/vandadnp/youtube-course-bloc/main/api/persons1.json';
//       case PersonUrl.persons2:
//         return 'https://raw.githubusercontent.com/vandadnp/youtube-course-bloc/main/api/persons2.json';
//     }
//   }
// }
const persons1Url =
    'https://raw.githubusercontent.com/vandadnp/youtube-course-bloc/main/api/persons1.json';
const persons2Url =
    'https://raw.githubusercontent.com/vandadnp/youtube-course-bloc/main/api/persons2.json';

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonsLoader loader;
  const LoadPersonsAction({
    required this.url,
    required this.loader,
  }) : super();
}
