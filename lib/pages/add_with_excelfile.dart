import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:sews_projet/blocs/excel_import_bloc/excel_import_bloc.dart';
import 'package:sews_projet/components/button.dart';
import 'package:sews_projet/components/date_picker.dart';
import 'package:sews_projet/components/drop_down_field.dart';
import 'package:sews_projet/constants.dart';

import '../components/custom_appbar.dart';

class AddExcelFilePage extends StatefulWidget {
  const AddExcelFilePage({super.key});
  static String id = '/AddExcelFilePage';

  @override
  State<AddExcelFilePage> createState() => _AddExcelFilePageState();
}

class _AddExcelFilePageState extends State<AddExcelFilePage> {
  List<DateTime?> debutLocation = [
    DateTime.now(),
  ];
  List<DateTime?> finLocation = [
    DateTime.now(),
  ];

  bool isLoading = false;

  final List<String> siteItems = [
    'Site Ain Harouda',
    'Site Berrechid 1',
    'Site Berrechid 2',
    'Site Ain Sebaa',
  ];
  final List<String> appareilItems = [
    'Pc fixe',
    'Pc portable',
    'Ecran',
  ];

  String? selectedSite;
  String? selectedAppareil;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final config = CalendarDatePicker2WithActionButtonsConfig(
      selectedDayHighlightColor: kPrimaryColor,
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      firstDayOfWeek: 1,
      controlsHeight: 50,
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: const TextStyle(
        color: Colors.blueGrey,
        fontWeight: FontWeight.bold,
      ),
    );

    return BlocConsumer<ExcelImportBloc, ExcelImportState>(
      listener: (context, state) {
        if (state is ExcelImportLoading) {
          setState(() {
            isLoading = true;
          });
        }
        if (state is ExcelImportSuccess) {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              setState(() {
                isLoading = false;
              });
              myShowToast(context, 'Succes', Colors.green);
            },
          );
        }
        if (state is ExcelImportFailure) {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              setState(() {
                isLoading = false;
              });
              myShowToast(context, 'Erreur', Colors.red);
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                const CustomAppbar(
                  widget: SizedBox(),
                ),
                Row(
                  children: [
                    IconButton(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 50,
                      color: kPrimaryColor,
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'le Site',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            UnconstrainedBox(
                              child: SizedBox(
                                width: size.width * 0.55,
                                child: MyDropDownField(
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Veuillez choisir une option.';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      selectedSite = value;
                                    },
                                    items: siteItems,
                                    hintText: 'Selectionner le site'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'l\'appareil',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            UnconstrainedBox(
                              child: SizedBox(
                                width: size.width * 0.55,
                                child: MyDropDownField(
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Veuillez choisir une option.';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      selectedAppareil = value;
                                    },
                                    items: appareilItems,
                                    hintText: 'Selectionner l\'appareil'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'select Date début Location',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            UnconstrainedBox(
                              child: SizedBox(
                                width: size.width * 0.5,
                                child: MyDatePicker(
                                  onPressed: () async {
                                    final value =
                                        await showCalendarDatePicker2Dialog(
                                      context: context,
                                      config: config,
                                      dialogSize: const Size(325, 400),
                                      borderRadius: BorderRadius.circular(15),
                                      value: debutLocation,
                                    );
                                    if (value != null) {
                                      setState(() {
                                        debutLocation = value;
                                      });
                                    }
                                  },
                                  hintText: _getValueText(
                                    config.calendarType,
                                    debutLocation,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'select Date Fin Location',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            UnconstrainedBox(
                              child: SizedBox(
                                width: size.width * 0.5,
                                child: MyDatePicker(
                                    onPressed: () async {
                                      final value =
                                          await showCalendarDatePicker2Dialog(
                                        context: context,
                                        config: config,
                                        dialogSize: const Size(325, 400),
                                        borderRadius: BorderRadius.circular(15),
                                        value: finLocation,
                                      );
                                      if (value != null) {
                                        setState(() {
                                          finLocation = value;
                                        });
                                      }
                                    },
                                    hintText: _getValueText(
                                      config.calendarType,
                                      finLocation,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      MyButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<ExcelImportBloc>(context)
                                .add(ImportEvent(
                              selectedSite: selectedSite!,
                              selectedAppareil: selectedAppareil!,
                              debutContratDate: _getValueText(
                                config.calendarType,
                                debutLocation,
                              ),
                              finContratDate: _getValueText(
                                config.calendarType,
                                finLocation,
                              ),
                            ));
                          }
                        },
                        textButton: 'Importer Excel fichier',
                      ),
                      isLoading
                          ? const UnconstrainedBox(
                              child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    color: kPrimaryColor,
                                  )))
                          : const SizedBox(),
                      const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.warning,
                            color: Colors.red,
                            size: 50,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              '1- Assurez-vous que le numéro de série est en premier colonne, puis les utilisateurs sont en le deuxième',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Image.asset('assets/images/rule1.png')
                        ],
                      ),
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              '2- Assurez-vous de ne pas laisser une espace vide',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Image.asset('assets/images/rule2.png')
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    return valueText;
  }
}

Future<Excel> parseExcelFile(Uint8List bytes) async {
  final excel = Excel.decodeBytes(bytes);

  final sheet = excel.tables.keys.first;

  final columnData = <String>[];

  for (final row in excel.tables[sheet]!.rows) {
    final cellValue = row[0]?.value;
    if (cellValue != null) {
      columnData.add(cellValue.toString());
    }
  }

  return excel;
}
