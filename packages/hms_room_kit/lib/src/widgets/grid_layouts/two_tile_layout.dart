///Package imports
library;

import 'package:flutter/cupertino.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

///This widget renders two tiles on a page
///The two tiles are rendered in a 2x1 grid
///The tiles look like this
/// ┌─────┐
/// │  0  │
/// ├─────┤
/// │  1  │
/// └─────┘
class TwoTileLayout extends StatelessWidget {
  final int startIndex;
  final List<PeerTrackNode> peerTracks;

  const TwoTileLayout(
      {super.key, required this.peerTracks, required this.startIndex});

  @override
  Widget build(BuildContext context) {
    ///Here we render two rows with one tile in each row
    ///The first row contains the tile with index [startIndex]
    ///The second row contains the tile with index [startIndex+1]
    return Column(
      children: [
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListenablePeerWidget(
                    index: startIndex, peerTracks: peerTracks),
              ),
              const SizedBox(
                width: 2,
              ),
              Expanded(
                child: ListenablePeerWidget(
                    index: startIndex + 1, peerTracks: peerTracks),
              ),
            ],
          ),
        ),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }
}
