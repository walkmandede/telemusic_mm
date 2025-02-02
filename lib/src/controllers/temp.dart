import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:telemusic_v2/src/models/music_playing_state.dart';
import 'dart:math';

import 'package:telemusic_v2/utils/constants/app_functions.dart';

late final MyAudioHandler audioHandler;

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  List<MediaItem> _playlist = [];
  int _currentSongIndex = 0;

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

  MyAudioHandler() {
    // Listen for playback state and update the system notification
    _player.playbackEventStream.listen((event) {
      // musicPlayingState.currentPlaybackState.value =
      //     playbackStateFromPlayer(event);
      // playbackState.add(playbackStateFromPlayer(event));
    });

    // Listen for player state changes (e.g., media completion)
    _player.playerStateStream.listen((state) {
      musicPlayingState.currentPlayerstate.value = state;
      if (state.processingState == ProcessingState.completed) {
        _currentSongIndex++;
        if (_currentSongIndex < _playlist.length) {
          mediaItem.add(_playlist[_currentSongIndex]);
          _playNextSong();
        } else {
          _player.stop();
        }
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
      },
    );
  }

  // Map `AudioPlaybackEvent` to `PlaybackState`
  // PlaybackState playbackStateFromPlayer(PlaybackEvent event) {
  //   return PlaybackState(
  //     controls: [
  //       MediaControl.skipToPrevious,
  //       _player.playing ? MediaControl.pause : MediaControl.play,
  //       MediaControl.skipToNext,
  //     ],
  //     androidCompactActionIndices: [0, 1, 2],
  //     processingState: _mapProcessingState(_player.processingState),
  //     playing: _player.playing,
  //     bufferedPosition: _player.bufferedPosition,
  //     speed: _player.speed,
  //   );
  // }

  // Play a single song
  Future<void> playSingleSong({required MediaItem song}) async {
    musicPlayingState.xLoading.value = true;
    _currentSongIndex = 0;
    _playlist = [song]; // Reset playlist to a single song
    mediaItem.add(song);
    await _player.setUrl(song.id);
    _player.play();
    musicPlayingState.queue.value = [song];
    musicPlayingState.xLoading.value = false;
    musicPlayingState.xShuffle.value = false;
    musicPlayingState.xPlayNext.value = false;
    musicPlayingState.currentMediaItem.value = song;
  }

  // Play all songs in order
  Future<void> playAllSongs({required List<MediaItem> songs}) async {
    _playlist = [...songs];
    _currentSongIndex = 0;
    mediaItem.add(_playlist[_currentSongIndex]);
    musicPlayingState.xShuffle.value = false;
    musicPlayingState.xPlayNext.value = true;
    musicPlayingState.currentMediaItem.value = _playlist[_currentSongIndex];
    musicPlayingState.orginalList.value = [..._playlist];
    musicPlayingState.queue.value = [..._playlist];
    await _playNextSong();
  }

  // Play all songs in shuffle
  // Future<void> playAllSongsInShuffle({required List<MediaItem> songs}) async {
  //   _playlist = [...List.from(songs)..shuffle(Random())];
  //   _currentSongIndex = 0;
  //   mediaItem.add(_playlist[_currentSongIndex]);
  //   musicPlayingState.xShuffle.value = true;
  //   musicPlayingState.xPlayNext.value = true;
  //   musicPlayingState.currentMediaItem.value = _playlist[_currentSongIndex];
  //   musicPlayingState.queue.value = [..._playlist];
  //   await _playNextSong();
  // }

  // Play the next song in the playlist
  Future<void> _playNextSong() async {
    if (_currentSongIndex < _playlist.length) {
      await _player.setUrl(_playlist[_currentSongIndex].id);
      _player.play();
      musicPlayingState.currentMediaItem.value = _playlist[_currentSongIndex];
    } else {
      await stop();
    }
  }

  Future<void> toggleShuffle() async {
    musicPlayingState.xShuffle.value = !musicPlayingState.xShuffle.value;
    List<MediaItem> newQueue = [];

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
    _playlist = [...newQueue];
    musicPlayingState.queue.value = [..._playlist];
  }

  Future<void> togglePlayPause() async {
    superPrint(musicPlayingState.currentPlayerstate.value);

    if (musicPlayingState.currentPlayerstate.value == null) {
      restartTheSong();
      return;
    }

    if (musicPlayingState.currentPlayerstate.value!.processingState ==
        ProcessingState.idle) {
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
      final list = musicPlayingState.queue.value ?? [];
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
      final list = musicPlayingState.queue.value ?? [];
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
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    musicPlayingState.reset();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() async {
    if (_currentSongIndex + 1 < _playlist.length) {
      _currentSongIndex++;
      mediaItem.add(_playlist[_currentSongIndex]);
      await _playNextSong();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (_currentSongIndex - 1 >= 0) {
      _currentSongIndex--;
      mediaItem.add(_playlist[_currentSongIndex]);
      await _playNextSong();
    }
  }

  void dispose() {}
}
