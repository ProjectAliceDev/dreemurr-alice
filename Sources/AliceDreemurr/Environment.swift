//
//  Environment.swift
//  dreemurr-alice
//
//  Created by Marquis Kurt on 6/16/19.
//  (C) 2019 Project Alice. All rights reserved.
//

import Foundation
import Logging

public struct DreemurrVM {
    static var logger = Logger(label: "app.aliceos.dreemurr-alice.env")
    
    /**
        Get a token from the environment variables (`dreemurr.token`)
        - returns: (Optional) A string containing the token
     */
    public static func getToken() -> String? {
        if ProcessInfo.processInfo.environment["dreemurr.token"] != nil {
            self.logger.info("Environment variable token set!")
        } else {
            self.logger.warning("No token set in environment variables.")
        }
        return ProcessInfo.processInfo.environment["dreemurr.token"]
    }
    
    public static func getName() -> String? {
        return ProcessInfo.processInfo.environment["dreemurr.name"]
    }
}
