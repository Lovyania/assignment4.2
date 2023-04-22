import 'package:flutter/material.dart';
import 'package:assignment_4_2/screens/bandentry.dart';
import 'package:assignment_4_2/models/bandmodel.dart';
import 'package:assignment_4_2/database/database.dart';

class BandsScreen extends StatefulWidget {
  @override
  _BandsScreenState createState() => _BandsScreenState();
}

class _BandsScreenState extends State<BandsScreen> {
  late Future<List<Band>> _bandsFuture;

  @override
  void initState() {
    super.initState();
    _bandsFuture = BandsDatabase.instance.readAll();
  }

  Future<void> _refreshBands() async {
    setState(() {
      _bandsFuture = BandsDatabase.instance.readAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bands'),
      ),
      body: FutureBuilder(
        future: _bandsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Band>> snapshot) {
          if (snapshot.hasData) {
            final bands = snapshot.data!;
            return ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context, int index) {
                final band = bands[index];
                return ListTile(
                  title: Text(band.name),
                  subtitle: Text(band.genre),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBandScreen()),
          );
          await _refreshBands();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
