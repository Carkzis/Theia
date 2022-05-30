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
    
* On the transport bar (that's the row of circular buttons above the progressing media bar), there are a number of buttons you can press.  Aside from the two rightmost (which are for Subtitles and Audio Range/Track) these relate to "status effects" which you can apply to your viewing experience.  These are as follows (in no particular order, you will have to discover which icons relate to what yourself!):
    * Silence: This will silence the player.  You can also unsilence the player, just press it again.
    * Slow/Haste: This will randomly alter the playback speed of the player, from really slow to really fast.  If you want to get back to normal, click a few times, or click the fix button.
    * Teleport: This will teleport you to a random point in time (within the current media). You can return to your original position by clicking it again.
    * Reversi: This will... reverse the items on the transport bar. Don't worry, this can be undone!  Just click it again!
    * Confusion: This will result in the player randomly pausing and playing when you move around the transport bar.  It can be turned off, but be warned that pausing and playing will change the focus back to the progress bar.  How annoying!
    * Apocalypse: This will cause the apocalypse (which looks suspiciously like the app closing).  You get a few chances (four!) before this happens, but as a spoiler, if the icon looks like an unencased flame, the next time this is invoked will be the last!
    * Fix: This will fix all status effects.  It is pretty useful.
    * Random:  This will randomly apply status effects to the player.  And it can be more than one per click!  Or none.
* If the status effects get too annoying, you can reset the player by returning to the home screen.
* Hopefully the rest of the controls are self explanatory, just look at the remote.

## Authors
Marc Jowett (carkzis.apps@gmail.com)

## Version History
* 1.0
  * Initial Release.  See [commits](https://github.com/Carkzis/Theia/commits/main).

## Acknowledgements
* BBC, because they are great.
