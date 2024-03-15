///Dart imports
library;

import 'dart:io';

///Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/enums/meeting_mode.dart';
import 'package:hms_room_kit/src/meeting/meeting_navigation_visibility_controller.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/meeting_modes/custom_one_to_one_grid.dart';
import 'package:hms_room_kit/src/widgets/meeting_modes/one_to_one_mode.dart';

///[MeetingGridComponent] is a component that is used to show the video grid
class MeetingGridComponent extends StatelessWidget {
  final MeetingNavigationVisibilityController? visibilityController;

  const MeetingGridComponent({super.key, required this.visibilityController});

  @override
  Widget build(BuildContext context) {
    return Selector<
            MeetingStore,
            Tuple7<List<PeerTrackNode>, bool, int, int, MeetingMode,
                PeerTrackNode?, int>>(
        selector: (_, meetingStore) => Tuple7(
            meetingStore.peerTracks,
            meetingStore.isHLSLink,
            meetingStore.peerTracks.length,
            meetingStore.screenShareCount,
            meetingStore.meetingMode,
            meetingStore.peerTracks.isNotEmpty
                ? meetingStore.peerTracks[meetingStore.screenShareCount]
                : null,
            meetingStore.viewControllers.length),
        builder: (_, data, __) {
          if (data.item3 == 0 || data.item7 == 0) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          context.read<MeetingStore>().leave();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back)),
                  ],
                ),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'packages/hms_room_kit/lib/src/assets/icons/waiting.json',
                      height: 250,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (context.read<MeetingStore>().peers.isNotEmpty)
                      HMSTitleText(
                          text: "Please wait for broadcaster to join",
                          textColor: HMSThemeColors.onSurfaceHighEmphasis),
                  ],
                ),
                const Spacer()
              ],
            );
          }
          return Selector<MeetingStore, Tuple2<MeetingMode, HMSPeer?>>(
              selector: (_, meetingStore) =>
                  Tuple2(meetingStore.meetingMode, meetingStore.localPeer),
              builder: (_, modeData, __) {
                ///This renders the video grid based on whether the controls are visible or not
                return Selector<MeetingNavigationVisibilityController, bool>(
                    selector: (_, meetingNavigationVisibilityController) =>
                        meetingNavigationVisibilityController.showControls,
                    builder: (_, showControls, __) {
                      return Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),

                          ///If the controls are visible we reduce the
                          ///height of video grid by 140 else it covers the whole screen
                          ///
                          ///Here we also check for the platform and reduce the height accordingly
                          padding: EdgeInsets.symmetric(
                              vertical: showControls ? 70 : 0),
                          child: GestureDetector(
                            onTap: () => visibilityController
                                ?.toggleControlsVisibility(),
                            child: (modeData.item1 ==
                                        MeetingMode.activeSpeakerWithInset &&
                                    (context
                                                .read<MeetingStore>()
                                                .localPeer
                                                ?.audioTrack !=
                                            null ||
                                        context
                                                .read<MeetingStore>()
                                                .localPeer
                                                ?.videoTrack !=
                                            null))
                                ? OneToOneMode(
                                    ///This is done to keep the inset tile
                                    ///at correct position when controls are hidden
                                    bottomMargin: showControls ? 250 : 130,
                                    peerTracks: data.item1,
                                    screenShareCount: data.item4,
                                    context: context,
                                  )
                                : CustomOneToOneGrid(
                                    isLocalInsetPresent: false,
                                    peerTracks: data.item1,
                                  ),
                          ),
                        ),
                      );
                    });
              });
        });
  }
}
