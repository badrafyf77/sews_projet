// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

import 'package:sews_projet/components/no_result.dart';
import 'package:sews_projet/models/model.dart';

import 'container.dart';
import 'line.dart';

class ItemsListview extends StatelessWidget {
  final Size size;
  final List<Appareil> appareilList;
  final SwipeActionController controller;
  final void Function()? onGestureDetectorTap;
  const ItemsListview({
    Key? key,
    required this.size,
    required this.appareilList,
    required this.controller,
    required this.onGestureDetectorTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return appareilList.isEmpty
        ? NoRestultAnimation(size: size)
        : Expanded(
            child: ListView.builder(
              itemCount: appareilList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (index == 0)
                      Row(
                        children: [
                          const MySizedBox(text: 'N° de série'),
                          const SizedBox(
                            height: 50,
                            child: VerticalDivider(
                              color: Colors.black,
                              thickness: 1.5,
                            ),
                          ),
                          if (size.width > 230)
                            const MySizedBox(text: 'Utilisateur'),
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
                          if (size.width > 470)
                            const MySizedBox(text: 'Debut de contrat'),
                          if (size.width > 470)
                            const SizedBox(
                              height: 50,
                              child: VerticalDivider(
                                color: Colors.black,
                                thickness: 1.5,
                              ),
                            ),
                          if (size.width > 550)
                            const MySizedBox(text: 'fin de contrat'),
                          if (size.width > 550)
                            const SizedBox(
                              height: 50,
                              child: VerticalDivider(
                                color: Colors.black,
                                thickness: 1.5,
                              ),
                            ),
                        ],
                      ),
                    const SizedBox(
                      height: 2,
                    ),
                    SwipeActionCell(
                      controller: controller,
                      index: index,
                      key: ValueKey(appareilList[index]),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: onGestureDetectorTap,
                          child: Container(
                            color: (index % 2 == 1)
                                ? Colors.grey[350]
                                : Colors.grey[200],
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
                                      MySizedBox(
                                          text:
                                              appareilList[index].utilisateur),
                                    if (size.width > 230)
                                      const MyVerticalLine(),
                                    if (size.width > 310)
                                      MySizedBox(
                                          text: appareilList[index].appareil),
                                    if (size.width > 310)
                                      const MyVerticalLine(),
                                    if (size.width > 390)
                                      MySizedBox(
                                          text: appareilList[index].site),
                                    if (size.width > 390)
                                      const MyVerticalLine(),
                                    if (size.width > 470)
                                      MySizedBox(
                                          text:
                                              appareilList[index].debutContrat),
                                    if (size.width > 470)
                                      const MyVerticalLine(),
                                    if (size.width > 550)
                                      MySizedBox(
                                          text: appareilList[index].finContrat),
                                    if (size.width > 550)
                                      const MyVerticalLine(),
                                    if (size.width > 630)
                                      appareilList[index].a7 != 'null'
                                          ? MySizedBox(
                                              text: appareilList[index].a7)
                                          : const SizedBox(),
                                    if (size.width > 630)
                                      appareilList[index].a7 != 'null'
                                          ? const MyVerticalLine()
                                          : const SizedBox(),
                                    if (size.width > 710)
                                      appareilList[index].a8 != 'null'
                                          ? MySizedBox(
                                              text: appareilList[index].a8)
                                          : const SizedBox(),
                                    if (size.width > 710)
                                      appareilList[index].a8 != 'null'
                                          ? const MyVerticalLine()
                                          : const SizedBox(),
                                    if (size.width > 790)
                                      appareilList[index].a9 != 'null'
                                          ? MySizedBox(
                                              text: appareilList[index].a9)
                                          : const SizedBox(),
                                    if (size.width > 790)
                                      appareilList[index].a9 != 'null'
                                          ? const MyVerticalLine()
                                          : const SizedBox(),
                                    if (size.width > 870)
                                      appareilList[index].a10 != 'null'
                                          ? MySizedBox(
                                              text: appareilList[index].a10)
                                          : const SizedBox(),
                                    if (size.width > 870)
                                      appareilList[index].a10 != 'null'
                                          ? const MyVerticalLine()
                                          : const SizedBox(),
                                    if (size.width > 950)
                                      appareilList[index].a11 != 'null'
                                          ? MySizedBox(
                                              text: appareilList[index].a11)
                                          : const SizedBox(),
                                    if (size.width > 950)
                                      appareilList[index].a11 != 'null'
                                          ? const MyVerticalLine()
                                          : const SizedBox(),
                                    if (size.width > 1030)
                                      appareilList[index].a12 != 'null'
                                          ? MySizedBox(
                                              text: appareilList[index].a12)
                                          : const SizedBox(),
                                    if (size.width > 1030)
                                      appareilList[index].a12 != 'null'
                                          ? const MyVerticalLine()
                                          : const SizedBox(),
                                    if (size.width > 1110)
                                      appareilList[index].a13 != 'null'
                                          ? MySizedBox(
                                              text: appareilList[index].a13)
                                          : const SizedBox(),
                                    if (size.width > 1110)
                                      appareilList[index].a13 != 'null'
                                          ? const MyVerticalLine()
                                          : const SizedBox(),
                                    if (size.width > 1190)
                                      appareilList[index].a14 != 'null'
                                          ? MySizedBox(
                                              text: appareilList[index].a14)
                                          : const SizedBox(),
                                    if (size.width > 1190)
                                      appareilList[index].a14 != 'null'
                                          ? const MyVerticalLine()
                                          : const SizedBox(),
                                    if (size.width > 1270)
                                      appareilList[index].a15 != 'null'
                                          ? MySizedBox(
                                              text: appareilList[index].a15)
                                          : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
  }
}
