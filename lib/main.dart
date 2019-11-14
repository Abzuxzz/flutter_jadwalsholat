import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_jadwalsholat/model/ResponJadwal.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    ));

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<ResponJadwal> getJadwal() async {
    //ngambil data json dari url
    final respone = await http.get(
        "https://muslimsalat.com/jonggol/5.json?key=5941d6fa6768f51fb128b13603d49887");
    //memilih json dari variable respone
    final jsonRespone = json.decode(respone.body);
    //masukkan ke dalam class data ResponJadwal
    return ResponJadwal.fromJsonMap(jsonRespone);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width - 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 6.0,
                        offset: Offset(0.0, -2.0),
                        color: Colors.black)
                  ],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://graphicriver.img.customer.envatousercontent.com/files/256350237/preview.jpg?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=79de2a6488a2480566b12569f23f5970"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.location_on),
                        onPressed: () {}),
                    IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.map),
                        onPressed: () {})
                  ],
                ),
              ),
              FutureBuilder(
                future: getJadwal(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HeaderContent(snapshot.data);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return Positioned.fill(
                      child: Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ));
                },
              )
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: getJadwal(),
              builder: (context, slapshot) {
                if (slapshot.hasData) {
                  return ListJadwal(slapshot.data);
                } else if (slapshot.hasError) {
                  return Text("${slapshot.error}");
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget containerWaktu(String waktu, String jam) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 08.0),
      child: Container(
        height: 70.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 05.0,
              )
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightBlueAccent, Colors.blue])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(waktu,
                  style: TextStyle(color: Colors.white, fontSize: 25.0)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(jam,
                  style: TextStyle(color: Colors.white, fontSize: 25.0)),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderContent extends StatelessWidget {
  ResponJadwal responJadwal;

  HeaderContent(this.responJadwal);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 20.0,
        bottom: 20.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              responJadwal.city,
              style: TextStyle(color: Colors.white, fontSize: 38.0),
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 20.0,
                ),
                Text(
                  responJadwal.address,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                )
              ],
            )
          ],
        ));
  }
}

class ListJadwal extends StatelessWidget {
  ResponJadwal data;

  ListJadwal(this.data);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        containerWaktu("Subuh", data.items[0].fajr.toUpperCase()),
        containerWaktu("Dzuhur", data.items[0].dhuhr.toUpperCase()),
        containerWaktu("Ashar", data.items[0].asr.toUpperCase()),
        containerWaktu("Maghrib", data.items[0].maghrib.toUpperCase()),
        containerWaktu("Isya", data.items[0].isha.toUpperCase()),
      ],
    );
  }

  Widget containerWaktu(String waktu, String jam) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 08.0),
      child: Container(
        height: 70.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 05.0,
              )
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightBlueAccent, Colors.blue])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(waktu,
                  style: TextStyle(color: Colors.white, fontSize: 25.0)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(jam,
                  style: TextStyle(color: Colors.white, fontSize: 25.0)),
            ),
          ],
        ),
      ),
    );
  }
}
