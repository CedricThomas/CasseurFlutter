# CasseurFlutter

A note application

## Getting Started

This application use [Auth0](https://auth0.com/) for the users management, [FCM](https://firebase.google.com/docs/cloud-messaging) for notifications and a custom [GO API](https://github.com/CedricThomas/22h31-FaisLesBacks) to manage memos and reminders.

```
flutter run
```

To build or run in release the apk, add the "no-shrink" option (the shrinking is broken due to a dependencie):
```
flutter build apk --release --no-shrink
```

To generate the `key.properties` file use to build the application in release follow this [guide](https://flutter.dev/docs/deployment/android)

## Configuration

This application can be configured in the file `lib/constants.dart`:
```
// Domain of you Auth0 Application
const String AUTH0_DOMAIN = 'dev-dgoly5h6.eu.auth0.com';

// ClientId of you Auth0 Application
const String AUTH0_CLIENT_ID = 'HYdhBMXDFB4x1BCBnCFbqpfllgQ05U5F';

// The redirect URI configured for your Auth0 Application login callback
const String AUTH0_REDIRECT_URI = 'com.reyah.casseurflutter://login-callback';

// The full URL of the domain
const String AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';

// 22h31-FaisLesBacks API address
const String API_URL = 'https://casseur-flutter.herokuapp.com';
```
