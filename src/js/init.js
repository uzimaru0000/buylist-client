'use strict'

import { Elm } from '../Elm/Main.elm'
import firebase from 'firebase/app'
import 'firebase/auth'

export default () => {
    let flag = false;
    return x => {
        if (!flag) {
            const main = document.getElementById('main');
            const app = Elm.Main.init({
                node: main,
                flags: x
            });
            appPorting(app);
            flag = true;
        }
    };
};

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

    app.ports.signIn.subscribe(data => {
        const email = data[0];
        const pass = data[1];

        firebase.auth().signInWithEmailAndPassword(email, pass)
            .then(res => {
                if (res.user.emailVerified) {
                    app.ports.getUser.send(res.user);
                } else {
                    app.ports.message.send("Not Verified.");
                    firebase.auth().currentUser.sendEmailVerification();
                    firebase.auth().signOut();
                }
            })
            .catch(err => {
                app.ports.message.send(err.message);
            });
    });

    app.ports.signOut.subscribe(data => {
        firebase.auth().signOut()
            .then(() => {
                console.log("signOut");
                app.ports.successSignOut.send(null);
            });
    });
}
