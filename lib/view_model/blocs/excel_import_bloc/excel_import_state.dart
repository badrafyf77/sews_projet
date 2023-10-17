part of 'excel_import_bloc.dart';

@immutable
abstract class ExcelImportState {}

class ExcelImportInitial extends ExcelImportState {}

class ExcelImportLoading extends ExcelImportState {}

class ExcelImportSuccess extends ExcelImportState {}

class ExcelImportFailure extends ExcelImportState {
  final String errorMessage;

  ExcelImportFailure({
    required this.errorMessage,
  });
}
