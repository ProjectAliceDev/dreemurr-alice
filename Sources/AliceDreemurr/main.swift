import DreemurrCore
import Sword

print("""
Angelbot v2.0
Built with Dreemurr Core.
(C) 2019 Project Alice. All rights reserved.
""")

let testConfiguration = """
{
\"name\": \"Alice Angel\",
\"currentGame\": \"Portal 2\",
\"token\": \"NTg5NTc2MzMxNzA0OTI2MjA4.XQVr7Q.K-8iW0luEhpqbnjczF2JFxD1g-M\"
}
"""

print("Creating new determination from JSON configs.")
let testDetermination = Determination(fromJson: testConfiguration)

if testDetermination != nil {
    print("New determination accepted. Creating a new Dreemurr instance.")
    let aliceAngel = Alice(determinedFrom: testDetermination!)
    aliceAngel.onWatchMessages(doThis: { data in
        let message = data as! Message
        
        if message.content.starts(with: "!") {
            do {
                let possibleCommand = try aliceAngel.toAliceCommand(input: message.content)
                aliceAngel.parseCommand(command: possibleCommand, message: message)
            } catch {
                message.reply(with: "Error: `\(message.content)` is not a valid command. Type `!help` for the list of available commands.")
            }
            
        }
        
    })
    print("Connecting Alice to Discord.")
    aliceAngel.connect()
}
