import DreemurrCore
import Sword
import Logging
import Foundation

print("""
Angelbot v2.0
Built with Dreemurr Core.
(C) 2019 Project Alice. All rights reserved.
""")

// Create a configuration from environment variables if possible.
let testConfiguration = DreemurrEnvironment.createEnvironmentVariablesAsDecodableJSON(nameDefaultsTo: "Alice Angel", gameDefaultsTo: "Bendy and the Ink Machine")

// Instantiate the logger for the main environment.
let logger = Logger(label: "app.aliceos.dreemurr-alice.main")

// Create a Determination config from the JSON string.
logger.info("Creating new determination from JSON configs.")
let testDetermination = Determination(fromJson: testConfiguration)

// Check if the configuration succeeded.
if testDetermination != nil {
    logger.info("New determination accepted. Creating a new Dreemurr instance.")
    let aliceAngel = Alice(determinedFrom: testDetermination!)
    aliceAngel.onWatchMessages(doThis: { data in
        let message = data as! Message
        
        if message.content.starts(with: "!") {
            logger.info("Received possible command: \(message.content). Parsing...")
            do {
                let possibleCommand = try aliceAngel.toAliceCommand(input: message.content)
                try aliceAngel.parseCommand(command: possibleCommand, message: message)
            }
                
            catch DreemurrError.invalidCommand {
                logger.error("Input is an invalid command.")
                message.reply(with: "Error: `\(message.content)` is not a valid command. Type `!help` for the list of available commands.\n_Is this a bug?_ Report it here: https://github.com/projectalicedev/dreemurr-alice/issues")
            }
            
            catch {
                logger.error("An error occurred with command \(message.content): \(error)")
                message.reply(with: "An error occurred with the command `\(message.content)`.\nThe error in question is: `\(error)`\n\n_Is this a bug?_ Report it here: https://github.com/projectalicedev/dreemurr-alice/issues")
            }
            
        }
        
    })
    logger.info("Connecting Alice to Discord.")
    aliceAngel.connect()
} else {
    logger.error("Determination not accepted. Possibly malformed or missing.")
    exit(1)
}
