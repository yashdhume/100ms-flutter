///Dart imports
library;

import 'dart:async';

///Package imports
import 'package:flutter/widgets.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class MeetingNavigationVisibilityController extends ChangeNotifier {
  bool showControls = true;
  bool autoHideControls = false;

  ///This variable stores whether the timer is active or not
  ///
  ///This is done to avoid multiple timers running at the same time
  bool _isTimerActive = false;

  late Timer timer;

  ///This method toggles the visibility of the buttons
  void toggleControlsVisibility(BuildContext context) {
    if (showControls) {
      if (context.read<MeetingStore>().isOverlayChatOpened) {
        context.read<MeetingStore>().toggleChatOverlay();
      }
      showControls = false;
      if (_isTimerActive) {
        cancelTimer();
      }
    } else {
      showControls = true;
      if (autoHideControls) {
        startTimerToHideButtons();
      }
    }
    notifyListeners();
  }

  void toggleAutoHideControls(BuildContext context) {
    autoHideControls = !autoHideControls;
    if (autoHideControls) {
      toggleControlsVisibility(context);
    } else {
      showControls = true;
      cancelTimer();
    }
    notifyListeners();
  }

  ///This method starts a timer for 5 seconds and then hides the buttons
  void startTimerToHideButtons() {
    _isTimerActive = true;
    timer = Timer(const Duration(seconds: 5), () {
      showControls = false;
      _isTimerActive = false;
      notifyListeners();
    });
  }

  void cancelTimer() {
    timer.cancel();
    _isTimerActive = false;
  }
}
