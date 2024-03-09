///Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/enums/join_type.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/hmssdk_interactor.dart';
import 'package:hms_room_kit/src/preview/preview_page.dart';
import 'package:hms_room_kit/src/preview/preview_permissions.dart';
import 'package:hms_room_kit/src/preview/preview_store.dart';

///[ScreenController] is the controller for the preview screen
///It takes following parameters:
///[roomCode] is the room code of the room to join
///[options] is the options for the prebuilt
///For more details checkout the [HMSPrebuiltOptions] class
class ScreenController extends StatefulWidget {
  ///[roomCode] is the room code of the room to join
  final String? roomCode;
  final String? token;
  final JoinType joinType;

  ///[options] is the options for the prebuilt
  ///For more details checkout the [HMSPrebuiltOptions] class
  final HMSPrebuiltOptions? options;

  ///The callback for the leave room button
  ///This function can be passed if you wish to perform some specific actions
  ///in addition to leaving the room when the leave room button is pressed
  final Function? onLeave;
  final Function? onRoomEnd;

  const ScreenController(
      {super.key,
      required this.roomCode,
      this.options,
      this.onLeave,
      this.onRoomEnd})
      : token = null,
        joinType = JoinType.code;
  const ScreenController.token(
      {super.key,
      required this.token,
      this.options,
      this.onLeave,
      this.onRoomEnd})
      : roomCode = null,
        joinType = JoinType.token;
  @override
  State<ScreenController> createState() => _ScreenControllerState();
}

class _ScreenControllerState extends State<ScreenController> {
  bool isPermissionGranted = false;
  late HMSSDKInteractor _hmsSDKInteractor;
  late PreviewStore _previewStore;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    ///Setting the prebuilt options and roomCode
    Constant.prebuiltOptions = widget.options;
    Constant.roomCode = widget.roomCode ?? "";
    Constant.token = widget.token ?? "";
    Constant.joinType = widget.joinType;
    Constant.onLeave = widget.onLeave;
    Constant.onRoomEnd = widget.onRoomEnd;

    ///Here we set the endPoints if it's non-null
    if (widget.options?.endPoints != null) {
      _setEndPoints(widget.options!.endPoints!);
    } else {
      Constant.initEndPoint = null;
      Constant.tokenEndPoint = null;
      Constant.layoutAPIEndPoint = null;
    }
    _checkPermissions();
  }

  ///This function sets the end points for the app
  ///If the endPoints were set from the [HMSPrebuiltOptions]
  void _setEndPoints(Map<String, String> endPoints) {
    Constant.tokenEndPoint = (endPoints.containsKey(Constant.tokenEndPointKey))
        ? endPoints[Constant.tokenEndPointKey]
        : null;
    Constant.initEndPoint = (endPoints.containsKey(Constant.initEndPointKey))
        ? endPoints[Constant.initEndPointKey]
        : null;
    Constant.layoutAPIEndPoint =
        (endPoints.containsKey(Constant.layoutAPIEndPointKey))
            ? endPoints[Constant.layoutAPIEndPointKey]
            : null;
  }

  ///This function checks the permissions for the app
  void _checkPermissions() async {
    isPermissionGranted = await Utilities.checkPermissions();
    if (isPermissionGranted) {
      _initPreview();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  ///This function initializes the preview
  ///- Assign the _hmssdkInteractor an instance of HMSSDKInteractor
  ///- Build the HMSSDK
  ///- Initialize PreviewStore
  ///- Start the preview
  ///  - If preview fails then we show the error dialog
  ///  - If successful we show the preview page
  void _initPreview() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    _hmsSDKInteractor = HMSSDKInteractor(
        iOSScreenshareConfig: widget.options?.iOSScreenshareConfig,
        joinWithMutedAudio: true,
        joinWithMutedVideo: true,
        isSoftwareDecoderDisabled: AppDebugConfig.isSoftwareDecoderDisabled,
        isAudioMixerDisabled: AppDebugConfig.isAudioMixerDisabled,
        isPrebuilt: true);
    await _hmsSDKInteractor.build();
    _previewStore = PreviewStore(hmsSDKInteractor: _hmsSDKInteractor);
    HMSException? ans = await _previewStore.startPreview(widget.joinType,
        userName: widget.options?.userName ?? "",
        roomCode: Constant.roomCode,
        token: Constant.token);

    ///If preview fails then we show the error dialog
    ///with the error message and description
    if (ans != null && mounted) {
      showGeneralDialog(
          context: context,
          pageBuilder: (_, data, __) {
            return UtilityComponents.showFailureError(ans, context,
                () => Navigator.of(context).popUntil((route) => route.isFirst));
          });
    } else {
      _hmsSDKInteractor.toggleAlwaysScreenOn();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      Constant.debugMode = AppDebugConfig.isDebugMode;
    }
  }

  ///This function is called when the permissions are granted
  ///This is called when user grants the permissions from PreviewPermissions widget
  ///Here we initialize the preview if the permissions are granted
  ///and set the [isPermissionGranted] to true
  void _isPermissionGrantedCallback() {
    _initPreview();
    setState(() {
      isPermissionGranted = true;
    });
  }

  PreviewPage _getPreviewPage() {
    switch (widget.joinType) {
      case JoinType.code:
        return PreviewPage(
          roomCode: Constant.roomCode,
          name: widget.options?.userName?.trim() ?? "",
          options: widget.options,
        );
      case JoinType.token:
        return PreviewPage.token(
          token: Constant.token,
          name: widget.options?.userName?.trim() ?? "",
          options: widget.options,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: HMSThemeColors.primaryDefault,
              ),
            )
          : isPermissionGranted
              ? ListenableProvider.value(
                  value: _previewStore,
                  child: _getPreviewPage(),
                )
              : PreviewPermissions(
                  options: widget.options,
                  callback: _isPermissionGrantedCallback),
    );
  }
}
