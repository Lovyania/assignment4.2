import 'package:flutter/material.dart';
import 'package:assignment_4_2/screens/songentry.dart';
import 'package:assignment_4_2/models/bandmodel.dart';
import 'package:assignment_4_2/databases/banddatabase.dart';

class BandDetailsScreen extends StatelessWidget {
  final Band band;

  const BandDetailsScreen({Key? key, required this.band}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(band.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[300],
            child: Text(
              band.genre,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Song>>(
              future: BandsDatabase.instance.getSongsByBandId(band.bandId!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final songs = snapshot.data!;
                if (songs.isEmpty) {
                  return Center(child: Text('No songs found'));
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddSongScreen(bandId: band.bandId!),
                  ),
                );
                setState(() {});
              },
              child: Text('Add Song'),
            ),
          ),
        ],
      ),
    );
  }
}
