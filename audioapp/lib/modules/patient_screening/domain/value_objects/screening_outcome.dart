enum ScreeningOutcome { pass, borderline, refer, incomplete }

extension ScreeningOutcomeValue on ScreeningOutcome {
  String get storageValue {
    switch (this) {
      case ScreeningOutcome.pass:
        return 'pass';
      case ScreeningOutcome.borderline:
        return 'borderline';
      case ScreeningOutcome.refer:
        return 'refer';
      case ScreeningOutcome.incomplete:
        return 'incomplete';
    }
  }
}
