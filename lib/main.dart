import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math show Random;

import 'package:flutter_bloc_learning/orderList.dart';

enum URLs { ORDER_LIST, url2 }

extension UrlString on URLs {
  String get urlString {
    switch (this) {
      case URLs.ORDER_LIST:
        return 'https://raw.githubusercontent.com/pravesh-razor/Own-API-s/main/OrderList.json';
      case URLs.url2:
        return 'https://raw.githubusercontent.com/pravesh-razor/Own-API-s/main/order_api.json';
      default:
        return 'https://jsonplaceholder.typicode.com/posts';
    }
  }
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadURLsAction implements LoadAction {
  final URLs url;
  const LoadURLsAction({required this.url}) : super();
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

Future<Iterable<OrderList>> getOrder(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((res) => res.transform(utf8.decoder).join())
    .then((resstr) => jsonDecode(resstr) as List<dynamic>)
    .then((list) => list.map((e) => OrderList.fromJson(e)));

@immutable
class FetchResult {
  final Iterable<OrderList> orderList;
  final bool isRetrivedFromCache;
  const FetchResult(
      {required this.orderList, this.isRetrivedFromCache = false});

  @override
  String toString() {
    // TODO: implement toString
    return 'FetchResult{orderList: $orderList, isRetrivedFromCache: $isRetrivedFromCache}';
  }
}

class APIbloc extends Bloc<LoadAction, FetchResult?> {
  final Map<URLs, Iterable<OrderList>> _cache = {};
  APIbloc() : super(null) {
    on<LoadURLsAction>((event, emit) async {
      final url = event.url;
      if (_cache.containsKey(url)) {
        final cachedOrders = _cache[url]!;
        final result = FetchResult(
          orderList: cachedOrders,
          isRetrivedFromCache: true,
        );
        emit(result);
      } else {
        final res = await getOrder(url.urlString);
        _cache[url] = res;
        final result = FetchResult(
          orderList: res,
          isRetrivedFromCache: false,
        );
      }
    });
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => APIbloc(),
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // late final NameCubit cubit;

  int _counter = 0;

  void _incrementCounter() {
    // cubit.changeName();
  }

  @override
  void initState() {
    super.initState();
    // cubit = NameCubit();
  }

  @override
  void dispose() {
    super.dispose();
    // cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    // late final Bloc bloc;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    context
                        .read<APIbloc>()
                        .add(LoadURLsAction(url: URLs.ORDER_LIST));
                  },
                  child: Text('Load link 1 '),
                ),
                TextButton(
                  onPressed: () {
                    context
                        .read<APIbloc>()
                        .add(LoadURLsAction(url: URLs.ORDER_LIST));
                  },
                  child: Text('Load link 1 '),
                ),
              ],
            ),
            BlocBuilder<APIbloc, FetchResult?>(buildWhen: (previous, current) {
              return previous?.orderList != current?.orderList;
            }, builder: (context, state) {
              final res = state?.orderList;
              if (res == null) {
                return SizedBox();
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: res.length,
                  itemBuilder: (context, index) {
                    final orders = res[index];
                    return ListTile(
                      title: Text(orders!.orderNumber),
                    );
                  },
                ),
              );
            })
          ],
        )
        // Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       const Text(
        //         'You have pushed the button this many times:',
        //       ),
        //       // Padding(
        //       //   padding: const EdgeInsets.all(8.0),
        //       //   child:
        //       //   StreamBuilder<String?>(
        //       //       stream: cubit.stream,
        //       //       builder: (context, snapshot) {
        //       //         switch (snapshot.connectionState) {
        //       //           case ConnectionState.none:
        //       //           case ConnectionState.waiting:
        //       //             return const Padding(
        //       //               padding: EdgeInsets.all(8.0),
        //       //               child: CircularProgressIndicator(),
        //       //             );
        //       //           case ConnectionState.active:
        //       //             return Text('${snapshot.data}');
        //       //           default:
        //       //             return Text(
        //       //               snapshot.data ?? '',
        //       //               style: Theme.of(context).textTheme.headline4,
        //       //             );
        //       //         }

        //       //         // return Text(
        //       //         //   '${snapshot.data}',
        //       //         //   style: Theme.of(context).textTheme.headline4,
        //       //         // );
        //       //       }),
        //       // ),
        //     ],
        //   ),
        // ),

        );
  }
}
