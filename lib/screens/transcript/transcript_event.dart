import 'package:equatable/equatable.dart';

abstract class TranscriptEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class DisplayLoading extends TranscriptEvent{

}
