///Package imports
library;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class ItsyGridLayout extends StatefulWidget {
  final List<PeerTrackNode> peerTracks;

  const ItsyGridLayout({super.key, required this.peerTracks});

  @override
  State<ItsyGridLayout> createState() => _ItsyGridLayoutState();
}

class _ItsyGridLayoutState extends State<ItsyGridLayout> {
  late String mainPeer;

  @override
  void initState() {
    mainPeer = widget.peerTracks
            .firstWhereOrNull((e) => e.peer.role.name == 'host')
            ?.uid ??
        widget.peerTracks[0].uid;
    super.initState();
  }

  List<PeerTrackNode> _getPeerList() {
    return widget.peerTracks.where((e) => e.uid != mainPeer).toList();
  }

  PeerTrackNode getMainPeer() {
    return widget.peerTracks.firstWhere((e) => e.uid == mainPeer);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListenablePeerWidget(
          peerTracks: [getMainPeer()],
          index: 0,
        ),
        Positioned(
          top: 50,
          bottom: 0,
          left: MediaQuery.of(context).size.width / 1.4,
          right: 0,
          child: ListView(
            children: _getPeerList()
                .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: 150,
                      width: 150,
                      color: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                          onDoubleTap: () {
                            mainPeer = e.uid;
                            setState(() {});
                          },
                          child: ListenablePeerWidget(
                            peerTracks: _getPeerList(),
                            index: _getPeerList().indexOf(e),
                            scaleType: ScaleType.SCALE_ASPECT_FIT,
                          ),
                        ),
                      ),
                    )))
                .toList(),
          ),
        )
      ],
    );
  }
}
