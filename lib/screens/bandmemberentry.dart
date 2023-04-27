import 'package:assignment_4_2/models/membermodel.dart';
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
  final TextEditingController _memberController = TextEditingController();
  String? _selectedinstrument;
  final List<String> _instruments = ['Vocal', 'Guitar', 'Bass', 'Keyboard', 'Drums'];

  @override
  void dispose() {
    _memberController.dispose();
    super.dispose();
  }

  void _saveMember() async {
    final memberName = _memberController.text.trim();
    if (memberName.isEmpty || _selectedinstrument == null) {
      return;
    }

    final member = Member(memberName: memberName, instrument: _selectedinstrument!, bandId: widget.bandId);
    await BandsDatabase.instance.createMember(member);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Band Member'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Member Name:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _memberController,
              decoration: InputDecoration(
                hintText: 'Enter band member name',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Instrument:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select instrument',
              ),
              value: _selectedinstrument,
              onChanged: (String? value) {
                setState(() {
                  _selectedinstrument = value;
                });
              },
              items: _instruments.map((String instrument) {
                return DropdownMenuItem<String>(
                  value: instrument,
                  child: Text(instrument),
                );
              }).toList(),
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
