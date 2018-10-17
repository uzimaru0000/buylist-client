'use strict'

import { Elm } from '../Elm/Main.elm'
import firebase from 'firebase/app'
import 'firebase/auth'

export default () => {
    let flag = false;
    return x => {
        console.log(x);
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
                app.ports.getUser.send(res.user);
                localStorage.setItem('jwt', res.user.qa);
            })
            .catch(err => {
                app.ports.message.send("Error");
                console.log("signUp : " + err);
            });
    });

    app.ports.signOut.subscribe(data => {
        firebase.auth().signOut()
            .then(() => {
                localStorage.removeItem('jwt');
                console.log("signOut");
                app.ports.successSignOut.send(null);
                console.log(app);
            });
    });

    app.ports.alert.subscribe(msg => alert(msg));
}