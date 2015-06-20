![Slaxplorer logo](/Assets/logo.png)

An iOS app for exploring your Slack team's members. The app presents a list of a team's members, and provides a detailed view of each member when selected.

## Authentication
Since this is an experimental app, it is not registered with Slack, and no access tokens are issued. This means that users can't use their Slack credentials to sign-in to their team.  
Instead, the app presents a login screen where you can provide an access token. This is of course not targeted at real users. However, in the context of an exercise, it allows for quick and simple inspection of the app and its features.  
A default API access token is provided for convenience.

## API Calls
Two API calls are used in this exercise.
Initially we `GET https://slack.com/api/team.info` in order to fetch the team's name, and verify the provided access token.
Then, in order to retrieve the list of users, we `GET https://slack.com/api/users.list`. The user list is then polled periodically every 15 seconds. Due to the nature of the data involved, and the fact that teams don't change frequently, there's no need to implement user initiated refresh features.

## Architecture
In spite of being an exercise, the app was designed to be used in production and at scale. The architecture is of highest quality and designed with the following guidelines:

#### Performance
* Designed following current best practices
* Concurrency is widely used to ensure smooth experience
* Efficient image caching using FastImageCache
* Memory footprint is kept at a minimum

#### Data Persistence
* Core Data is used to manage all data
* Main and background Core Data contexts operate for safe sync and smooth experience
* Images are cached in memory mapped image tables

#### Maintainability
* Modular code with clear separation of concerns
* DRY design
* BDD test framework
* Well documented

#### Durability
* Mock backend test suite using OHHTTPStubs to handle all web scenarios
* Dependency injection of critical objects
* Tested on physical iPhone 6
* Tested on simulators: iPhone 4S, 5, 5S, 6, 6 Plus
* All flow errors nicely reported to user

#### Readability
* Clear and organized code
* Adheres to raywenderlich.com Swift and Objective-C style guides
* Self-explanatory classes and methods

#### Design
* Beautifully designed with Material Design guidelines
* Intuitive UX
* Adaptive design fits nicely on all iPhone sizes using Auto Layout
* Automatic asset generation using Sketch

## What's Next
* Implement Slack authentication using user's credentials
* BDD test suite for DataManager
