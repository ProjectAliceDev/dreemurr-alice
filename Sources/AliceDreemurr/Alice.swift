//
//  Alice.swift
//  dreemurr-alice
//
//  Created by Marquis Kurt on 6/16/19.
//  (C) 2019 Project Alice. All rights reserved.
//

import Foundation
import DreemurrCore
import Sword

// Override the existing DreemurrCommands to add new commands
public enum DreemurrCommands {
    case help
    case introduce
    case ping
    case qt
    case aboutme
    case asriel
}

/**
    Base class for Alice Angel bot. Inherits from `Dreemurr` class.
 */
public class Alice: Dreemurr {
    
    /**
        Tokenize the command to a valid one.
        - parameter input: The input to tokenize
        - returns: The tokenized command as a `DreemurrCommands` enumeration.
        - throws: Throws `DreemurrError.invalidCommand` when finding an invalid command.
     */
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
        case "!aboutme":
            return .aboutme
        case "!asriel":
            return .asriel
        default:
            throw DreemurrError.invalidCommand
        }
    }
    
    /**
        Gets a random ping message.
     */
    public func getPingMessage() -> String {
        let possibleEntries = [
            "I would appreciate if you did not.",
            "I'm a bot! Congratulations.",
            "What, do you think I'm going to say 'Pong' to that?",
            "Please don't.",
            "I'm busy right now."
        ]
        return possibleEntries.randomElement() ?? "Pong."
    }
    
    /**
        Gets a random response when the command `!qt` is run.
     */
    public func getQtMessage() -> String {
        let possibleEntries = [
            "As your chief, I command you to stop doing that.",
            "Flattering, but knock it off.",
            "Do you think it's funny to call me a Qt?",
            "You aren't entertaining anyone with that."
        ]
        return possibleEntries.randomElement() ?? "I niot qt!"
    }
    
    public func getRelease(of: String) {
        
    }
    
    /**
        Runs a command based off of a token.
        - parameter command: The token to run as a command.
        - parameter message: The message to act on.
        - throws: Throws `DreemurrError.invalidCommand` when running into an invalid command.
     */
    public func parseCommand(command: DreemurrCommands, message: Message) throws {
        switch command {
        case .help:
            message.reply(with: self.showHelp(description: """
            **Base Commands**
            - !introduce - Displays information about this bot.
            - !help - Displays this information.
            - !ping - Ping the bot.

            **Bot Commands**
            - !aboutme - Alias of '!introduce'.
            - !qt - Tell the bot she's a Qt.
            """))
        case .introduce:
            message.reply(with: self.introduceSelf())
        case .ping:
            message.reply(with: getPingMessage())
        case .qt:
            message.addReaction("🚫")
            message.reply(with: getQtMessage())
        case .aboutme:
            message.reply(with: self.introduceSelf())
        case .asriel:
            throw DreemurrError.partialOrIncompleteSoul
        default:
            throw DreemurrError.invalidCommand
        }
    }
}
