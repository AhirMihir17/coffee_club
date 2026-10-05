import '../../../../core/model/user_model.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileSuccess extends ProfileState {
  final int beanStamps;
  final AppUser? user;

  const ProfileSuccess({
    this.beanStamps = 4,
    this.user,
  });

  ProfileSuccess copyWith({
    int? beanStamps,
    AppUser? user,
  }) {
    return ProfileSuccess(
      beanStamps: beanStamps ?? this.beanStamps,
      user: user ?? this.user,
    );
  }
}

// Backward compatibility alias
typedef ProfileLoaded = ProfileSuccess;

class ProfileError extends ProfileState {
  final String errorMessage;

  const ProfileError(this.errorMessage);
}
