# Top 10 Songs App

This iOS application built with Swift allows users to browse the top 10 songs from the iTunes API in the countries US, CL, and SE. Users can view detailed information about each song and artist, and they have the option to add songs to their favorites list.

## Features

### 1. Top 10 Songs
- The app fetches data from the iTunes API to display the top 10 songs in the selected countries: US, CL, and SE.
- Users can scroll through the list of songs and view basic information such as song title and artist name.

### 2. Song Details
- Tapping on a song in the list navigates users to a detailed view showing additional information about the song and artist.
- Detailed information includes the song title, artist name, release date, and artwork.

### 3. Favorites
- Users have the option to add songs to their favorites list by tapping on a star icon.
- Once added to favorites, the star icon changes color to indicate that the song is favorited.
- Favorited songs are stored locally using UserDefaults for persistent storage.

## Implementation Details

### 1. API Integration
- The app integrates with the iTunes API to fetch the list of top songs.
- It makes HTTP requests to the API endpoint and parses the JSON response to extract relevant song information.

### 2. User Interface
- The user interface is built using UIKit components such as UITableView and custom UIViews.
- Auto Layout constraints are used to ensure proper layout and responsiveness across different device sizes.

### 3. Local Storage
- UserDefaults is used to store the list of favorited songs locally on the device.
- When the app launches, it retrieves the list of favorited songs from UserDefaults and updates the UI accordingly.

## Installation

To run the app locally on your machine, follow these steps:

1. Clone the repository to your local machine using Git:

2. Open the project in Xcode.

3. Build and run the project on a simulator or a physical device.

## Dependencies

- Kingfisher: A lightweight and pure Swift library for downloading and caching images from the web.

## Future Improvements

- Implement a search feature to allow users to search for specific songs or artists.
- Add support for more countries and regions to expand the range of available songs.
- Enhance the user interface with animations and transitions to provide a more engaging experience.
- Implement data caching to improve app performance and reduce load times when fetching song data.


