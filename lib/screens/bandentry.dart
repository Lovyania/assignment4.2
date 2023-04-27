import 'package:flutter/material.dart';
import 'package:assignment_4_2/models/bandmodel.dart';
import 'package:assignment_4_2/databases/banddatabase.dart';

class AddBandScreen extends StatefulWidget {
  @override
  _AddBandScreenState createState() => _AddBandScreenState();
}

class _AddBandScreenState extends State<AddBandScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedGenre;
  final List<String> _genres = ['Rock', 'Pop', 'Hip-hop', 'Jazz', 'Country'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _selectedGenre == null) {
      return;
    }

    final band = Band(name: name, genre: _selectedGenre!);
    await BandsDatabase.instance.createBand(band);

    Navigator.pop(context, true);
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
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Genre',
              ),
              value: _selectedGenre,
              onChanged: (String? value) {
                setState(() {
                  _selectedGenre = value;
                });
              },
              items: _genres.map((String genre) {
                return DropdownMenuItem<String>(
                  value: genre,
                  child: Text(genre),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
