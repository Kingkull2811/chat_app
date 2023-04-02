# chat_app

App chat

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

chatAppWeb
// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
apiKey: "AIzaSyDGD4HfInR7ybpXD7sYguYP-5j-U2vDQ80",
authDomain: "chatapp-97dbc.firebaseapp.com",
projectId: "chatapp-97dbc",
storageBucket: "chatapp-97dbc.appspot.com",
messagingSenderId: "103251286025",
appId: "1:103251286025:web:03d480e7b5bdae42f840d8"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);


//config using localhost for connect physic mobile device to mac IP:
//follow: https://stackoverflow.com/a/36605431
- get IP address mobile device
- get IP address mac: using command 'config'
- On MAC, open Terminal, run command 'sudo nano /etc/hosts'. 
- Enter password, add line '<ip mac>  <ip mobile device>' to end, Ctrl+X, Y, Enter to save
- note: mobile device and MAC must using share the same wifi network