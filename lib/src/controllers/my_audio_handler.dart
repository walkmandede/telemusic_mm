import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:telemusic_v2/src/models/music_playing_state.dart';
import 'dart:math';

import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';

late final MyAudioHandler audioHandler;

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  // Expose the streams
  MusicPlayingState musicPlayingState = MusicPlayingState(
    xLoading: ValueNotifier(false),
    currentMediaItem: ValueNotifier(null),
    currentPlaybackState: ValueNotifier(null),
    currentPlayerstate: ValueNotifier(null),
    duration: ValueNotifier(null),
    position: ValueNotifier(null),
    xPlayNext: ValueNotifier(false),
    xShuffle: ValueNotifier(false),
    queue: ValueNotifier([]),
    orginalList: ValueNotifier([]),
  );
  ApiRepo apiRepo = ApiRepo();

  MyAudioHandler() {
    // Listen for playback state and update the system notification
    _player.playbackEventStream.listen((event) {
      // musicPlayingState.currentPlaybackState.value =
      //     playbackStateFromPlayer(event);
      final newPlaybackState = PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          _player.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext,
        ],
        androidCompactActionIndices: [0, 1, 2],
        processingState: _mapProcessingState(event.processingState),
        playing: _player.playing,
        bufferedPosition: event.bufferedPosition,
        updatePosition:
            musicPlayingState.position.value ?? event.bufferedPosition,
        speed: _player.speed,
      );
      musicPlayingState.currentPlaybackState.value = newPlaybackState;

      playbackState.add(newPlaybackState);
    });

    // Listen for player state changes (e.g., media completion)
    _player.playerStateStream.listen((state) {
      musicPlayingState.currentPlayerstate.value = state;
      if (state.processingState == ProcessingState.completed) {
        callBackForMusicCompletion();
      }
    });
    _player.durationStream.listen(
      (event) {
        musicPlayingState.duration.value = event;
      },
    );
    _player.positionStream.listen(
      (position) {
        musicPlayingState.position.value = position;
        // callBackForMusicCompletion();
      },
    );
  }

  void callBackForMusicCompletion() async {
    try {
      // if (musicPlayingState.position.value!.inSeconds ==
      //     musicPlayingState.duration.value!.inSeconds) {

      // }
      final currentIndex = musicPlayingState.queue.value
          .indexOf(musicPlayingState.currentMediaItem.value!);
      final xLast = currentIndex == musicPlayingState.queue.value.length - 1;
      if (xLast) {
        //lastSong
        _player.stop();
      } else {
        final nextItem = musicPlayingState.queue.value[currentIndex + 1];
        mediaItem.add(nextItem);
        _playNextSong();
      }
    } catch (e) {
      superPrint(e);
    }
  }

  // Play all songs in order
  Future<void> playAllSongs(
      {required List<MediaItem> songs,
      required bool xNetworkSong,
      int index = 0}) async {
    musicPlayingState.orginalList.value = [...songs];
    if (musicPlayingState.xShuffle.value) {
      musicPlayingState.queue.value = [...List.from(songs)..shuffle(Random())];
    } else {
      musicPlayingState.queue.value = [...songs];
    }
    musicPlayingState.xPlayNext.value = true;
    musicPlayingState.currentMediaItem.value =
        musicPlayingState.queue.value[index];

    mediaItem.add(musicPlayingState.currentMediaItem.value);
    superPrint(musicPlayingState.queue.value.first.id);
    try {
      if (xNetworkSong) {
        await _player.setUrl(musicPlayingState.currentMediaItem.value!.id);
      } else {
        await _player.setFilePath(musicPlayingState.currentMediaItem.value!.id);
      }
      saveToHistory();

      await play();
    } catch (e) {
      superPrint(e);
    }
  }

  void saveToHistory() async {
    try {
      apiRepo.toggleHistory(
          musicId: musicPlayingState.currentMediaItem.value!.extras!["id"],
          xAdd: true);
    } catch (_) {}
  }

  Future<void> playDesiredSong(
      {required MediaItem mediaItem, required bool xNetworkSong}) async {
    try {
      // Check if the mediaItem is in the queue
      if (musicPlayingState.queue.value.contains(mediaItem)) {
        // Update the current media item to the desired one
        musicPlayingState.currentMediaItem.value = mediaItem;

        // Find the index of the desired song in the queue
        musicPlayingState.queue.value.indexOf(mediaItem);

        if (xNetworkSong) {
          await _player.setUrl(musicPlayingState.currentMediaItem.value!.id);
        } else {
          await _player
              .setFilePath(musicPlayingState.currentMediaItem.value!.id);
        }
        saveToHistory();

        await play();
      } else {
        debugPrint("The desired song is not in the queue.");
      }
    } catch (e) {
      superPrint(e);
    }
  }

  // Play the next song in the playlist
  Future<void> _playNextSong() async {
    final currentIndex = musicPlayingState.queue.value
        .indexOf(musicPlayingState.currentMediaItem.value!);

    if (currentIndex + 1 < musicPlayingState.queue.value.length) {
      final nextIndex = currentIndex + 1;
      await _player.setUrl(musicPlayingState.queue.value[nextIndex].id);
      saveToHistory();

      await play();
      musicPlayingState.currentMediaItem.value =
          musicPlayingState.queue.value[nextIndex];
    } else {
      await stop();
    }
  }

  Future<void> _playPreviousSong() async {
    final currentIndex = musicPlayingState.queue.value
        .indexOf(musicPlayingState.currentMediaItem.value!);
    if (currentIndex >= 1) {
      final prevIndex = currentIndex - 1;
      await _player.setUrl(musicPlayingState.queue.value[prevIndex].id);
      // _player.play();
      await play();
      musicPlayingState.currentMediaItem.value =
          musicPlayingState.queue.value[prevIndex];
    } else {}
  }

  Future<void> toggleShuffle() async {
    musicPlayingState.xShuffle.value = !musicPlayingState.xShuffle.value;
    List<MediaItem> newQueue = [];

    if (musicPlayingState.currentMediaItem.value == null) {
      return;
    }

    if (musicPlayingState.xShuffle.value) {
      //new Shuffle

      if (musicPlayingState.currentMediaItem.value != null) {
        newQueue.add(musicPlayingState.currentMediaItem.value!);
      }
      final restList = musicPlayingState.orginalList.value.where(
          (each) => each.id != musicPlayingState.currentMediaItem.value!.id);
      newQueue.addAll([...List.from(restList)..shuffle(Random())]);
    } else {
      //close shuffle
      newQueue.addAll(musicPlayingState.orginalList.value);
    }
    musicPlayingState.queue.value = [...newQueue];
  }

  Future<void> togglePlayPause() async {
    superPrint(musicPlayingState.currentPlayerstate.value);

    if (musicPlayingState.currentPlayerstate.value == null) {
      restartTheSong();
      return;
    }

    if (musicPlayingState.currentPlayerstate.value!.processingState ==
        ProcessingState.completed) {
      restartTheSong();
      return;
    }

    final xPlaying = musicPlayingState.currentPlayerstate.value!.playing;
    if (xPlaying) {
      //new Shuffle
      await pause();
    } else {
      //close shuffle
      await play();
    }
  }

  Future<void> changePosition(double percentage) async {
    if (percentage < 0 || percentage > 1) {
      throw ArgumentError('Percentage must be between 0 and 1');
    }

    final duration = _player.duration;
    if (duration != null) {
      final targetPosition = duration * percentage;
      await _player.seek(targetPosition);
      musicPlayingState.position.value = targetPosition;
    } else {
      debugPrint("Duration is null, cannot change position.");
    }
  }

  bool xHasPrevSongs() {
    try {
      final list = musicPlayingState.queue.value;
      final current = musicPlayingState.currentMediaItem.value;

      if (list.indexOf(current!) > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  bool xHasNextSong() {
    try {
      final list = musicPlayingState.queue.value;
      final current = musicPlayingState.currentMediaItem.value;

      if (list.indexOf(current!) < list.length - 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Map `just_audio`'s ProcessingState to `audio_service`'s AudioProcessingState
  AudioProcessingState _mapProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        return AudioProcessingState.idle;
    }
  }

  void restartTheSong() async {
    pause();
    changePosition(0.001);
    play();
  }

  @override
  Future<void> play() async {
    _player.play();
    if (_player.playing) {
      // Show a notification when the audio is playing
      AudioServiceBackground.setState(
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.pause,
          MediaControl.skipToNext,
        ],
        playing: true,
        processingState: AudioProcessingState.ready,
        position: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      );
    }
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    musicPlayingState.reset();
  }

  @override
  Future<void> seek(Duration position) async {
    superPrint("seeked");
    _player.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    superPrint("skipped");
    final currentIndex = musicPlayingState.queue.value
        .indexOf(musicPlayingState.currentMediaItem.value!);
    if (currentIndex + 1 < musicPlayingState.queue.value.length) {
      mediaItem.add(musicPlayingState.queue.value[currentIndex + 1]);
      await _playNextSong();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    final currentIndex = musicPlayingState.queue.value
        .indexOf(musicPlayingState.currentMediaItem.value!);
    if (currentIndex - 1 >= 0) {
      mediaItem.add(musicPlayingState.queue.value[currentIndex - 1]);
      await _playPreviousSong();
    }
  }

  void dispose() {}

  void closePlayer() {
    musicPlayingState.reset();
    stop();
  }
}
