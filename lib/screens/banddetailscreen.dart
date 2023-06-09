import 'package:flutter/material.dart';
import 'package:assignment_4_2/screens/songentry.dart';
import 'package:assignment_4_2/models/songmodel.dart';
import 'package:assignment_4_2/models/bandmodel.dart';
import 'package:assignment_4_2/databases/banddatabase.dart';

class BandDetailsScreen extends StatefulWidget {
  final Band band;

  const BandDetailsScreen({Key? key, required this.band}) : super(key: key);

  @override
  _BandDetailsScreenState createState() => _BandDetailsScreenState();
}

class _BandDetailsScreenState extends State<BandDetailsScreen> {
  late Future<List<Song>> _songsFuture;

  @override
  void initState() {
    super.initState();
    _songsFuture = BandsDatabase.instance.getSongsByBandId(widget.band.bandId!);
  }

  void _addSong() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSongScreen(bandId: widget.band.bandId!),
      ),
    );
    setState(() {
      _songsFuture =
          BandsDatabase.instance.getSongsByBandId(widget.band.bandId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.band.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/genre.png',
                  width: 250,
                  height: 250,
                ),
                const SizedBox(height: 16),
                Text(
                  widget.band.genre,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Members',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Songs',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: FutureBuilder<List<Song>>(
              future: _songsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final songs = snapshot.data!;
                if (songs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No songs found',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return ListTile(
                      title: Text(song.title),
                      subtitle: Text('Released in ${song.releaseYear}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addSong,
        icon: const Icon(Icons.add),
        label: const Text('Add song'),
      ),
    );
  }
}
