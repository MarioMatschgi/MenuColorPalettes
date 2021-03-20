# MenuColorPalettes

> For more information and the app-download take a look at my website [www.programario.at][website_article]
Found a bug? [Contact me][contact] 

## Table of content
| Table of content  |
| -- |
| [Overview](#overview) |
| [Screenshots](#screenshots) |
| [Tutorial](#tutorial) |
| [Download & Installation](#download--installation) |
| [Licence](#licence) |

<hr>

## Overview
### What is MenuColorPalettes?
MenuColorPalettes is a utility app for macOS for managing your colors. Whether you are a webdeveloper, gamedeveloper or UI designer, colors are very important and can be quiet frustrating to manage and organize. THIS is where MenuColorPalettes comes in.

### Requirements
Mac computer with macOS 11 (Big Sur) or higher

### Features
MenuColorPalettes is accessable via the macOS menubar. Just click the little MenuColorPalettes icon and a popover with all of your palettes will appear. Leftclick to view as many palettes as you desire.

![menu-item-view][menu-item-view]
> See the full page with more screenshots @ [www.programario.at/projects/mac-apps/menu-color-palettes][screenshots]

MenuColorPalettes is structured in color-palettes and colors.
* ColorPalettes: ColorPalettes are - as the name suggests - groups of colors
    * ColorPalettes can be imported from websites.
        > Currently the only website supported is [flatuicolors.com](https://flatuicolors.com)
    * ColorPalettes pop out into a seperate window which floats above everything so you can access your colors easily
* Colors: Colors are defined with a name and contain a color
    * Colors can be copied in many different formats ("r, g, b", "r, g, b, a", "hex" and more)
    * To copy a color leftclick it and it will get copied in the chosen format to your clipboard ready to paste
    * To prevent focussing the window hold the Command-key (CMD} [This is a macOS thing, so it works everywhere, not just MenuColorPalettes]

<hr>

## Screenshots
> See the full page with more screenshots @ [www.programario.at/projects/mac-apps/menu-color-palettes][screenshots]

| ![menu-item-view][menu-item-view] |
|:--:|
| *Menu item view* |

| ![palette-view][palette-view] |
|:--:|
| *Palette viewing window* |

| ![copy-formats][copy-formats] |
|:--:| 
| *Color formats to copy* |

<hr>

## Tutorial
Below you can find a guide which helps you getting started and some tips and tricks.
* Download the app
* Click the icon in the macOS menubar to reveal the menu-item-view-popover
* Create palettes by clicking the "+" icon. Rename/delete palettes by right-clicking a palette. If you rename a palette make sure to close the view window first. View a palette by left-clicking.
* Create colors by clicking the "+" icon. Edit/delete colors by right-clicking a color. Left-click to copy the color (Pro-Tip: hold CMD while left-clicking to prevent focusing the window). Change the format the color should be copied in with the "copy format" dropdown in the viewer window.
* To import colors view the palette you want your colors to be imported to and click "Show import". Paste your code into the appropriate text-field
    For FlatUIColors: Go to your FlatUIColors palette. Next view the page sourcecode (Process differs for different browsers) by right-clicking and choosing something like "view element" or "element information" or "view source". Then copy the HTML code of the div with the class "colors" - thats the code you have to paste into the text-field "FlatUIColors code".
    ![copy-div-colors](https://programario.at/lang/en/projects/mac-apps/Images/menu-color-palettes/copy-div-colors.png)

<hr>

## Download & Installation
Below is a guide for installation and download links for every version. I hope that you enjoy my work, if you want to report a bug just [contact me][contact].
### Installation
Download the .dmg file. Double-click (or right-click and choose "open"). Drag and drop the .app to the Applications folder.

### Download
> For the download visit  [www.programario.at/projects/mac-apps/menu-color-palettes][download]

<hr>

## Licence
This project is licenced under the [MIT-License](https://choosealicense.com/licenses/mit/).

Made with ❤️ by me, Mario Elsnig © 2020


<!--- LINKS -->
[contact]:              https://programario.at/#contact_me-intro
[website_article]:  https://programario.at/projects/mac-apps/menu-color-palettes
[screenshots]:      https://programario.at/projects/mac-apps/menu-color-palettes#screenshots
[download]:         https://programario.at/projects/mac-apps/menu-color-palettes#download__installation-download

<!--- IMAGES -->
[menu-item-view]:   https://programario.at/lang/en/projects/mac-apps/Images/menu-color-palettes/menu-item-view.png "Menu item view"
[palette-view]:         https://programario.at/lang/en/projects/mac-apps/Images/menu-color-palettes/palette-view.png        "Palette view"
[copy-formats]:       https://programario.at/lang/en/projects/mac-apps/Images/menu-color-palettes/copy-formats.png      "Copy formats"
