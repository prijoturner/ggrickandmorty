# Rick And Morty App
Rick And Morty App is a mobile application built with Swift programming language and implemented with MVVM design pattern. The app has 3 main screens - Character, Location, and Episodes - that allow users to browse information related to Rick and Morty TV series.

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
To run the Rick And Morty App, you will need to have Xcode installed on your Mac. After cloning the project, open the `.xcodeproj` file in Xcode, select the target device, and click on the run button.

## Dependencies
Rick And Morty App uses the following dependencies:

`FittedSheets`: A library for presenting bottom sheet.\
`TagListView`: A customizable tag list view library.

## Credits
Rick And Morty App uses the [Rick and Morty API](https://rickandmortyapi.com) to fetch information related to the TV series.

## License
This project is licensed under the MIT License. See the [License](LICENSE.md) file for details.
