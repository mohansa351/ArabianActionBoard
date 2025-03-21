import 'package:flutter/material.dart';
import '../../utils/constants.dart';


class TextFilterButton extends StatefulWidget {
  const TextFilterButton({super.key});

  @override
  State<TextFilterButton> createState() => _TextFilterButtonState();
}

class _TextFilterButtonState extends State<TextFilterButton> {
  String _selectedValue = "0";

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        _selectedValue = value;
        setState(() {});
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: '0',
            child: SizedBox(
              width: 135,
              child: Row(
                children: [
                  Text(
                    "A_Z",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Keywords",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          const PopupMenuItem<String>(
            value: '1',
            child: SizedBox(
              width: 135,
              child: Row(
                children: [
                  Icon(Icons.check_box),
                  SizedBox(width: 10),
                  Text(
                    "Approval Type",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          const PopupMenuItem<String>(
            value: '2',
            child: SizedBox(
              width: 135,
              child: Row(
                children: [
                  Icon(Icons.people),
                  SizedBox(width: 10),
                  Text(
                    "Assigned Team",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      child: Container(
        height: 55,
        padding: const EdgeInsets.only(left: 10, right: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _selectedValue == "0"
                ? const Text(
                    "A_Z",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  )
                : _selectedValue == "1"
                    ? const Icon(Icons.check_box)
                    : const Icon(Icons.people),
            const SizedBox(width: 5),
            const Icon(Icons.arrow_drop_down)
          ],
        ),
      ),
    );
  }
}

////
////
//// Bottom sheet for filter

