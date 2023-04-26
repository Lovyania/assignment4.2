import 'package:flutter/material.dart';
import 'package:assignment_4_2/models/songmodel.dart';
import 'package:assignment_4_2/databases/banddatabase.dart';

class AddSongScreen extends StatefulWidget {
  final int bandId;

  const AddSongScreen({required this.bandId});
  @override
  _AddSongScreenState createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  late TextEditingController _titleController;
  late TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _yearController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _saveSong() async {
    final title = _titleController.text.trim();
    final year = _yearController.text.trim();
    if (title.isNotEmpty && year.isNotEmpty) {
      final song = Song(
        bandId: widget.bandId,
        title: title,
        releaseYear: int.parse(year),
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
            Text(
              'Song Title',
              style: TextStyle(fontSize: 16.0),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter song title',
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Release Year',
              style: TextStyle(fontSize: 16.0),
            ),
            TextField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter release year',
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _saveSong,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
