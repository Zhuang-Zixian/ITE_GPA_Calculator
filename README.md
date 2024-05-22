# ITE GPA Calculator

# This code has existing problems that have yet to be fixed!
1. Login has the issue of allowing any user to login as long as it matches the input validation without using the shared_preferences_helper.dart file

# Last code changes before push/commit
29 November 2023

## Overview

The ITE GPA Calculator is a mobile application developed using Flutter that allows students of the Institute of Technical Education (ITE) to calculate and track their GPA and CGPA. The app includes features such as user authentication, GPA calculation, and a visually appealing dashboard.

## Features

- **User Authentication**: Users can log in and manage their accounts.
- **Forgot Password**: Users can reset their passwords if they forget them.
- **Create New Account**: New users can create an account.
- **GPA Calculation**: Calculate GPA for different modules.
- **CGPA Tracking**: Track overall CGPA and set target CGPA.
- **Dashboard**: A user-friendly dashboard that displays the current CGPA, target CGPA, and the difference needed to reach the target.

## Screenshots

Include some screenshots of your app here to showcase its features and design.

## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: Comes with Flutter installation.
- Android Studio or Visual Studio Code: Recommended IDE for Flutter development.

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/ITE-GPA-Calculator.git
    cd ITE-GPA-Calculator
    ```

2. Install the dependencies:

    ```bash
    flutter pub get
    ```

3. Run the app:

    ```bash
    flutter run
    ```

## Project Structure

```plaintext
lib/
├── cgpa_provider.dart           # CGPA state management using Provider
├── gpa_calculator_screen.dart   # GPA Calculator screen
├── home_page.dart               # Home screen with CGPA and target CGPA
├── landing_page.dart            # Initial landing page with login and skip options
├── login_provider.dart          # Login state management using Provider
├── login_screen.dart            # Login screen
├── shared_preference_helper.dart# Helper functions for shared preferences
assets/
├── images/
│   ├── landing_pageBG.png       # Background image for the landing page
│   └── itelogo.png              # Logo for the app
pubspec.yaml                     # Flutter configuration file

Usage
Logging In
On the landing page, tap on the Login button to navigate to the login screen.
Enter your email and password to log in. If you don’t have an account, you can create one.
If you forget your password, use the Forgot Password option to reset it.
Using the GPA Calculator
Once logged in, you will be directed to the home page.
The home page displays your current CGPA, target CGPA, and the difference needed to reach your target.
Tap on Edit GPA Target to set a new target CGPA.
Navigate to the GPA Calculator screen to calculate your GPA for different modules.
Contributing
Contributions are welcome! Please fork the repository and create a pull request with your changes. Ensure that your code follows the project's coding standards and includes appropriate tests.

License
This project is licensed under the MIT License. See the LICENSE file for details.

Contact
If you have any questions or feedback, feel free to reach out to the project maintainer:

Email: zixianzhuang05@gmail.com
GitHub: Zhuang-Zixian

This README provides a comprehensive guide for anyone who wants to understand, install, and contribute to your project.

