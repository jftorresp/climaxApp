## Climax App ☀️💧

An app that shows you the 3-day forecast for any city that you search! You can also save favorites!

### How to Install and Run

1. Clone the repository via **HTTP**: ```git clone repo url https://github.com/jftorresp/climaxApp.git```
2. Open the ```climaxApp.xcodeproj``` on Xcode.
3. Resolve package cache and versions from **Swift Package Manager (SPM)** if required.
4. In the folder `/Configuration` you will find a JSON file called `config.json`. Replace the value of `api_key` with the **API KEY** for testing the connection to the _Weather API_:
   ```
   {
      "api_key": "your_api_key"
   }
   ```
   _(This step is really important if not the app won't work as expected)._
6. Build the project with ```⌘ CMD B```
7. Run the app and enjoy!

### Features

- View the 3-day forecast and more weather information of any city in the world.
- Search for any city to view its forecast.
- Save favorite citites locally in the app. With no limit! (for now).
- Supports landscape mode for your iPhone.

