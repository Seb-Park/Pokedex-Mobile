# Mobile Pokédex

A machine learning Pokédex for 151 Kanto Pokémon. Trained on the first 22.

## Installation

Clone or download the git repository.

```bash
git clone https://github.com/Seb-Park/Pokedex-Mobile.git
```

Open with vscode, Android studio, or other Flutter compatible Text Editor or IDE. 

The Pokémon Classifier is not yet publicly hosted, so you will also need to install the [Pokémon Classifier](https://github.com/Seb-Park/Pokemon-Classifier-Net) and run the Flask server on your network. You will need Tensorflow 1.15 and Flask installed on your machine to run this classifier server. Cd into the cloned/downloaded master directory and run:
```bash
$ python3 -m scripts.label_image_flask --graph=tf_files/retrained_graph.pb
```

Find the local ip of the machine you're using to run the Flask API and change line 124 of 'Camera.dart' to match that ip with port 3008.

```dart
  var res = await http.get("http://YOUR.IP.ADDRESS.HERE:3008/?img=" + urlImagePath);
```

Plug in your device and run the code once the device is connected to the computer. Note that you will need XCode to run on an iOS device.

You can use:
```bash
flutter run
```

## Usage
Once you have installed the application on your mobile device, you can scroll through the different Kanto Pokémon and click on each one to see its information. From the home page, you can also click the shutter icon at the bottom and open the camera. You can take pictures of Pokémon here, and the app should make an api call to your local server and the server will send back the appropriate Pokémon data, and once the name of the classified Pokémon is displayed in green on the top, you can click the teal arrow in the bottom right corner of the screen and view the Pokémon's information there.

## Contributing
Feel free to make updates to the app or to the neural net to make the classification more accurate! Also, scraping the internet for more images would be much appreciated.

## Credits
The home page was created loosely following the MTECHVIRAL tutorial on youtube. 

## License
[MIT](https://choosealicense.com/licenses/mit/)
