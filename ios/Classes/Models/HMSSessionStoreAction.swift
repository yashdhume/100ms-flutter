//
//  HMSSessionStoreAction.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 25/04/23.
//

import Foundation
import HMSSDK

class HMSSessionStoreAction {

    static func sessionStoreActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ plugin: SwiftHmssdkFlutterPlugin) {

        switch call.method {
        case "get_session_metadata_for_key":
            getSessionMetadata(call, result, plugin)

        case "set_session_metadata_for_key":
            setSessionMetadata(call, result, plugin)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    static private func getSessionMetadata(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ plugin: SwiftHmssdkFlutterPlugin) {

        guard let store = plugin.sessionStore
        else {
            result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Session Store is null.")))
            return
        }

        guard let arguments = call.arguments as? [AnyHashable: Any],
            let key = arguments["key"] as? String
        else {
            result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Key to be fetched from Session Store is null.")))
            return
        }

        store.object(forKey: key) { value, error in

            if let error = error {
                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Error in fetching key: \(key) from Session Store. Error: \(error.localizedDescription)")))
            }

            guard let value = value
            else {
                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Error in fetching key: \(key) from Session Store due to an unknown error")))
                return
            }

            result(HMSResultExtension.toDictionary(true, value))
        }

    }

    static private func setSessionMetadata(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ plugin: SwiftHmssdkFlutterPlugin) {

    }
}
