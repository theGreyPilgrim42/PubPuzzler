# Pub Puzzler

This is a simple Pub Quiz application which you can play on your own.

Before you can run the application duplicate the `.env.template` file as a `.env` file. I will provide the needed values.

To start the application run the following commands in the application's directory:
```bash
flutter pub get
flutter run
```

## Architecture
The architecture for this application is based on the Clean Dart architecture from [Flutterando](https://github.com/Flutterando/Clean-Dart/blob/master/README_en.md). The architecture is split in the following four layers:
- **Presenter:** This layer is responsible for the interactions of the application. It contains Widgets, Pages and other UI components.
- **Domain:** This layer contains the core business logic (entities) and application-specific logic (use-cases).
- **Infra:** This layer supports the domain layer by adapting incoming data from the external layer through repositories, services, etc.
- **External:** This layer implements the access to external services.

## CI-Pipeline
The repository uses a very simple CI-Pipeline to check the code formatting and analyze the
source code using rules based on the [flutter_lints](https://pub.dev/packages/flutter_lints) linter.

## Topic Specialization
The topic specialization is based around PaaS [appwrite.io](https://appwrite.io/) for auth, backend and cloud functions.

To use their service an account must be created on [appwrite.io](https://appwrite.io/).
A step-by-step guide on how to setup a new Flutter project on appwrite.io is available [here](https://appwrite.io/docs/quick-starts/flutter).

You need to download the appwrite's client SDK for integrating it in the client application:
```bash
flutter pub add appwrite
```

The SDK in combination with the [API](https://appwrite.io/docs/references/cloud/client-flutter/account) makes it easy to use Appwrite's auth service, store and receive data from their database and create and execute cloud functions.

This application uses 
- the auth service to register new users and authenticate existing users
- the database to persist and receive played games for calculating the user score and accuracy
- cloud functions to log errors for analyzing them later and improve the application's performance

## Functionality
The application provides the following "main" pages:
- LoginForm to login as an existing user or register a new user
- AccountPage to see user statistics and log out
- ChooseQuestionTypeForm to configure with which settings to start a new quiz
- QuestionScreen to show the questions, possible answers and the current user score

Currently a user session is not persisted in any way, since this was out of scope (would
require saving data locally which was another topic specialization).