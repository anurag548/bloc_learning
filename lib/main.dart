import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_learning/order2.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter_bloc_learning/orderList.dart';

extension LogIT on Object {
  void log() => devtools.log(toString());
}

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
    .then((resstr) => orderFromJson(resstr))
    .then((ordList) => ordList.orderList);

Future<Iterable<Datum>> getOrder2(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((res) => res.transform(utf8.decoder).join())
    .then((resstr) => order2FromJson(resstr))
    .then((ordList) => ordList.data);
// .then((list) => list.map((e) => OrderList.fromJson(e)));

@immutable
class FetchResult {
  final Iterable<OrderList>? orderList;
  final Iterable<Datum>? order2;
  final bool isRetrivedFromCache;
  const FetchResult(
      {this.orderList, required this.isRetrivedFromCache, this.order2});

  @override
  String toString() {
    // TODO: implement toString
    return 'FetchResult{orderList: $orderList, isRetrivedFromCache: $isRetrivedFromCache, order2: $order2}';
  }
}

class APIbloc extends Bloc<LoadAction, FetchResult?> {
  final Map<URLs, Iterable<OrderList>> _cache = {};
  final Map<URLs, Iterable<Datum>> _cache2 = {};
  APIbloc() : super(null) {
    on<LoadURLsAction>((event, emit) async {
      final url = event.url;
      if (event.url == URLs.ORDER_LIST) {
        if (_cache.containsKey(url)) {
          final cachedOrders = _cache[url]!;
          final result = FetchResult(
            orderList: cachedOrders,
            isRetrivedFromCache: true,
          );
          result.log();
          emit(result);
        } else {
          final res = await getOrder(url.urlString);
          _cache[url] = res;
          final result = FetchResult(
            orderList: res,
            isRetrivedFromCache: false,
          );
          result.log();
        }
      }
      if (event.url == URLs.url2) {
        if (_cache.containsKey(url)) {
          final cachedOrders = _cache[url]!;
          final result = FetchResult(
            orderList: cachedOrders,
            isRetrivedFromCache: true,
          );
          result.log();

          emit(result);
        } else {
          final res = await getOrder2(url.urlString);
          devtools.log(res.toString());
          _cache2[url] = res;
          final result = FetchResult(
            // orderList: res,
            order2: res,
            isRetrivedFromCache: false,
          );
          result.log();
        }
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
                  child: const Text('Load link 1'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<APIbloc>().add(LoadURLsAction(url: URLs.url2));
                  },
                  child: const Text('Load link 2'),
                ),
              ],
            ),
            BlocBuilder<APIbloc, FetchResult?>(buildWhen: (previous, current) {
              return previous != current;
            }, builder: (context, state) {
              final res = state?.orderList;
              final res2 = state?.order2;

              if (res != null) {
                print('insdie res condition');
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
              } else if (res2 != null) {
                print('insdie res2 condition');
                return Expanded(
                  child: ListView.builder(
                    itemCount: res2.length,
                    itemBuilder: (context, index) {
                      final orders = res2[index];
                      return ListTile(
                        title: Text(orders!.name),
                      );
                    },
                  ),
                );
              }
              return SizedBox();
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
