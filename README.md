![Slaxplorer](/Assets/icon.png)  
An iOS app for exploring your Slack team's members. The app presents a list of a team's members, and provides a detailed view of each member when selected.

## Authentication
Since this is an experimental app, it is not registered with Slack, and no access tokens are issued. This means that users can't use their Slack credentials to sign-in to their team.  
Instead, the app presents a login screen where you can provide an access token. This is of course not targeted at real users. However, in the context of an exercise, it allows for quick and simple inspection of the app and its features.  
A default API access token is provided for convenience.

## Architecture
In spite of being an exercise, the app was designed to be used in production and at scale. The architecture is of highest quality and designed with the following guidelines:

#### Performance
* Designed following current best practices
* Concurrency is used to ensure smooth experience
* Efficient image caching using FastImageCache
* Memory footprint is kept at a minimum

#### Data Persistence
* Core Data is used to manage all data
* Double buffering of Core Data contexts for smart background data imports
* Images are cached in memory mapped image tables

#### Maintainability
* Modular code with clear separation of concerns
* DRY design
* BDD test framework
* Documentation

#### Durability
* Mock backend test suite to handle all web scenarios using OHHTTPStubs
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
TBD


### TODO
* TITLE! (not documented in API)
* Refresh
* Core Data error handling
