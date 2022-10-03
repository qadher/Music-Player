import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:on_audio_query/on_audio_query.dart';

import '../../../data/models/playlist.dart';
import '../../../widgets/dialog_input.dart';
import '../widgets/playlist_tile.dart';

class PlaylistHelper {
  static Box<Playlist> box = Hive.box('Playlist');

  createPlaylist(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return InputDialog(
            title: 'Create Playlist',
            confirmText: 'Create',
            autofocus: true,
            onConform: (name) {
              if (_playlistExist(name)) {
                Fluttertoast.showToast(
                    msg: 'Playlist Already Exist',
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.red.withOpacity(0.8));
                return;
              }
              box.add(Playlist(name: name));
              Navigator.pop(context);
            },
          );
        });
  }

  renamePlaylist(BuildContext context, Playlist playlist) {
    showDialog(
        context: context,
        builder: (context) {
          return InputDialog(
            title: 'Rename Playlist',
            initialValue: playlist.name,
            autofocus: true,
            confirmText: 'Rename',
            onConform: (name) {
              if (_playlistExist(name)) {
                Fluttertoast.showToast(
                    msg: 'Playlist Already Exist',
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.red.withOpacity(0.8));
                return;
              }
              playlist.name = name;
              playlist.save();
              Navigator.pop(context);
            },
          );
        });
  }

  showPlayistaddBottomSheet(SongModel song) {
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.2,
              maxChildSize: 0.75,
              builder: (context, scrollController) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25)),
                              color: Color(0x22ffffff)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.remove),
                              ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                leading: const Icon(Icons.add),
                                title: const Text(
                                  'Create Playlist',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                onTap: () {
                                  createPlaylist(context);
                                },
                              ),
                              Expanded(
                                child: ValueListenableBuilder(
                                    valueListenable: box.listenable(),
                                    builder: (context, Box<Playlist> box, _) {
                                      List<Playlist> playlists =
                                          box.values.toList();
                                      return ListView.builder(
                                        controller: scrollController,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: playlists.length,
                                        itemBuilder: (context, index) {
                                          return PlaylistTile(
                                            playlist: playlists[index],
                                            showMenu: false,
                                            onTap: () {
                                              if (playlists[index]
                                                  .addSong(song)) {
                                                Navigator.pop(context);
                                                Fluttertoast.showToast(
                                                  msg:
                                                      'Added to ${playlists[index].name}',
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: 'Song Already Exist',
                                                    backgroundColor: Colors.red
                                                        .withOpacity(0.8));
                                              }
                                            },
                                          );
                                        },
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                      )),
                );
              },
            ),
          );
        });
  }

  bool _playlistExist(String playlistName) {
    final playlists = box.values.toList();
    for (Playlist playlist in playlists) {
      if (playlistName == playlist.name) {
        return true;
      }
    }
    return false;
  }
}
