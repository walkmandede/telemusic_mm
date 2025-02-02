import 'package:audio_service/audio_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayingState extends Equatable {
  final ValueNotifier<bool> xLoading;
  final ValueNotifier<bool> xPlayNext;
  final ValueNotifier<bool> xShuffle;
  final ValueNotifier<Duration?> duration;
  final ValueNotifier<Duration?> position;
  final ValueNotifier<MediaItem?> currentMediaItem;
  final ValueNotifier<PlaybackState?> currentPlaybackState;
  final ValueNotifier<PlayerState?> currentPlayerstate;
  final ValueNotifier<List<MediaItem>> orginalList;
  final ValueNotifier<List<MediaItem>> queue;

  const MusicPlayingState({
    required this.xLoading,
    required this.xPlayNext,
    required this.xShuffle,
    required this.duration,
    required this.position,
    required this.currentMediaItem,
    required this.currentPlaybackState,
    required this.currentPlayerstate,
    required this.orginalList,
    required this.queue,
  });

  @override
  List<Object?> get props => [];

  void reset() {
    xLoading.value = false;
    xPlayNext.value = false;
    xShuffle.value = false;
    duration.value = null;
    position.value = null;
    currentMediaItem.value = null;
    currentPlaybackState.value = null;
    currentPlayerstate.value = null;
    queue.value = [];
  }
}
