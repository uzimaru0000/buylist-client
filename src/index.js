'use struct'

import './index.html'
import init from './js/init'
import firebase from 'firebase/app'
import 'firebase/auth'

const config = {
    apiKey: "AIzaSyBcgERQ1HL5iyKHtpRkgetby1YnH3pXhow",
    authDomain: "buylist-2a685.firebaseapp.com",
    databaseURL: "https://buylist-2a685.firebaseio.com",
    projectId: "buylist-2a685",
    storageBucket: "buylist-2a685.appspot.com",
    messagingSenderId: "528674496313"
};
firebase.initializeApp(config);


firebase.auth().onAuthStateChanged(init());