import 'package:asycronys/geolocation.dart';
import 'package:asycronys/navigation_dialog.dart';
import 'package:asycronys/navigation_first.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AzkaOnee aysncronus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NavigationDialogScreen(),
    );
  }
}

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  String result = '';

// soal3
  Future<Response> getData() async {
    const authority = 'www.googleapis.com';
    const path = '/books/v1/volumes/1zYfEQAAQBAJ';
    Uri url = Uri.https(authority, path);
    return http.get(url);
  }
  // end soal 3

// start soal 4
  Future<int> returnOneAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 1;
  }

  Future<int> returnTwoAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 2;
  }

  Future<int> returnThreeAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 3;
  }

  Future count() async {
    int total = 0;
    total = await returnOneAsync();
    total += await returnTwoAsync();
    total += await returnThreeAsync();
    setState(() {
      result = total.toString();
    });
  }
  // end soal 4

  // start  soal5
  late Completer completer;

  Future getNumber() {
    completer = Completer<int>();
    calculate();
    return completer.future;
  }

  Future calculate() async {
    // await Future.delayed(const Duration(seconds: 5));
    // completer.complete(42);
    try {
      await new Future.delayed(const Duration(seconds: 3));
      completer.complete(45);
    } catch (_) {
      completer.completeError({});
    }
  }
  // end soal 5

  // start soal7
  void returnFG() {
    // FutureGroup<int> futureGroup = FutureGroup<int>();
    // futureGroup.add(returnOneAsync());
    // futureGroup.add(returnTwoAsync());
    // futureGroup.add(returnThreeAsync());
    // futureGroup.close();
    final futures = Future.wait<int>([
      returnOneAsync(),
      returnTwoAsync(),
      returnThreeAsync(),
    ]);
    futures.then((List<int> value) {
      int total = 0;
      for (var element in value) {
        total += element;
      }
      setState(() {
        result = total.toString();
      });
    });
  }
  // end soal7

  // start soal 9
  Future returnError() async {
    await Future.delayed(const Duration(seconds: 2));
    throw Exception('SOMETHING TERRIBLE HAPPENED');
  }
  // end soal 9

  Future handleError() async {
    try {
      await returnError();
    } catch (error) {
      setState(() {
        result = error.toString();
      });
    } finally {
      print('COMpleeda');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back From The Future'),
        backgroundColor: Colors.red[600],
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            ElevatedButton(
              child: const Text('GOO!'),
              onPressed: () {
                // setState(() {});
                // getData().then((value) {
                //   result = value.body.toString().substring(0, 100);
                //   setState(() {});
                // }).catchError((_) {
                //   result = 'an error occured';
                //   setState(() {});
                // }); //soal3
                // count(); //soal4

                /*// soal 7&8
                returnFG();*/
                // returnError().then((value) {
                //   setState(() {
                //     result = "successs";
                //   });
                // }).catchError((onError) {
                //   setState(() {
                //     result = onError.toString();
                //   });
                // }).whenComplete(() => print('COMPLETEEEEEE'));
                handleError();
              },
            ),
            const Spacer(),
            Text(result),
            const Spacer(),
            const CircularProgressIndicator(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
