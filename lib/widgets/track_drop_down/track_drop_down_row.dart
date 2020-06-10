import 'package:flutter/material.dart';
import 'package:papertracker/models/track.dart';

class TrackDropDownRow extends StatelessWidget {
  TrackDropDownRow({
    @required this.currentTrack,
    @required this.tracks,
    this.hintText,
    this.defaultText,
    this.onChangeCallback,
  });

  final Track currentTrack;
  final List<Track> tracks;
  final String hintText;
  final String defaultText;
  final Function onChangeCallback;

  DropdownMenuItem _buildDropDownMenuItem(Track track) {
    return DropdownMenuItem(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${track.no}.'),
          Flexible(
            child: Text(
              track.name ?? 'No name',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      value: track,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: true,
      hint: tracks.length > 0 ? Text(hintText ?? '') : Text(defaultText ?? ''),
      value: tracks.contains(currentTrack) ? currentTrack : null,
      items: tracks.map(_buildDropDownMenuItem).toList(),
      onChanged: (track) {
        onChangeCallback(track);
      },
    );
  }
}
