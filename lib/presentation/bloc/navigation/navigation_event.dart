part of 'navigation_bloc.dart';

abstract class NavigationEvent {}

class ChangeNavigationEvent extends NavigationEvent {
  ChangeNavigationEvent(
    this.navbarItem,
    this.index, {
    this.editDataArg,
  });

  final NavbarItem navbarItem;
  final int index;
  final EditDataArg? editDataArg;
}
