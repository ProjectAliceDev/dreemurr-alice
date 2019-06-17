//
//  Commands.swift
//  
//
//  Created by Marquis Kurt on 6/16/19.
//

import Foundation
import DreemurrCore
import Sword

public enum DreemurrCommands {
    case help
    case introduce
    case ping
    case qt
}

public class Alice: Dreemurr {
    public func toAliceCommand(input: String) throws -> DreemurrCommands {
        switch input {
        case "!help":
            return .help
        case "!introduce":
            return .introduce
        case "!ping":
            return .ping
        case "!qt":
            return .qt
        default:
            throw DreemurrError.invalidCommand
        }
    }
    
    public func parseCommand(command: DreemurrCommands, message: Message) {
        switch command {
        case .help:
            message.reply(with: self.showHelp(description: """
            **Base Commands**
            - !introduce - Displays information about this bot.
            - !help - Displays this information.
            - !ping - Ping the bot.

            **Bot Commands**
            - !qt - Tell the bot she's a Qt.
            """))
        case .introduce:
            message.reply(with: self.introduceSelf())
        case .ping:
            message.reply(with: "Pong.")
        case .qt:
            message.reply(with: "I niot qt!")
        }
    }
}
