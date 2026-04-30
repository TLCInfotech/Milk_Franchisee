import 'package:flutter/material.dart';
import '../core/localss/api_data_fetch_localization.dart';

import 'package:intl/intl.dart';

import '../core/common_style.dart';

class DateTimePickerField extends StatefulWidget {
  @override
  _DateTimePickerFieldState createState() => _DateTimePickerFieldState();
}

class _DateTimePickerFieldState extends State<DateTimePickerField> {
  TextEditingController _controller = TextEditingController();
  DateTime? _selectedDateTime;

  Future<void> _pickDateTime() async {
    // Step 1: Pick Date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    // Step 2: Pick Time
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
    );

    if (pickedTime == null) return;

    // Step 3: Combine both
    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _selectedDateTime = combined;
      _controller.text = DateFormat('dd-MM-yyyy hh:mm a').format(combined);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      style: item_heading_textStyle,
      decoration: InputDecoration(
        labelText: "Select Date & Time",
        suffixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
      ),
      onTap: _pickDateTime,
    );
  }
}
