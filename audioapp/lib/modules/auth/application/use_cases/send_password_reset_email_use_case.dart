import '../../../../core/application/use_case.dart';
import '../../domain/repositories/auth_repository.dart';

class SendPasswordResetEmailParams {
  const SendPasswordResetEmailParams({required this.email});

  final String email;
}

class SendPasswordResetEmailUseCase
    implements UseCase<void, SendPasswordResetEmailParams> {
  const SendPasswordResetEmailUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<void> call(SendPasswordResetEmailParams params) {
    return _repository.sendPasswordResetEmail(email: params.email);
  }
}
