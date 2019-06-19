# Angelbot 2.0

Angelbot 2.0 is the rewritten version of Angelbot, the official bot for The Studio. Angelbot 2.0 uses Project Alice's [Dreemurr core](https://github.com/projectalicedev/dreemurr) to access and deliver content accordingly and is written entirely in Swift.


## Build Instructions

Clone the Git repository, then run the following commands to build the Swift package and run it:

```
swift build
swift run
```

## Required Configurations
The following must be set in your environment variables before continuing:

- [X] `dreemurr.name` - the name of the bot if not Alice Angel.
- [X] `dreemurr.token` - the appropriate Discord token to use.
- [X] `dreemurr.currentGame` - the name of the game the bot is "playing" if not Bendy and the Ink Machine.

## Features
- [X] Welcomes new users
- [X] Gets information of latest GitHub release of a project
- [X] Responds to being called a Qt
- [X] Responds to cuddle attempts
