# RickNMorty App
Rick And Morty App is an iOS mobile application built with Swift and UIKit that allows users to explore characters, locations, and episodes from the Rick and Morty TV series. The app implements the MVVM architecture pattern with a clean separation of concerns using repositories and view models.

## Features
- 📱 Browse all characters with search and advanced filtering (status, species, gender)
- 🌍 Explore locations from the Rick and Morty universe
- 🎬 View all episodes with season and air date information
- 🔍 Search functionality across all screens
- 📄 Detailed views for characters, locations, and episodes
- ♻️ Reactive programming with Combine framework

## Requirements
- iOS 14.0+
- Xcode 14.0+
- Swift 5.0+

## Architecture
The app follows **MVVM (Model-View-ViewModel)** architecture with:
- **Repository Pattern** for data management
- **Combine Framework** for reactive data binding
- **Protocol-Oriented Programming** for testability
- **URLSession** for networking

## Screens
### Character Screen
This screen displays a list of all available characters in Rick and Morty TV series. The list is fetched from the API, and it includes small information such as the name and species of the character. Users can use the search bar to find specific characters based on their names. Also, there is a filter button that allows users to filter characters based on their status, species, or gender.\
<img src="https://user-images.githubusercontent.com/29261625/235571022-65e073fc-4153-44c4-a0c0-f8f1961eee85.png" width="300" height="650">

Tapping on a character in the list will lead users to the Character Detail screen. This screen shows detailed information about the character, including gender, location, origin, episode, created date, and image.\
<img src="https://user-images.githubusercontent.com/29261625/235571864-ebbe0adf-e930-4e80-b42c-c5e3b5f9f6ec.png" width="300" height="650">

### Location Screen
The Location screen lists all available locations in Rick and Morty TV series. The list is fetched from the API, and tapping on a location will display the details of that location.\
<img src="https://user-images.githubusercontent.com/29261625/235571953-600ea46c-7712-4193-8279-80746519c328.png" width="300" height="650">

### Episodes Screen
This screen displays a list of all episodes in Rick and Morty TV series. The list is fetched from the API, and it has been modified to include information such as the date, season, and episode. Tapping on an episode will lead users to the Episode Detail screen, which shows more information about that episode.\
<img src="https://user-images.githubusercontent.com/29261625/235571997-f917d764-06d5-4207-96f8-58ee83f7668f.png" width="300" height="650">

## Installation
1. Clone the repository

2. Open the project in Xcode:
   ```bash
   open RickNMorty.xcodeproj
   ```

3. Wait for Swift Package Manager to resolve dependencies

4. Select your target device or simulator

5. Build and run (⌘R)

## Dependencies
The app uses **Swift Package Manager (SPM)** for dependency management:

- **[TagListView](https://github.com/ElaWorkshop/TagListView)** - Customizable tag list view for displaying filters

Dependencies are automatically resolved by Xcode when you open the project.

## Project Structure
```
RickNMorty/
├── APIClient/           # Network layer (Services, Endpoints)
├── Models/              # Data models (Character, Location, Episode)
│   └── ResponseTypes/   # API response models
├── Repositories/        # Data repositories with protocols
├── ViewModels/          # MVVM view models
│   └── DisplayData/     # View-specific data models
├── Views/               # UIViewController and custom views
│   └── Cells/           # UITableViewCell and UICollectionViewCell
├── Helpers/             # Utility classes and extensions
└── Resources/           # AppDelegate, SceneDelegate, Assets
```

## Credits
Rick And Morty App uses the [Rick and Morty API](https://rickandmortyapi.com) to fetch information related to the TV series.

## License
This project is licensed under the MIT License. See the [License](LICENSE.md) file for details.
