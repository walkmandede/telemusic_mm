import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telemusic_v2/src/models/music_download_model.dart';
import 'package:telemusic_v2/src/models/music_model.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/services/local_stroage/sp_keys.dart';

class AudioDownloader {
  static Future<String?> downloadAudio(
      {required MusicModel musicModel,
      required Function(int, int)? onReceivedProgress}) async {
    try {
      Dio dio = Dio();
      Directory? dir = await getApplicationDocumentsDirectory();

      // Create a subfolder inside the directory
      Directory subDir = Directory('${dir.path}/AudioDownloads');
      if (!subDir.existsSync()) {
        subDir.createSync(recursive: true); // Create folder if not exists
      }

      final fileName = musicModel.audioUrl.split("/").last;
      log(fileName);

      String filePath = '${subDir.path}/$fileName'; // Save inside subfolder
      await dio.download(musicModel.audioUrl, filePath,
          onReceiveProgress: onReceivedProgress);
      await saveRecord(
          musicDownloadModel: MusicDownloadModel(
              id: musicModel.id.toString(),
              title: musicModel.audioTitle,
              artists: musicModel.artistsName,
              downloadPath: filePath));
      return "filePath";
    } catch (e) {
      print("Download error: $e");
      return null;
    }
  }

  static Future<bool> saveRecord(
      {required MusicDownloadModel musicDownloadModel}) async {
    bool result = false;
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final list =
          sharedPreferences.getStringList(SpKeys.downloadedMusic) ?? [];
      list.add(musicDownloadModel.toJsonString());
      await sharedPreferences.setStringList(SpKeys.downloadedMusic, list);
      result = true;
    } catch (e) {
      superPrint(e);
    }
    return result;
  }

  static Future<bool> deleteDownloadedSong(String songId) async {
    try {
      // Step 1: Get SharedPreferences instance
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      // Step 2: Retrieve the list of downloaded songs
      List<String> downloadedSongs =
          sharedPreferences.getStringList(SpKeys.downloadedMusic) ?? [];

      // Step 3: Find the song to delete
      MusicDownloadModel? songToDelete;
      String? songJsonToRemove;
      for (String songJson in downloadedSongs) {
        MusicDownloadModel song =
            MusicDownloadModel.fromJson(jsonString: songJson);
        if (song.id == songId) {
          songToDelete = song;
          songJsonToRemove = songJson;
          break;
        }
      }

      if (songToDelete == null || songJsonToRemove == null) {
        // Song not found in SharedPreferences
        superPrint("Song not found in SharedPreferences");
        return false;
      }

      // Step 4: Delete the file from storage
      File file = File(songToDelete.downloadPath);
      if (await file.exists()) {
        await file.delete();
        superPrint("File deleted: ${songToDelete.downloadPath}");
      } else {
        superPrint("File not found: ${songToDelete.downloadPath}");
      }

      // Step 5: Remove the song from SharedPreferences
      downloadedSongs.remove(songJsonToRemove);
      await sharedPreferences.setStringList(
          SpKeys.downloadedMusic, downloadedSongs);

      superPrint("Song deleted successfully");
      return true;
    } catch (e) {
      superPrint("Error deleting song: $e");
      return false;
    }
  }
}
