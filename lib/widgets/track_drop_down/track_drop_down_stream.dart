import 'package:flutter/material.dart';
import 'package:papertracker/models/track.dart';

import 'track_drop_down_row.dart';

class TrackDropDownStream extends StatelessWidget {
  TrackDropDownStream(
    this.stream, {
    @required this.currentTrack,
    this.hintText,
    this.defaultText,
    this.noneValue,
    this.onChangeCallback,
  });

  final stream;
  final Track currentTrack;
  final String hintText;
  final String defaultText;
  final String noneValue;
  final Function onChangeCallback;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<Track> tracks = [];
        final items = snapshot.data.documents;
        for (var item in items) {
          int no = item.data['no'];
          String name = item.data['name'];
          String currentPaper = item.data['currentPaper'];
          String nextPaper = item.data['nextPaper'];

          Track track = Track(
              no: no,
              name: name,
              currentPaper: currentPaper,
              nextPaper: nextPaper);

          tracks.add(track);
        }
        tracks.sort((a, b) => a.no - b.no);
        return TrackDropDownRow(
          currentTrack: currentTrack,
          tracks: tracks,
          hintText: hintText,
          defaultText: defaultText,
          onChangeCallback: onChangeCallback,
        );
      },
    );
  }
}
