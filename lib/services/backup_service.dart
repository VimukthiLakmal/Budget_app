import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class BackupService {
  // Get the authenticated Google Drive API client
  static Future<drive.DriveApi?> _getDriveApi() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.file']);
    final GoogleSignInAccount? account = await googleSignIn.signIn();

    if (account == null) {
      return null; // User not signed in
    }

    final authHeaders = await account.authHeaders; // Await the future to get the actual authHeaders
    final client = authenticatedClient(
      http.Client(),
      AccessCredentials(
        AccessToken('Bearer', authHeaders['access_token']!, DateTime.now().add(Duration(hours: 1))),
        null,
        ['https://www.googleapis.com/auth/drive.file'],
      ),
    );

    return drive.DriveApi(client);
  }

  // Backup the Hive file to Google Drive
  static Future<void> backupToGoogleDrive() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/transactions.hive');

    if (!file.existsSync()) return;

    final driveFile = drive.File();
    driveFile.name = "transactions_backup.hive";

    final response = await driveApi.files.create(
      driveFile,
      uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
    );

    print('Backup Uploaded: ${response.id}');
  }

  // Restore the Hive file from Google Drive
  static Future<bool> restoreFromGoogleDrive() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) return false;

    final files = await driveApi.files.list(q: "name='transactions_backup.hive'");
    if (files.files!.isEmpty) return false;

    final fileId = files.files!.first.id!;
    final response = await driveApi.files.get(fileId, downloadOptions: drive.DownloadOptions.fullMedia);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/transactions.hive');

    final List<int> dataStore = [];
    await for (var data in (response as drive.Media).stream) {  // Cast response to drive.Media
      dataStore.addAll(data);
    }

    file.writeAsBytesSync(dataStore);
    print('Backup Restored');
    return true;
  }
}