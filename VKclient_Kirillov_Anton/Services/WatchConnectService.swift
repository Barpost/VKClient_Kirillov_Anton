//
//  WatchConnectService.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 06.12.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation
import WatchConnectivity


class ConnectivityHandler : NSObject {

    var session = WCSession.default

    override init() {
        super.init()

        session.delegate = self
        session.activate()

        print("Paired Watch: \(session.isPaired), Watch App Installed: \(session.isWatchAppInstalled)")
    }
}


extension ConnectivityHandler : WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive: \(session)")
    }


    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate: \(session)")
    }

    func sessionWatchStateDidChange(_ session: WCSession) {
        print("sessionWatchStateDidChange: \(session)")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("didReceiveMessage: \(message)")
        if message["request"] as? String == "date" {
            replyHandler(["date" : "че кого?"])
        }
    }
}

