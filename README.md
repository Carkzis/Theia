# Theia
View media content on your TV, but with a twist!

# Description
This will play media content on an Apple TV, but with the added bonus (sic) of allowing you to give yourself status effects, such as making the video progress slower, or "teleport" you to another position, or bring on the apocalypse! You can even give yourself some random status effects if you are indecisive. Don't worry though, you can always click the "fix" button, if you aren't too confused to get to reach it (yes, confusion is also a status effect!). Of course, you can also watch content normally, but where is the fun in that?

## Dependencies
* Xcode 13.1 or higher.
* tvOS 13.0 or higher.

## Installing
* You can download the code from the Theia repository by clicking "Code", then "Download ZIP".
* You can then install this from within Xcode onto an emulator or via an Apple TV device (tvOS 13.0 or higher) via the play button in the top right-hand corner.

## Executing the program
* You can run the app off a suitable emulator/Apple TV device.
* On opening the app, you will see the below home screen.  Self-explanatory, but if you want to view the media content and enter the world of weird frustration, click "Play Content".

    <img src="https://github.com/Carkzis/Theia/blob/main/Screenshots/home_screen.png?raw=true" width="800" />	
    
* The content that will play is determined by the VIDEO_URL constant within the VideoURL.m file. The default is a presentation by some bloke from Apple.
* You can change this to another source of content from both local and remote file-base media (e.g. MP3), or media served using HTTP Live Streaming; just change the address stored in the VIDEO_URL constant in Xcode and reload the app (it's faster than typing it into a textbox using a remote, and the feature to do so isn't implemented anyway).
* After choosing to play the content, you will be taken to the player, as shown below:

    <img src="https://github.com/Carkzis/Theia/blob/main/Screenshots/player.png?raw=true" width="800" />
    
* TO BE CONTINUED

## Authors
Marc Jowett (carkzis.apps@gmail.com)

## Version History
* 1.0
  * Initial Release.  See [commits](https://github.com/Carkzis/Theia/commits/main).

## Acknowledgements
* BBC, because they are great.
