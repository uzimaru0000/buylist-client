'use struct'

import './index.html'
import Elm from './Elm/Main.elm'
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

firebase.auth().onAuthStateChanged(x => {
    if (x) {
        if (!x.emailVerified) x.sendEmailVerification();
        else {
            const main = document.getElementById('main');
            const app = Elm.Elm.Main.init({
                node: main
            });
            appPorting(app);
        }
    }
});

const appPorting = app => {
    app.ports.createUser.subscribe(data => {
        const email = data[0];
        const pass = data[1];

        firebase.auth().createUserWithEmailAndPassword(email, pass)
            .then(_ => {
                firebase.auth().currentUser.sendEmailVerification();
                firebase.auth().signOut();
                app.ports.message.send("Success");
            })
            .catch(_ => {
                app.ports.message.send("Error");
            });
    });

    app.ports.signUp.subscribe(data => {
        const email = data[0];
        const pass = data[1];

        firebase.auth().signInWithEmailAndPassword(email, pass)
            .then(_ => {
                app.ports.message.send("Success");
            })
            .catch(err => {
                app.ports.message.send("Error");
                console.log("signUp : " + err);
            });
    });
}