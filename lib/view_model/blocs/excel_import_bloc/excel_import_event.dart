// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'excel_import_bloc.dart';

@immutable
abstract class ExcelImportEvent {}

class ImportEvent extends ExcelImportEvent {
  final String selectedSite;
  final String selectedAppareil;
  final String debutContratDate;
  final String finContratDate;

  ImportEvent({
    required this.selectedSite,
    required this.selectedAppareil,
    required this.debutContratDate,
    required this.finContratDate,
  });
}
