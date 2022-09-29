import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math show Random;

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
    late final Bloc bloc;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child:
            //   StreamBuilder<String?>(
            //       stream: cubit.stream,
            //       builder: (context, snapshot) {
            //         switch (snapshot.connectionState) {
            //           case ConnectionState.none:
            //           case ConnectionState.waiting:
            //             return const Padding(
            //               padding: EdgeInsets.all(8.0),
            //               child: CircularProgressIndicator(),
            //             );
            //           case ConnectionState.active:
            //             return Text('${snapshot.data}');
            //           default:
            //             return Text(
            //               snapshot.data ?? '',
            //               style: Theme.of(context).textTheme.headline4,
            //             );
            //         }

            //         // return Text(
            //         //   '${snapshot.data}',
            //         //   style: Theme.of(context).textTheme.headline4,
            //         // );
            //       }),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
