import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/presentation/screens/home_root.dart';

part 'navigation_event.dart';

part 'navigation_state.dart';

enum NavbarItem { home, addCar, search, profile, notAuth }

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationChangedState(NavbarItem.home, 0)) {
    on<ChangeNavigationEvent>((event, emit) {
      if (event.navbarItem == NavbarItem.notAuth) {
        emit(NavigationNotAuthState());

        return;
      }

      switch (event.navbarItem) {
        case NavbarItem.home:
          emit(NavigationChangedState(event.navbarItem, event.index));
          break;
        case NavbarItem.addCar:
          emit(NavigationChangedState(event.navbarItem, event.index, editDataArg: event.editDataArg));
          break;
        case NavbarItem.search:
          emit(NavigationChangedState(event.navbarItem, event.index));
          break;
        case NavbarItem.profile:
          emit(NavigationChangedState(event.navbarItem, event.index));
          break;

        default:
          emit(NavigationChangedState(NavbarItem.home, 0));
          break;
      }
    });
  }
}
