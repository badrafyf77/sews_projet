// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:sews_projet/constants.dart';

class MyDropDownField extends StatelessWidget {
  final bool isContractPage;
  final bool filre;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;
  final List<String> items;
  final String hintText;
  final String selectedItem;
  const MyDropDownField({
    Key? key,
    this.isContractPage = false,
    this.filre = false,
    this.validator,
    required this.onChanged,
    required this.items,
    required this.hintText,
    this.selectedItem = "null",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      value: selectedItem == "null" ? null : selectedItem,
      validator: validator,
      isExpanded: true,
      style: (filre)
          ? const TextStyle(
              fontSize: 12,
            )
          : null,
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                      color: (isContractPage) ? Colors.white : Colors.black),
                ),
              ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(
            width: 1.5,
            color: (isContractPage) ? Colors.white : kPrimaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(
            width: 1.5,
            color: (isContractPage) ? Colors.white : kPrimaryColor,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(
            width: 1.5,
            color: Colors.red,
          ),
        ),
      ),
      buttonStyleData: const ButtonStyleData(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25))),
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: (isContractPage) ? Colors.white : kPrimaryColor,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: (isContractPage) ? kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
