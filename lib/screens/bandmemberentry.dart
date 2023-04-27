import 'package:flutter/material.dart';
import 'package:assignment_4_2/databases/banddatabase.dart';
import 'package:assignment_4_2/models/bandmodel.dart';

class BandMemberEntry extends StatefulWidget {
  @override
  _BandMemberEntryState createState() => _BandMemberEntryState();
}

class _BandMemberEntryState extends State<BandMemberEntry> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  int _selectedBandId = 1;
  String _selectedInstrument = '';
  List<Band> _bands = [];

  final List<String> _instruments = [
    'Guitar',
    'Bass',
    'Drums',
    'Keyboard',
    'Vocals',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _fetchBands();
  }

  Future<void> _fetchBands() async {
    final bands = await BandsDatabase.instance.readAllBands();
    setState(() {
      _bands = bands;
    });
  }

  void _saveMember() async {
    final name = _nameController.text;
    final member = BandMember(
      name: name,
      instrument: _selectedInstrument,
      bandId: _selectedBandId,
    );
    await BandsDatabase.instance.createMember(member);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Band Member'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Band',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedBandId,
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedBandId = newValue!;
                    });
                  },
                  items: _bands
                      .map(
                        (band) => DropdownMenuItem<int>(
                          value: band.bandId,
                          child: Text(band.name),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Instrument',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedInstrument,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedInstrument = newValue!;
                    });
                  },
                  items: _instruments
                      .map(
                        (instrument) => DropdownMenuItem<String>(
                          value: instrument,
                          child: Text(instrument),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveMember();
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BandMember(
      {required String name,
      required String instrument,
      required int bandId}) {}
}
