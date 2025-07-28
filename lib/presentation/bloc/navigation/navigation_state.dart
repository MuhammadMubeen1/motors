part of 'navigation_bloc.dart';

abstract class NavigationState {}

class InitialNavigationState extends NavigationState {}

class NavigationChangedState extends NavigationState {
  NavigationChangedState(
    this.navbarItem,
    this.index, {
    this.editDataArg,
  });

  final NavbarItem navbarItem;
  final int index;
  final EditDataArg? editDataArg;
}

class NavigationNotAuthState extends NavigationState {}
