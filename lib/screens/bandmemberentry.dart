import 'package:flutter/material.dart';
import 'package:assignment_4_2/models/songmodel.dart';
import 'package:assignment_4_2/databases/banddatabase.dart';

class AddMemberScreen extends StatefulWidget {
  final int bandId;

  const AddMemberScreen({required this.bandId});
  @override
  _AddMemberScreenState createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  late TextEditingController _memberController;
  late TextEditingController _instrumentController;

  @override
  void initState() {
    super.initState();
    _memberController = TextEditingController();
    _instrumentController = TextEditingController();
  }

  @override
  void dispose() {
    _memberController.dispose();
    _instrumentController.dispose();
    super.dispose();
  }

  void _saveMember() async {
    final member = _memberController.text.trim();
    final instrument = _instrumentController.text.trim();
    if (member.isNotEmpty && instrument.isNotEmpty) {
      final song = Song(
        bandId: widget.bandId,
        title: member,
        releaseYear: int.parse(instrument),
      );
      await BandsDatabase.instance.createSong(song);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Song'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Song Title:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _memberController,
              decoration: InputDecoration(
                hintText: 'Enter band member',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Released in Year:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _instrumentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter instrument',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveMember,
              style: ElevatedButton.styleFrom(fixedSize: const Size(500, 20)),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
