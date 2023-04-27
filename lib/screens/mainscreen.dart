import 'package:flutter/material.dart';
import 'package:assignment_4_2/screens/bandentry.dart';
import 'package:assignment_4_2/models/bandmodel.dart';
import 'package:assignment_4_2/databases/banddatabase.dart';
import 'package:assignment_4_2/screens/banddetailscreen.dart';

class BandsScreen extends StatefulWidget {
  @override
  _BandsScreenState createState() => _BandsScreenState();
}

class _BandsScreenState extends State<BandsScreen> {
  late Future<List<Band>> _bandsFuture;

  @override
  void initState() {
    super.initState();
    _bandsFuture = BandsDatabase.instance.readAllBands();
    _bandsFuture.then((bands) => print('Number of bands: ${bands.length}'));
    _bandsFuture.then((bands) => print('Number of bands: ${bands.length}'));
  }

  Future<void> _refreshBands() async {
    setState(() {
      _bandsFuture = BandsDatabase.instance.readAllBands();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bands'),
      ),
      body: FutureBuilder<List<Band>>(
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
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BandDetailsScreen(band: band)),
                    );
                    if (result != null) {
                      await _refreshBands();
                    }
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
