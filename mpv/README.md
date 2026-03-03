# Personal mpv Configuration for Windows

<p align="center"><img width=100% src="https://github.com/user-attachments/assets/7d6b7cfd-41c7-4617-b573-933b4b3bd564" alt="mpv screenshot"></p>
<p align="center"><img width=100% src="https://github.com/user-attachments/assets/bfd85e57-f244-4de4-8bf9-750723c51568" alt="mpv screenshot"></p>

## Overview
Just my personal config files for use in [mpv](https://mpv.io/), a free, open-source, & cross-platform media player, with a focus on quality and a practical yet comfortable viewing experience. Contains tuned profiles (for up/downscaling, live action, anime & HDR content), custom key bindings, a GUI, as well as multiple scripts, shaders & filters, all serving different functions. Suitable for both high and low-end pc's (with some tweaks).

Before installing, please take your time to read this whole README as common issues can be easily solved by simply reading carefully.

## Scripts and Shaders
- [uosc](https://github.com/darsain/uosc) - Adds a minimalist but highly customisable GUI.
- [evafast](https://github.com/po5/evafast) - Fast-forwarding and seeking on a single key.
- [thumbfast](https://github.com/po5/thumbfast) - High-performance on-the-fly thumbnailer.
- [memo](https://github.com/po5/memo) - A recent files/history menu for mpv with optional uosc integration.
- [InputEvent](https://github.com/natural-harmonia-gropius/input-event) - Enhanced input.conf with better, conflict-free, low-latency event mechanisms.
- [autodeint](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autodeint.lua) - Automatically deinterlace the video by using lavfi's idet filter to detect interlaced content.
- [autoload](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autoload.lua) - Automatically load playlist entries before and after the currently playing file, by scanning the directory.
- - - 
- [nnedi3 and ravu](https://github.com/bjin/mpv-prescalers) - User shaders for prescaling.
- [FSRCNN](https://github.com/igv/FSRCNN-TensorFlow/releases) - Prescaler based on layered convolutional networks.
- [AniSD ArtCNN](https://github.com/Sirosky/Upscale-Hub/releases/tag/AniSD-ArtCNN) - ArtCNN shader for standard definition anime content.
- [Anime4k](https://github.com/bloc97/Anime4K) - Shaders designed to scale and enhance anime. Includes shaders for sharpening and upscaling.
- [nlmeans](https://github.com/AN3223/dotfiles/blob/master/.config/mpv/shaders/) - A featureful implementation of the non-local Means algorithm, it does both denoising and adaptive sharpening.
- [Ani4K v2 ArtCNN](https://github.com/Sirosky/Upscale-Hub/releases/tag/Ani4k-v2-ArtCNN) - Targets modern anime, from high quality Blu-ray to crappy WEB releases, for upscaling to either 2K or 4K.
- [SSimDownscaler, SSimSuperRes, KrigBilateral, Adaptive Sharpen](https://gist.github.com/igv) 
    - Adaptive Sharpen: A sharpening shader.
    - SSimDownscaler: Perceptually based downscaler.
    - KrigBilateral: Chroma scaler that uses luma information for high quality upscaling.
    - SSimSuperRes: Make corrections to the image upscaled by mpv built-in scaler (removes ringing artifacts and restores original  sharpness).
   
## Installation (on Windows)

(Not tested on Linux and macOS but once mpv is installed, copying the contents of my `portable_config` into the [relevant](https://mpv.io/manual/master/#files) folders should be sufficient. Some settings in [mpv.conf](https://github.com/Zabooby/mpv-config/blob/main/portable_config/mpv.conf) may need to be changed due to compatibility issues. Check console for any errors.)

* Download the latest 64bit (or 64bit-v3 for newer CPUs) mpv Windows build by shinchiro [here](https://mpv.io/installation/) or directly from [here](https://github.com/shinchiro/mpv-winbuild-cmake/releases) and extract its contents into a folder of your choice (mine is called mpv). This is now your mpv folder and can be placed wherever you want. 
* Run `mpv-install.bat`, which is located in the `installer` folder (see File Structure section), with administrator privileges by right-clicking and selecting run as administrator, after it's done, you'll get a prompt to open Control Panel and set mpv as the default player.
* Download and extract the `portable_config` folder from this repo to the mpv folder you just made. 
* Add file paths, to 2 files in the [script-opts](https://github.com/Zabooby/mpv-config/tree/main/portable_config/script-opts) folder (detailed in the File Structure section), to match your preferences. 
* **Adjust relevant settings in [mpv.conf](https://github.com/Zabooby/mpv-config/blob/main/portable_config/mpv.conf) & [profiles.conf](https://github.com/Zabooby/mpv-config/blob/main/portable_config/profiles.conf) to fit your system and preferences, use the [manual](https://mpv.io/manual/master/) to find out what different options do or open an issue if you need any help.**
* For mpv updates, right click updater.bat and run as administrator, then follow the instructions. There will be an option to install yt-dlp to be able to stream YouTube videos and any other websites supported by [yt-dlp,](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md) if you want. Once the initial run of updater.bat has completed a settings.xml file will be generated to save your preferences. 
* You're all set up. Go watch some videos!

After following the steps above, your mpv folder should have the following structure:

## File Structure (on Windows)

```
mpv
|
├── doc
│   ├── manual.pdf                            
│   └── mpbindings.png                    # Default key bindings if not overridden in input.conf
│
├── installer
│   ├── mpv-icon.ico
│   ├── mpv-install.bat                   # Run with administrator privileges to install mpv
│   ├── mpv-uninstall.bat                 # Run with administrator privileges to uninstall mpv
│   └── updater.ps1
│
├── portable_config                       # This is where my config is placed
│   ├── cache                             # Created automatically  
│   │   ├──  shaders_cache
│   │   ├──  watch_later                  
│   │
│   ├── fonts
│   │   ├── ClearSans-Bold.ttf
│   │   ├── JetBrainsMono-Regular.ttf
|   |   ├── uosc_icons.otf
|   |   └── uosc_textures.ttf
│   │
│   ├── script-opts                       # Contains configuration files for scripts
|   |   ├── console.conf
|   |   ├── evafast.conf 
|   |   ├── memo.conf
|   |   ├── memo-history.log              # Created automatically 
│   │   ├── thumbfast.conf                    
│   │   ├── uosc.conf                     # Set desired default directory for uosc menu here
│   │
│   ├── scripts      
│   │   ├── uosc              
│   │       ├── bin 
|   |           ├── ziggy-darwin
|   |           ├── ziggy-linux
|   |           ├── ziggy-windows.exe
│   │       ├── char_conv
|   |           ├── zh.json
│   │       ├── elements 
|   |           ├── BufferingIndicator.lua
|   |           ├── Button.lua
|   |           ├── Controls.lua
|   |           ├── Curtain.lua
|   |           ├── CycleButton.lua
|   |           ├── Element.lua
|   |           ├── Elements.lua
|   |           ├── ManagedButton.lua
|   |           ├── Menu.lua
|   |           ├── PauseIndicator.lua
|   |           ├── Speed.lua
|   |           ├── Timeline.lua
|   |           ├── TopBar.lua
|   |           ├── Updater.lua
|   |           ├── Volume.lua
|   |           └── WindowBorder.lua
|   |       ├── intl
|   |           ├── de.lua
|   |           ├── es.lua
|   |           ├── fr.json
|   |           ├── pl.json
|   |           ├── ro.json
|   |           ├── ru.json
|   |           ├── tr.json
|   |           ├── uk.json
|   |           └── zh-hans.json
|   |       ├── lib
|   |           ├── ass.lua
|   |           ├── buttons.lua
|   |           ├── char_conv.lua
|   |           ├── cursor.lua
|   |           ├── fzy.lua
|   |           ├── intl.lua
|   |           ├── menus.lua
|   |           ├── std.lua
|   |           ├── text.lua
|   |           └── utils.lua
|   |       └── main.lua
│   │
│   │   ├── autodeint.lua
│   │   ├── autoload.lua 
│   │   ├── evafast.lua                   # Activated by holding right arrow key
│   │   ├── inputevent.lua
|   |   ├── memo.lua
│   │   ├── thumbfast.lua                     
│   │
│   ├── shaders                          
│   │   ├── A4K_Clamp_Highlights.glsl                         
│   │   ├── A4K_Restore_CNN_Soft_M.glsl
│   │   ├── adasharp_luma.glsl
│   │   ├── Ani4Kv2_ArtCNN_C4F32_i2.glsl
│   │   ├── AniSD_ArtCNN_C4F32_i4.glsl
│   │   ├── F8.glsl
│   │   ├── F16.glsl
│   │   ├── krigbl.glsl
│   │   ├── nlmeans_luma.glsl
│   │   ├── nnedi3-nns32-win8x4.glsl       
│   │   ├── nnedi3-nns64-win8x4.glsl
│   │   ├── ravu_z_ar_r3.glsl
│   │   ├── ssimds.glsl
│   │   └── ssimsr.glsl
│   │
|   ├── fonts.conf                        # Delete the duplicate made when installing mpv
│   ├── input.conf                        # Customise uosc menu here
│   ├── mpv.conf                          
|   └── profiles.conf                     
|   
├── d3dcompiler_43.dll
├── mpv.com
├── mpv.exe                               # The mpv executable file
├── settings.xml                          # Created after initial run of updater.bat
├── updater.bat                           # Run with administrator privileges to update mpv
└── yt-dlp.exe                            
```

## Key Bindings
Custom key bindings can be added/edited in the [input.conf](https://github.com/Zabooby/mpv-config/blob/main/portable_config/input.conf) file. Refer to the [manual](https://mpv.io/manual/master/) and [uosc](https://github.com/tomasklaen/uosc#commands) commands for making any changes. Default key bindings can be seen from the [input.conf](https://github.com/Zabooby/mpv-config/blob/main/portable_config/input.conf) file but most of the player functions can be used through the menu accessed by `Right Click` and the buttons above the timeline as seen in the images above.

## Useful Links

* [mpv wiki](https://github.com/mpv-player/mpv/wiki) - Official wiki with links to all user scripts/shaders, FAQ's, discussions and much more.
    * [Awesome mpv](https://github.com/stax76/awesome-mpv) -  A curated list of the user resources in the wiki, listed in distinct sections for easier browsing.
* [mpv manual](https://mpv.io/manual/master/) - Lists and explains all the settings and configuration options available including video/audio settings, scripting, and countless other customisations.
* [To-do's](https://github.com/users/Zabooby/projects/1) - Just a list of things I'm currently testing, tracking or improving as well as major changes/improvements I've already implemented.