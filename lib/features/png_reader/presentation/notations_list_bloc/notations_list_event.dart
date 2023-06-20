// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notations_list_bloc.dart';

abstract class NotationsListEvent extends Equatable {
  const NotationsListEvent();

  @override
  List<Object> get props => [];

  factory NotationsListEvent.clearSelected() => _ClearSelected();
}

class _SetSelected extends NotationsListEvent {
  final int index;

  const _SetSelected({
    required this.index,
  });

  @override
  List<Object> get props => [index];
}

class _ClearSelected extends NotationsListEvent {}
