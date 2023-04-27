import 'package:flutter/material.dart';
import 'package:assignment_4_2/screens/songentry.dart';
import 'package:assignment_4_2/screens/bandmemberentry.dart';
import 'package:assignment_4_2/models/songmodel.dart';
import 'package:assignment_4_2/models/membermodel.dart';
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
  late Future<List<Member>> _membersFuture;

  @override
  void initState() {
    super.initState();
    _songsFuture = BandsDatabase.instance.getSongsByBandId(widget.band.bandId!);
    _membersFuture =
        BandsDatabase.instance.getMembersByBandId(widget.band.bandId!);
  }

  void _addMember() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMemberScreen(bandId: widget.band.bandId!),
      ),
    );
    setState(() {
      _membersFuture =
          BandsDatabase.instance.getMembersByBandId(widget.band.bandId!);
    });
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: FutureBuilder<List<Member>>(
              future: _membersFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final members = snapshot.data!;
                if (members.isEmpty) {
                  return const Center(
                    child: Text(
                      'No members found',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return ListTile(
                      title: Text(member.memberName),
                      subtitle: Text(member.instrument),
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
