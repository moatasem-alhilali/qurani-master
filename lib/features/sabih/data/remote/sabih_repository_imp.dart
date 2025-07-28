// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:quran_app/core/server_failure/failure.dart';
import 'package:quran_app/features/sabih/data/database/database_sabih_service.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/model/subih_seed_model.dart';
import 'package:quran_app/features/sabih/data/request/subih_request.dart';
import 'package:quran_app/main.dart';

abstract class SabihRepository {
  Future<Either<LogicFailure, List<SubihModel>>> getSubih();
  Future<Either<LogicFailure, void>> addSubih(SubihRequest subih);
  Future<Either<LogicFailure, void>> updateSubih(SubihRequest subih);
  Future<Either<LogicFailure, void>> deleteSubih(SubihRequest subih);

  // Logs
  Future<Either<LogicFailure, void>> logSubihTap(int subihId);

  // Grouped stats
  Future<Either<LogicFailure, Map<int, int>>> getCountsGrouped({
    required DateTime from,
    required DateTime to,
  });

  // Summary
  Future<Either<LogicFailure, void>> upsertSummary(int subihId, DateTime date);
  Future<Either<LogicFailure, Map<int, int>>> getSummaryCounts({
    required DateTime from,
    required DateTime to,
  });

  // Unified action
  Future<Either<LogicFailure, void>> performSubihTap(int subihId);
}

class SabihRepositoryImpl implements SabihRepository {
  final DatabaseSabihService sabihService;
  SabihRepositoryImpl({required this.sabihService});

  @override
  Future<Either<LogicFailure, List<SubihModel>>> getSubih() async {
    try {
      logger.d('getSubih');
      await SubihSeeder.runIfNeeded();
      logger.d('getSubih after');
      final result = await DatabaseSabihService.getAllSubihItems();
      logger.d(result);
      return right(result);
    } catch (e) {
      logger.e(e);
      return left(LogicFailure(e.toString()));
    }
  }

  @override
  Future<Either<LogicFailure, void>> addSubih(SubihRequest request) async {
    try {
      await DatabaseSabihService.addSubihItem(request);
      return right(null);
    } catch (e) {
      return left(LogicFailure(e.toString()));
    }
  }

  @override
  Future<Either<LogicFailure, void>> updateSubih(SubihRequest request) async {
    try {
      await DatabaseSabihService.updateSubihItem(request.id!, request);
      return right(null);
    } catch (e) {
      return left(LogicFailure(e.toString()));
    }
  }

  @override
  Future<Either<LogicFailure, void>> deleteSubih(SubihRequest request) async {
    try {
      await DatabaseSabihService.deleteSubihItem(request);
      return right(null);
    } catch (e) {
      return left(LogicFailure(e.toString()));
    }
  }

  // ───────────── Logs ─────────────

  @override
  Future<Either<LogicFailure, void>> logSubihTap(int subihId) async {
    try {
      await DatabaseSabihService.logSubihTap(subihId);
      return right(null);
    } catch (e) {
      return left(LogicFailure(e.toString()));
    }
  }

  @override
  Future<Either<LogicFailure, Map<int, int>>> getCountsGrouped({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final result = await DatabaseSabihService.getCountsGrouped(
        from: from,
        to: to,
      );
      return right(result);
    } catch (e) {
      return left(LogicFailure(e.toString()));
    }
  }

  // ───────────── Summary ─────────────

  @override
  Future<Either<LogicFailure, void>> upsertSummary(
    int subihId,
    DateTime date,
  ) async {
    try {
      await DatabaseSabihService.upsertSummary(subihId, date);
      return right(null);
    } catch (e) {
      return left(LogicFailure(e.toString()));
    }
  }

  @override
  Future<Either<LogicFailure, Map<int, int>>> getSummaryCounts({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final result = await DatabaseSabihService.getSummaryCounts(
        from: from,
        to: to,
      );
      return right(result);
    } catch (e) {
      return left(LogicFailure(e.toString()));
    }
  }

  // ───────────── Unified Action ─────────────

  @override
  Future<Either<LogicFailure, void>> performSubihTap(int subihId) async {
    try {
      await DatabaseSabihService.performSubihTap(subihId);
      return right(null);
    } catch (e) {
      return left(LogicFailure(e.toString()));
    }
  }
}
