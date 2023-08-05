import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final TextEditingController _latitude = TextEditingController();
  final TextEditingController _longitude = TextEditingController();
  final TextEditingController _zoom = TextEditingController();
  int? xGlobal;
  int? yGlobal;
  int? zGlobal;

  @override
  void dispose() {
    _latitude.dispose();
    _longitude.dispose();
    _zoom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            controller: _latitude,
            decoration: InputDecoration(hintText: "Введите широту"),
          ),
          TextFormField(
            controller: _longitude,
            decoration: InputDecoration(hintText: "Введите долготу"),
          ),
          TextFormField(
            controller: _zoom,
            decoration: InputDecoration(hintText: "Введите зум"),
          ),
          TextButton(
              onPressed: () {
                const double e = 0.0818191908426;
                const pi = 3.14;
                double b = (pi * double.parse(_latitude.text)) / 180;
                double fi = ((1 - e * sin(b)) / (1 + e * sin(b)));
                double fita = tan(pi / 4 + b / 2) * pow(fi, e / 2);
                double p = (pow(2, double.parse(_zoom.text) + 8) / 2);

                double x = p * (1 + ((double.parse(_longitude.text)) / 180));
                double y = p * (1 - log(fita) / pi);

                setState(() {
                  xGlobal = (x / 256).floor();
                  yGlobal = (y / 256).floor();
                  zGlobal = int.parse(_zoom.text);
                });
              },
              child: Text("Найти тайлы")),
          Text(
              "Найденные координаты тайла: x=${xGlobal ?? 0}, y=${yGlobal ?? 0}, z= ${zGlobal ?? 0},"),
          Container(
            child: Image.network(
              "https://core-carparks-renderer-lots.maps.yandex.net/maps-rdr-carparks/tiles?l=carparks&x=$xGlobal&y=$yGlobal&z=$zGlobal&scale=1&lang=ru_RU",
            ),
          )
        ],
      ),
    );
  }
}
