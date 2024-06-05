import 'package:hmssdk_flutter/hmssdk_flutter.dart';

extension StringExtension on String {
  String get capitalize {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String get removeDash {
    return replaceAll("-", " ");
  }

  String get changeRoleIconPath {
    switch (this) {
      case "host":
        return "packages/hms_room_kit/lib/src/assets/icons/change_role_video.svg";
      case "co-host":
        return "packages/hms_room_kit/lib/src/assets/icons/change_role_video.svg";
      case "video":
        return "packages/hms_room_kit/lib/src/assets/icons/change_role_video.svg";
      case "voice":
        return "packages/hms_room_kit/lib/src/assets/icons/change_role_audio.svg";
      case "chat":
        return "packages/hms_room_kit/lib/src/assets/icons/change_role_chat.svg";
      case "spectator":
        return "packages/hms_room_kit/lib/src/assets/icons/change_role_chat.svg";
      default:
        return "packages/hms_room_kit/lib/src/assets/icons/change_role_chat.svg";
    }
  }
}

extension HMSRoleExt on HMSRole {
  String get iconPath {
    switch (name) {
      case "host":
        return "packages/hms_room_kit/lib/src/assets/icons/change_role_video.svg";
      case "co-host":
        return "packages/hms_room_kit/lib/src/assets/icons/change_role_video.svg";
      case "video":
        return "packages/hms_room_kit/lib/src/assets/icons/change_role_video.svg";
      case "voice":
        return "packages/hms_room_kit/lib/src/assets/icons/change_role_audio.svg";
      case "chat":
        return "packages/hms_room_kit/lib/src/assets/icons/change_role_chat.svg";
      case "spectator":
        return "packages/hms_room_kit/lib/src/assets/icons/change_role_chat.svg";
      default:
        return "packages/hms_room_kit/lib/src/assets/icons/change_role_chat.svg";
    }
  }
}
