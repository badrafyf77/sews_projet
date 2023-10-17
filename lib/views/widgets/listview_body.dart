// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:sews_projet/model/models/models.dart';

import 'container.dart';
import 'line.dart';

class ListviewBody extends StatelessWidget {
  final Size size;
  final int index;
  final List<Appareil> appareilList;
  const ListviewBody({
    Key? key,
    required this.size,
    required this.index,
    required this.appareilList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (index % 2 == 1) ? Colors.grey[350] : Colors.grey[200],
      width: size.width,
      height: 80,
      child: Center(
        child: IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    appareilList[index].id,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const MyVerticalLine(),
              if (size.width > 230)
                MySizedBox(text: appareilList[index].utilisateur),
              if (size.width > 230) const MyVerticalLine(),
              if (size.width > 310)
                MySizedBox(text: appareilList[index].appareil),
              if (size.width > 310) const MyVerticalLine(),
              if (size.width > 390) MySizedBox(text: appareilList[index].site),
              if (size.width > 390) const MyVerticalLine(),
              if (size.width > 470)
                MySizedBox(text: appareilList[index].debutContrat),
              if (size.width > 470) const MyVerticalLine(),
              if (size.width > 550)
                MySizedBox(text: appareilList[index].finContrat),
              if (size.width > 550) const MyVerticalLine(),
              if (size.width > 630)
                appareilList[index].a7 != 'null'
                    ? MySizedBox(text: appareilList[index].a7)
                    : const SizedBox(),
              if (size.width > 630)
                appareilList[index].a7 != 'null'
                    ? const MyVerticalLine()
                    : const SizedBox(),
              if (size.width > 710)
                appareilList[index].a8 != 'null'
                    ? MySizedBox(text: appareilList[index].a8)
                    : const SizedBox(),
              if (size.width > 710)
                appareilList[index].a8 != 'null'
                    ? const MyVerticalLine()
                    : const SizedBox(),
              if (size.width > 790)
                appareilList[index].a9 != 'null'
                    ? MySizedBox(text: appareilList[index].a9)
                    : const SizedBox(),
              if (size.width > 790)
                appareilList[index].a9 != 'null'
                    ? const MyVerticalLine()
                    : const SizedBox(),
              if (size.width > 870)
                appareilList[index].a10 != 'null'
                    ? MySizedBox(text: appareilList[index].a10)
                    : const SizedBox(),
              if (size.width > 870)
                appareilList[index].a10 != 'null'
                    ? const MyVerticalLine()
                    : const SizedBox(),
              if (size.width > 950)
                appareilList[index].a11 != 'null'
                    ? MySizedBox(text: appareilList[index].a11)
                    : const SizedBox(),
              if (size.width > 950)
                appareilList[index].a11 != 'null'
                    ? const MyVerticalLine()
                    : const SizedBox(),
              if (size.width > 1030)
                appareilList[index].a12 != 'null'
                    ? MySizedBox(text: appareilList[index].a12)
                    : const SizedBox(),
              if (size.width > 1030)
                appareilList[index].a12 != 'null'
                    ? const MyVerticalLine()
                    : const SizedBox(),
              if (size.width > 1110)
                appareilList[index].a13 != 'null'
                    ? MySizedBox(text: appareilList[index].a13)
                    : const SizedBox(),
              if (size.width > 1110)
                appareilList[index].a13 != 'null'
                    ? const MyVerticalLine()
                    : const SizedBox(),
              if (size.width > 1190)
                appareilList[index].a14 != 'null'
                    ? MySizedBox(text: appareilList[index].a14)
                    : const SizedBox(),
              if (size.width > 1190)
                appareilList[index].a14 != 'null'
                    ? const MyVerticalLine()
                    : const SizedBox(),
              if (size.width > 1270)
                appareilList[index].a15 != 'null'
                    ? MySizedBox(text: appareilList[index].a15)
                    : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
