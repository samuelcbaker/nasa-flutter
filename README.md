<img src="/assets/icon.png" height="50">

# Nasa Picture of the Day - Flutter Project

A Flutter application to visualize Nasa pictures of the day. This Flutter application was developed using Clean Dart architecture and for state management we use Bloc.

## Getting Started

This Flutter project has been tested on Android and iOS devices, but in the future we can configure it for web and desktop devices.
The current version of Flutter is `3.19.4`.

## Dependencies

- Flutter 3.19.4
- Cocoapods 1.15.2

## How to Run

**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/samuelcbaker/nasa-flutter.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies:

```
flutter pub get
```

**Step 2.1 (for iOS):**

Go to project ios folder and execute the following command in console to get the required dependencies for ios:

```
pod install
```

**Step 3:**

Select your favorite IDE and run the `main.dart` file. Or run the following command on your terminal:

```
flutter run
```

## App Features:

- Splash
- Show a list of Nasa Pictures of the day
- Pull-to-refresh images
- Get more images with pagination
- Search images by title and date using our search bar
- Offline mode
- View image details
- Support multiple resolutions and sizes

### Nasa API Used

- [Official API website](https://api.nasa.gov)
- The endpoint used was [APOD](https://api.nasa.gov/planetary/apod), where we can see the Nasa pictures of the day.

### Libraries & Tools Used

- [flutter_bloc](https://pub.dev/packages/flutter_bloc) → state management
- [get_it](https://pub.dev/packages/get_it) → dependency injection
- [dio](https://pub.dev/packages/dio) → http requests
- [intl](https://pub.dev/packages/get_it) → work with date time formats
- [hive](https://pub.dev/packages/hive) → NoSQL database, offline feature
- [equatable](https://pub.dev/packages/equatable) → compare objects and help in tests
- [connectivity_plus](https://pub.dev/packages/connectivity_plus) → verify if user is offline
- [mocktail](https://pub.dev/packages/mocktail) → mock objects in test
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) → add launcher icons
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash) → add icon on native splash
- [integration_test](https://docs.flutter.dev/testing/integration-tests) → integration tests framework

### Folder Structure

Here is the folder structure we have been using in this project. We designed this project using the Clean Architecture model.

```
lib/
|- domain/
|- infra/
|- data/
|- di/
|- extensions/
|- view/
|- app.dart
|- constants.dart
|- main.dart
```

Now, lets dive into the lib folder which has the main code for the application.

```
1- domain - Contains the main layer of our application. The domain layer contains the business logic including entities, use cases and repository contract.
2- infra - Contains the middle layer between external data and business rules. We use this layer to handle data and exceptions that may be sent by external data.
3- data - Contains the data layer of your project, including data from local storage and network data.
4- di - Contains dependency injection configuration of this project.
5- extensions - Contains some extensions resources to help and beautify the development.
6- view - Contains the view layer. Where we can create screens, widgets and control the state management using Flutter bloc cubits.
7- app.dart - The main widget of our application.
8- constants.dart - Contains all the constants needed to successfully project work.
9- main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title etc.
```

### Domain

All the business logic of your application will go into this directory, it represents the domain layer of your application. It is sub-divided into four directories `entities` which contains entities definitions, `exceptions` which contains all exceptions classes, `repositories` which contains the repositories contract and `usecases` which contains the business logic action. Since each layer exists independently, that makes it easier to unit test. The communication between view and domain layer is handled by using usecases on Flutter Bloc Cubit.

```
domain/
|- entities/
    |- nasa_image.dart

|- exceptions/
    |- exceptions.dart

|- repositories
    |- image_repository.dart

|- usecases
    |- get_image_usecase.dart
```

### Infra

The middle layer between external data and business rules. We use this layer to handle data and exceptions that may be sent by external data. It is sub-divided into three directories `datasources` which contains the local and network datasources contracts, `models` which contains data models to parse json to entity and `repositories` which contains the implementation of domain repository contract. Since each layer exists independently, that makes it easier to unit test.

```
infra/
|- datasources/
    |- api_image_datasource.dart
    |- local_image_datasource.dart

|- models/
    |- nasa_image_model.dart

|- repositories
    |- image_repository_impl.dart
```

### Data

The data layer is responsible for communicating with external data. This external data can be local or network based. It is sub-divided into one directory `datasources` which contains the implementation of infra datasources contracts. Since each layer exists independently, that makes it easier to unit test.

```
data/
|- datasources/
    |- api_image_datasource_impl.dart
    |- local_image_datasource_impl.dart
```

### View

The view layer is responsible for containing screens and Flutter Bloc Cubit, which can control the state management. The screens call methods on Cubit that perform some actions with usecases and send states to control the view screens. It is sub-divided into three directories `cubit` which contains the states and cubit class, `screens` which contains screens of our application and `widgets` which contains reusable widgets of our application.

```
view/
|- cubit/
    |- connectivity/
        |- connectivity_cubit.dart
        |- connectivity_state.dart

    |- list_images/
        |- list_images_cubit.dart
        |- list_images_state.dart

|- screens/
    |- image_detail_screen.dart
    |- list_images_screen.dart

|- widgets/
    |- image_widget.dart
    |- search_bar_widget.dart
```

### Unit Tests

We made the unit tests for main layers. This is our test folder structure:

```
test/
|- data/
|- domain/
|- infra/
|- mock/
|- view/
```

Run the following command on your terminal to execute all unit tests:

```
flutter test
```

### Integration Tests

We made the integration tests for list view screen. This is our integration test folder structure:

```
integration_test/
|- view/
    |- screens/
        |- list_images_screen_test.dart
```

Run the following command on your terminal to execute all integration tests:

```
flutter test ./integration_test
```

### main.dart and app.dart

This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, title, orientation, define blocs, dependency injection etc.

main.dart

```dart
import 'package:flutter/material.dart';
import 'package:nasa_flutter/app.dart';
import 'package:nasa_flutter/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInjection.inject();

  runApp(const NasaApp());
}
```

app.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_flutter/di/injection.dart';
import 'package:nasa_flutter/view/cubit/connectivity/connectivity_cubit.dart';
import 'package:nasa_flutter/view/cubit/list_images/list_images_cubit.dart';
import 'package:nasa_flutter/view/screens/list_images_screen.dart';

class NasaApp extends StatelessWidget {
  const NasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nasa Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ListImagesCubit>(
            create: (context) => getIt(),
          ),
          BlocProvider<ConnectivityCubit>(
            create: (context) => getIt(),
          ),
        ],
        child: const ListImagesScreen(),
      ),
    );
  }
}
```

## Demonstration Video

<img src="/assets/demo-video.gif" height="800">

## Conclusion

We can always improve our projects. Thanks!
