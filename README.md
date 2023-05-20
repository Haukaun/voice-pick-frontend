# Voice Pick Frontend

Frontend repository containing the source code of the iOS mobile application voice pick.

## Table of Contents

1. Getting Started
2. Project Structure

## 1. Getting started

### Prerequisites

- XCode

### Installing

1. Clone the repository
2. Change into the directory
3. Go to `Build Settings`, under `user defined` enter the URL of the API the applicaiton should connect to
4. Select device to run the application on (drop down next to play icon)
5. Run application via XCode using the play icon (top right)

## 2. Project Structure

The application is written in Swift using SwiftUI. The source code is located in the `voice-pick-frontend`.

`voice-pick-frontend` - source code
`lib` - Facade classes wrapping third party libraries
`layouts` - For layout components, _like bottom navigation_
`features` - Features in the app _described in more details belove_
`utils` - Global utility classes
`pages` - Pages the app consists of
`models` - Global models used throughout the app
`service` - Global service classes used throughout the app
`components` - Global UI components used throughout the app

There are three special directories; lib, features and layouts.

- The lib folder consists of facade classes, wrapping third party libraries that is used in the application. For example, if axios is used, a wrapper class should be create exposing method that can be used throughout the application. If axios need to be updated or changed, every change can be done in one location where this wrapper class is defined (underneath the `lib` directory).

- The features directory consists of sub-directory, one for each feature found in the application. In each sub-directory, there will be more directories for; `components`, `services`, `models`, etc... Here you will find classes that are not global and only used for the respective feature. Example of feature directory:

```
features:
    authentication:
        components:
            forms:
                LoginForm
                SignUpForm
        services:
            AuthService
        dtos:
            LoginRequest
            LoginResponse
```

- The layout directory consists of layout components that are used throughout the application like; bottom navigation bar, top header, menu drawers, etc...

_Link to video explaining the structure: [Youtube Video](https://www.youtube.com/watch?v=UUga4-z7b6s&t=581s&ab_channel=WebDevSimplified)_
