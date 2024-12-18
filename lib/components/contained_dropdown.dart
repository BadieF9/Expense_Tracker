import 'package:flutter/material.dart';

class ContainedDropdown extends StatefulWidget {
  final String hintText;
  final List<DropdownMenuItem<String>> items;
  final String? initialValue;
  final ValueChanged<String?> onChanged;

  const ContainedDropdown({
    Key? key,
    required this.hintText,
    required this.items,
    this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ContainedDropdown> createState() => _ContainedDropdownState();
}

class _ContainedDropdownState extends State<ContainedDropdown> {
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton<String>(
        hint: Text(widget.hintText),
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        underline: Container(),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue;
          });
          widget.onChanged(newValue); // Call the callback function
        },
        items: widget.items,
        isExpanded: true,
        dropdownColor: Colors.white,
      ),
    );
  }
}
