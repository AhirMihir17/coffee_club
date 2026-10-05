abstract class NavigationState {
  final int selectedIndex;

  const NavigationState([this.selectedIndex = 0]);
}

class NavigationInitial extends NavigationState {
  const NavigationInitial([super.selectedIndex = 0]);
}

class NavigationLoading extends NavigationState {
  const NavigationLoading([super.selectedIndex = 0]);
}

class NavigationSuccess extends NavigationState {
  const NavigationSuccess(super.selectedIndex);
}

// Backward-compatibility alias
typedef NavigationTabChanged = NavigationSuccess;

class NavigationError extends NavigationState {
  final String errorMessage;

  const NavigationError(this.errorMessage, [super.selectedIndex = 0]);
}
