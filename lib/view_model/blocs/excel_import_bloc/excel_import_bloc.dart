import 'dart:io';
import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firedart/firedart.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:sews_projet/model/models/models.dart';
import 'package:uuid/uuid.dart';

part 'excel_import_event.dart';
part 'excel_import_state.dart';

class ExcelImportBloc extends Bloc<ExcelImportEvent, ExcelImportState> {
  ExcelImportBloc() : super(ExcelImportInitial()) {
    on<ExcelImportEvent>((event, emit) async {
      if (event is ImportEvent) {
        try {
          emit(ExcelImportLoading());
          var pickedFile = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['xlsx'],
            allowMultiple: false,
          );

          if (pickedFile != null) {
            emit(ExcelImportLoading());
            CollectionReference sewsDatabase =
                Firestore.instance.collection('sewsDatabase');

            CollectionReference historique =
                Firestore.instance.collection('Historique');

            List<String> rowdetail = [];
            List<String> userdetail = [];
            int? col;
            if (pickedFile.files.isNotEmpty) {
              String path = pickedFile.files.single.path!;

              var bytes = await File(path).readAsBytes();
              Excel excel = await parseExcelFile(bytes);
              var nSerie = [];
              for (var table in excel.tables.keys) {
                for (final row in excel.tables[table]!.rows) {
                  col = row.length;
                }
              }

              //#############################
              int x = col! - 2;
              int c = 6;
              int index = 2;
              //################

              if (col >= 16) {
                emit(ExcelImportFailure(
                    errorMessage:
                        'le nombre de columns ne depasse pas 16 colomns'));
              } else {
                for (var table in excel.tables.keys) {
                  for (final row in excel.tables[table]!.rows) {
                    rowdetail.add(row.elementAt(0)!.value.toString());
                    userdetail.add(row.elementAt(1)!.value.toString());
                    col = row.length;
                  }
                  for (int i = 1; i < rowdetail.length; i++) {
                    sewsDatabase.document(rowdetail[i]).set(
                      {
                        'a00': 'All',
                        'a0': 'All',
                        'a1': rowdetail[i],
                        'a2': userdetail[i],
                        'a3': event.selectedSite,
                        'a4': event.selectedAppareil,
                        'a5': event.debutContratDate,
                        'a6': event.finContratDate,
                        'a7': 'null',
                        'a8': 'null',
                        'a9': 'null',
                        'a10': 'null',
                        'a11': 'null',
                        'a12': 'null',
                        'a13': 'null',
                        'a14': 'null',
                        'a15': 'null',
                        'a16': 'null',
                        'a17': 'null',
                        'a18': 'null',
                        'a19': 'null',
                        'a20': 'null',
                      },
                    );
                    nSerie.add(rowdetail[i]);
                  }

                  rowdetail.clear();
                  userdetail.clear();
                  int k = 7;
                  while ((x / 5) >= 1) {
                    for (int i = index; i <= c; i++) {
                      for (var row in excel.tables[table]!.rows) {
                        rowdetail.add(row.elementAt(i)!.value.toString());
                      }
                      for (int j = 1, c = 0; j < rowdetail.length; j++, c++) {
                        if (rowdetail[0].isNotEmpty &&
                            rowdetail[j].isNotEmpty) {
                          sewsDatabase.document(nSerie[c]).update(
                            {
                              'a${k.toString()}':
                                  '${rowdetail[0]} : ${rowdetail[j]}',
                            },
                          );
                        }
                      }
                      rowdetail.clear();
                      k++;
                    }
                    index += 5;
                    c += 5;
                    x -= 5;
                  }
                  if (x != 0) {
                    for (int i = index; i <= (index + x); i++) {
                      for (var row in excel.tables[table]!.rows) {
                        rowdetail.add(row.elementAt(i)!.value.toString());
                      }
                      for (int j = 1, c = 0; j < rowdetail.length; j++, c++) {
                        sewsDatabase.document(nSerie[c]).update(
                          {
                            'a${k.toString()}':
                                '${rowdetail[0]} : ${rowdetail[j]}',
                          },
                        );
                      }
                      rowdetail.clear();
                      k++;
                    }
                  }
                  var id = const Uuid().v4();
                  historique.document(id).set({
                    'Type': 'Importer par un fichier excel',
                    'userNom': event.userInfo.displayName,
                    'site': event.userInfo.site,
                    'poste': event.userInfo.poste,
                    'Nombre de pieces': nSerie.length,
                    'Date': DateTime.now(),
                    'Time':
                        DateFormat.jm().format(DateTime.now()).toLowerCase(),
                    'Icon': 'file.png',
                    'Id': id,
                  });
                  emit(ExcelImportSuccess());
                }
              }
            }
          }
        } catch (e) {
          emit(ExcelImportFailure(errorMessage: e.toString()));
        }
      }
    });
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
