// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'container.dart';

class ListviewHeader extends StatelessWidget {
  final Size size;
  const ListviewHeader({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const MySizedBox(text: 'N° de série'),
        const SizedBox(
          height: 50,
          child: VerticalDivider(
            color: Colors.black,
            thickness: 1.5,
          ),
        ),
        if (size.width > 230) const MySizedBox(text: 'Utilisateur'),
        if (size.width > 230)
          const SizedBox(
            height: 50,
            child: VerticalDivider(
              color: Colors.black,
              thickness: 1.5,
            ),
          ),
        if (size.width > 310) const MySizedBox(text: 'Type'),
        if (size.width > 310)
          const SizedBox(
            height: 50,
            child: VerticalDivider(
              color: Colors.black,
              thickness: 1.5,
            ),
          ),
        if (size.width > 390) const MySizedBox(text: 'Site'),
        if (size.width > 390)
          const SizedBox(
            height: 50,
            child: VerticalDivider(
              color: Colors.black,
              thickness: 1.5,
            ),
          ),
        if (size.width > 470) const MySizedBox(text: 'Debut de contrat'),
        if (size.width > 470)
          const SizedBox(
            height: 50,
            child: VerticalDivider(
              color: Colors.black,
              thickness: 1.5,
            ),
          ),
        if (size.width > 550) const MySizedBox(text: 'fin de contrat'),
        if (size.width > 550)
          const SizedBox(
            height: 50,
            child: VerticalDivider(
              color: Colors.black,
              thickness: 1.5,
            ),
          ),
      ],
    );
  }
}
