import '../../../../core/application/use_case.dart';
import '../../domain/repositories/report_audit_repository.dart';

class LogTestResultViewUseCase implements UseCase<void, String> {
  const LogTestResultViewUseCase(this._repository);

  final ReportAuditRepository _repository;

  @override
  Future<void> call(String params) {
    return _repository.logTestResultView(params);
  }
}
