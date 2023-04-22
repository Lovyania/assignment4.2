import 'package:flutter/material.dart';
import 'package:assignment_4_2/models/bandmodel.dart';
import 'package:assignment_4_2/database/database.dart';

class AddBandScreen extends StatefulWidget {
  @override
  _AddBandScreenState createState() => _AddBandScreenState();
}

class _AddBandScreenState extends State<AddBandScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final name = _nameController.text.trim();
    final genre = _genreController.text.trim();

    if (name.isEmpty || genre.isEmpty) {
      return;
    }

    final band = Band(name: name, genre: genre);
    await BandsDatabase.instance.create(band);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Band'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _genreController,
              decoration: InputDecoration(
                labelText: 'Genre',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Add Band'),
            ),
          ],
        ),
      ),
    );
  }
}
