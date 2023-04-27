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
  late TextEditingController _memberController;
  late TextEditingController _instrumentController;

  String? _selectedinstrument;
  final List<String> _instruments = ['Vocal', 'Guitar', 'Bass', 'Keyboard', 'Drums'];

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
    final memberName = _memberController.text.trim();
    final instrument = _instrumentController.text.trim();
    if (memberName.isNotEmpty && instrument.isNotEmpty) {
      final member = Member(
        bandId: widget.bandId,
        memberName: memberName,
        instrument: instrument,
      );
      await BandsDatabase.instance.createMember(member);
      Navigator.pop(context);
    }
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
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Instrument',
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
