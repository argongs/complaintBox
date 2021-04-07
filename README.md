# sample

## Why does this app exist ?
This app exists to simulate a transparent process of lodging and resolution of issues related to roads. Along with that, this app demonstrates the usage of the following tools, i.e.

 - [SQLite](https://sqlite.org/index.html)
 - [Google Maps](https://cloud.google.com/maps-platform/)

in [Flutter](https://flutter.dev/). 

> Note that although Flutter allows cross-platform development, this app can run successfully only on Android platforms. The reason being the absence of prerequisites in the source code which were required by the app to run on iOS platforms flawlessly.

## Getting Started

In order to build this app, you'll need atleast :
 - Flutter 1.22.6 and 
 - Dart 2.10.5

Take care of the following steps and you'll be able to build [sample](https://github.com/argongs/complaintBox) soon enough :
 1. You can find installation instructions for Flutter SDK [here](https://flutter.dev/docs/get-started/install). Dart comes along with the SDK, so there's no need for it's explicit installation. 
 2. Once you're done with the installation of the SDK, set up your editor (preferrably [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)) as well (from [here](https://flutter.dev/docs/get-started/editor?tab=androidstudio)).
 3. You can find the instructions to run the source code in Android Studio [here](https://flutter.dev/docs/development/tools/android-studio#running-and-debugging) and for VS Code [here](https://flutter.dev/docs/development/tools/vs-code#running-and-debugging).

## Using the app

Simply registering as a user won't be enough if you wish to explore the app. To explore the app to it's fullest follow the steps below:
 1. Register as a new user
 2. Login as the admin by using email as `admin@sample.com` and password as `12345`
 3. Go to the new user's list in the admin's dashboard and tap on the account recently created by you
 4. Upgrade it's status to 'Active'
 5. Log out of the admin account
 6. Login with the newly created user credentials
 7. Now this new account can allow you to register new complaints and see them on the home screen

> Note that failing to upgrade the status of the newly created user will make the newly created user unable to do anything with his/her account. 
