# Voolta-iOS
Voolta iOS contains the code for a mobile native app that displays walking and cycling routes to get around the city.

![](src/photo.png)

## Technicalities

This app communicates with a backend service whose source code and repo can be found at: https://github.com/vidriloco/VooltaWeb .
Once the backend's code repository is deployed, the app can fetch and display the by-default added trips.

## App configuration

The app main configuration file is defined at `urls.plist`. It contains definitions for the URL endpoints and backend URL.

### Environments 

The app can be set up to run in two different environments: `production` and `development`. 
See the `AppDelegate.m` file: `[App initializeAppMode:kLiteMode withEnv:kDev];` and use either `kDev` or `kProd`.

### URL endpoints

Changing the app's environment will change the endpoint it sends requests to. 
These are defined as keys within the `urls.plist` file as `backendURLDev` and `backendURL`  

### Routes

The routes the app uses to make requests to the backend are also defined in the `urls.plist`.

### Storage

This app uses ActiveRecord, an ORM for CoreData which gets configured and loaded on the app delegate. See this line of code `[ActiveRecord registerDatabaseName:@"hirooDB" useDirectory:ARStorageDocuments];`
