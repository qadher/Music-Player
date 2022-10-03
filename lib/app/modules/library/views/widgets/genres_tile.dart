import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../../../core/values/colors.dart';
import '../../../../widgets/mini_playbutton.dart';
import '../../../album_screen/views/album_screen_view.dart';
import '../../controllers/library_controller.dart';
import '../../../player_screen/controllers/player_controller.dart';

class GenreTile extends StatelessWidget {
  const GenreTile({Key? key, required this.genre}) : super(key: key);
  final GenreModel genre;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (contxt) => AlbumScreenView(
                  AudiosFromType.GENRE_ID, genre.id, genre.genre)));
        },
        child: GridTile(
          footer: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        const Color(0x00ffffff)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: GridTileBar(
                    backgroundColor: const Color(0x11000000),
                    title: Text(genre.genre),
                    subtitle: Text(
                      '${genre.numOfSongs} Songs',
                      style: TextStyle(
                          fontSize: 12, color: Colors.white.withOpacity(0.5)),
                    ),
                    trailing: MiniPlayButton(
                      onPress: () async {
                        final songs = await Get.find<LibraryController>()
                            .audioQuery
                            .queryAudiosFrom(AudiosFromType.GENRE_ID, genre.id);
                        Get.find<PlayerController>().playSongs(songs);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          child: QueryArtworkWidget(
            id: genre.id,
            type: ArtworkType.ALBUM,
            artworkFit: BoxFit.cover,
            artworkBorder: BorderRadius.circular(0),
            nullArtworkWidget: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.only(top: 45),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0x22ffffff)),
                borderRadius: BorderRadius.circular(10),
                color: const Color(0x22000000),
              ),
              child: const Icon(
                Icons.music_note,
                color: MyColors.secondary,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
