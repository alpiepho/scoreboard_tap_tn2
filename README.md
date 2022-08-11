## Get Application
Version: 2.0

GH-Pages site: https://alpiepho.github.io/scoreboard_tap_tn2/

or QR Code:

![QR Code](./assets/qr-code-tap.png)

## scoreboard_tap_tn2
Flutter app to display ScoresTN2 (scorebaord_tn2) data from a ScoresReflectorTN2 (scoreboard_reflector_tm2)

The ScoresTN2 is a PWA for scoring youth sports, like volleyball.  Typically, one person keeps score on a smart phone, flashing the on going score to a video recording, or to other spectators.

Two problems occur:
1. The score keeper may not always show the score
2. The display on the phone may not be large enough

This application monitors a reflector that is populated by the ScoresTN2 application.  This allows this application to display a running update of one or more games.

NOTE: Since the first use is for Volleyball, there may be Volleyball specifics within the application.

## "Install" on iPhone

This application is a Web application known as a PWA (progressive web application).  It is possible to add a PWA to the home screen of an iPhone
like it is a downloaded application (there is a similare mechanism for Android that is not discused here).  Use the following steps:

TODO: need new images

1. Open the above link in Safari and click on up-arrow

![Step1](./iphone_install1.png)

2. Click on "Add to Home Screen"

![Step2](./iphone_install2.png)

3. Select "Add"

![Step3](./iphone_install3.png)


### Known Issue

A PWA on iPhone requires internet access to launch the first time.  However, once it is running, the application will work fine without and an internet connection.

## About

TODO: Update for tap

My flutter version of a Scoreboard application.

This application was built to better learn Flutter and Dart.  The world really doesn't need another simple scoring application, but attempting to duplicate how several of these common applications work, provided a way to learn many things:

- Flutter itself
- Flutter web applications as a PWA
- Learn about some of it's short commings with respect to a Google Lighthouse score
- Arranging cards
- Gesture detection and processing
- Modal dialogs
- Color Pickers
- Google fonts within Flutter
- Persistent Data
- Several other areas

These are all areas that I hope to take forward into other applications.  Flutter is fun.

## Basic Usages

TODO: Update for tap

The application from the above URL will open a respoonsive web page.  It is best viewed on a mobile phone with the most testing on and iPhoneX.  If opened on iPhone Safari, you can used the middle bottom button to add to the Home Screen (as a PWA).

The application opens with two large colored buttons for two teams.  Tapping either will icrement their score.  Swiping up will increment the score.  Swiping down will decrement with a limit at 0.  The Gear button will open a settings dialog.

The settings dialog allows some quick actions from icons at the top: clear scores, swap teams, and a done checkmark to save settings listed below.  All saved settings are added to the persistent storage so the next launch will read them and the user can pick up where they left off.

Other settings allow changing the team names, adjusting scores, and picking colors for the team text and background.

At the bottom are a number of predefined fonts.  These are like the top icons, and will immediately be saved.

Below are some lists of things yet to do and possible future changes.

Thanks for trying out this applications.

## Todo and Future Changes
- [x] copy and modify for tap
- [x] review/update README
- [ ] new install images
- [x] fix QR
- [x] strip down settings page
- [x] strip down engine
- [x] remove gesture from boxes
- [x] add refesh button
- [ ] settings for stream mode
- [ ] stream page
- [ ] stream text
- [ ] stream color
- [ ] latest only
- [x] read from reflector
- [x] show comment with dialog
- [x] send comments?
- [x] think about security of sending comments
- [x] review/clear commented out code

- [ ] show QR for this app
- [ ] show QR for ScoresTN2
- [ ] add shows to ScoresTN2

- [ ] build ios
- [ ] ios developer install
- [ ] ios store?

## How to outline Repaint

<pre>
void main() {
  // --> debugRepaintRainbowEnabled = true;
  runApp(Scoreboard());
}
</pre>


## REFERENCES

Icons created with https://appicon.co/  NOTE: original image should be square to avoid white edges on IOS Home screen.

QR code generated with https://www.the-qrcode-generator.com/.  Used screen capture to save qrocode.png and copied file here.

- https://github.com/alpiepho/scoreboard_tn2
- https://github.com/alpiepho/scoreboard_reflector_tn2
- https://github.com/alpiepho/scoreboard_tap_tn2

