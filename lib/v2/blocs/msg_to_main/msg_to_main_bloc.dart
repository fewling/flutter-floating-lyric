import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'msg_to_main_event.dart';
part 'msg_to_main_state.dart';
part 'msg_to_main_bloc.freezed.dart';

class MsgToMainBloc extends Bloc<MsgToMainEvent, MsgToMainState> {
  MsgToMainBloc() : super(_Initial()) {
    on<MsgToMainEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
