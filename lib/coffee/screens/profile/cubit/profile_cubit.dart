import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/model/user_model.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({AppUser? user}) : super(const ProfileInitial()) {
    initProfile(user);
  }

  void initProfile(AppUser? user) {
    emit(const ProfileLoading());
    try {
      emit(ProfileSuccess(user: user, beanStamps: 4));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  ProfileSuccess get _currentSuccess {
    if (state is ProfileSuccess) {
      return state as ProfileSuccess;
    }
    return const ProfileSuccess();
  }

  void setUser(AppUser? user) {
    try {
      final current = _currentSuccess;
      emit(current.copyWith(user: user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void addStamp() {
    try {
      final current = _currentSuccess;
      final next = (current.beanStamps + 1) > 10 ? 1 : current.beanStamps + 1;
      emit(current.copyWith(beanStamps: next));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void resetStamps() {
    try {
      final current = _currentSuccess;
      emit(current.copyWith(beanStamps: 0));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
