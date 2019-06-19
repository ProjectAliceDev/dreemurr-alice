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
    case getrelease
    case cuddle
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
        case "!cuddle":
            return .cuddle
        case _ where input.starts(with: "!getrelease"):
            return .getrelease
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
    
    /**
     Gets a random ping message.
     */
    public func getCuddleMessage() -> String {
        let possibleEntries = [
            "I get it if that's your thing, but I'm not comfortable doing that.",
            "Don't you think I get enough cuddles from that fluffy monster already (unwillingly, mind you)?",
            "You're gonna weird Sayonika out by doing that.",
            "No.",
            "I'm not your girlfriend, you know.",
            "Stop that. You're making yourself look like a fool.",
            "I really don't wanna.",
            "Please. It's already tiring to have to deal with Sayonika and, uh, that guy, pulling that crap on me."
        ]
        return possibleEntries.randomElement() ?? "Please don't."
    }
    
    /**
        Create an embed containing the latest release of a GitHub repository from Project Alice.
        - parameter of: The full command that was executed
        - returns: An embed that contains the important information pertaining to a GitHub release (`Embed`)
     */
    public func getRelease(of: String) throws -> Embed {
        let args = self.asArguments(command: of, includeCommand: false)
        logger.info("Received arguments: \(args)")
        switch args.count {
        case 0: throw AliceError.missingArguments
        case 1:
            do {
                let release = try getLatestReleaseData(repo: args[0])
                if release != nil {
                    var releaseEmbed = Embed()
                    releaseEmbed.title = "Latest Release: \(release?.name ?? "Release Name")"
                    releaseEmbed.description = """
                    Release version: **\(release?.tag_name ?? "vX.X.X")**
                    
                    Details:
                    \(release?.body ?? "No description provided.")
                    """
                    releaseEmbed.url = release?.url
                    return releaseEmbed
                } else {
                    throw AliceError.releaseIsNil
                }
            } catch {
                throw AliceError.requestFailed
            }
        default: throw AliceError.argumentMismatch
        }
    }
    
    /**
        Makes an HTTP request to get GitHub release data and turn it into a `GithubRelease` struct.
        - parameter repo: The name of the repository to get.
     */
    public func getLatestReleaseData(repo: Substring) throws -> GithubRelease? {
        let request = URLRequest(url: NSURL(string: "https://api.github.com/repos/projectalicedev/\(repo)/releases/latest")! as URL)
        do {
            let response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
            let data = try NSURLConnection.sendSynchronousRequest(request, returning: response)
            
            let serializedJSON = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String : Any]
            
            let jsonString = """
            {
            \"name\": \"\(serializedJSON?["name"] ?? "Release Name")\",
            \"body\": \"\(serializedJSON?["body"] ?? "Release body")\",
            \"url\": \"\(serializedJSON?["html_url"] ?? "Release URL")\",
            \"tag_name\": \"\(serializedJSON?["tag_name"] ?? "Release Version")\",
            }
            """
            
            return GithubRelease(fromJson: jsonString)
        } catch {
            throw AliceError.requestFailed
        }
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
            - !cuddle - Wait, how did this even get here? 🤔
            - !getrelease [reponame] - Gets the latest stable release of a given repository name from Project Alice.
            - !qt - Tell the bot she's a Qt.
            """))
        case .introduce: message.reply(with: self.introduceSelf())
        case .ping: message.reply(with: getPingMessage())
        case .qt:
            message.addReaction("🚫")
            message.reply(with: getQtMessage())
        case .cuddle: message.reply(with: self.getCuddleMessage())
        case .aboutme: message.reply(with: self.introduceSelf())
        case .asriel: throw DreemurrError.partialOrIncompleteSoul
        case .getrelease:
            do {
                let releaseEmbed = try self.getRelease(of: message.content)
                message.reply(with: releaseEmbed)
            } catch AliceError.missingArguments {
                message.reply(with: "Error: `!getrelease` requires 1 parameter.")
            } catch AliceError.argumentMismatch {
                message.reply(with: "Error: `!getrelease` requires **1** parameter exactly.")
            } catch AliceError.requestFailed {
                message.reply(with: "Error: `!getrelease` request failed. This could be because the repository doesn't exist or the releases aren't stable enough.")
            }
        default: throw DreemurrError.invalidCommand
        }
    }
}

public enum AliceError: Error {
    case missingArguments
    case argumentMismatch
    case releaseIsNil
    case noSuchRepository
    case requestFailed
}
