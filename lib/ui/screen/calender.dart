import 'package:flutter/material.dart';
import 'package:project1/ui/screen/RootPage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('eventDate', isGreaterThanOrEqualTo: _selectedDay.toIso8601String())
        .where('eventDate', isLessThanOrEqualTo: _selectedDay.add(Duration(days: 1)).toIso8601String())
        .get();

    setState(() {
      _events = snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: const Text('Farming Calendar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RootPage()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _fetchEvents();
                _showEventDialog(context, selectedDay);
              },
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Selected Date: ${_selectedDay.toLocal()}'.split(' ')[0],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];
                  return ListTile(
                    title: Text(event['eventName']),
                    subtitle: Text(event['eventDate']),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditEventDialog(context, event),
                    ),
                    onLongPress: () => _deleteEvent(event['id']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventDialog(BuildContext context, DateTime selectedDate) {
    final TextEditingController _eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: TextField(
          controller: _eventController,
          decoration: const InputDecoration(labelText: 'Event Name'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_eventController.text.isNotEmpty) {
                await FirebaseFirestore.instance.collection('events').add({
                  'eventName': _eventController.text,
                  'eventDate': selectedDate.toIso8601String(),
                  'createdAt': FieldValue.serverTimestamp(),
                });
                Navigator.of(context).pop();
                _fetchEvents();
              }
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showEditEventDialog(BuildContext context, Map<String, dynamic> event) {
    final TextEditingController _eventController = TextEditingController(text: event['eventName']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Event'),
        content: TextField(
          controller: _eventController,
          decoration: const InputDecoration(labelText: 'Event Name'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_eventController.text.isNotEmpty) {
                await FirebaseFirestore.instance.collection('events').doc(event['id']).update({
                  'eventName': _eventController.text,
                });
                Navigator.of(context).pop();
                _fetchEvents();
              }
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteEvent(String id) async {
    await FirebaseFirestore.instance.collection('events').doc(id).delete();
    _fetchEvents();
  }
}
