'use strict'

import { Elm } from '../Elm/Main.elm'
import firebase from 'firebase/app'
import 'firebase/auth'
import barcode from './barcode'
import Quagga from 'quagga'

export default () => {
    let flag = false;
    return x => {
        if (!flag) {
            console.log(x);
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
    let isQuaggaStart = false;

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

    app.ports.readCode.subscribe(_ => {
        barcode.init();
        isQuaggaStart = true;
        barcode.onProcessed(result => {
            const ctx = Quagga.canvas.ctx.overlay;
            const canvas = Quagga.canvas.dom.overlay;
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.fillStyle = "rgba(0, 0, 0, 0.5)";
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            ctx.clearRect(canvas.width * 0.1,
                          canvas.height * 0.1,
                          canvas.width * 0.8,
                          canvas.height * 0.8
                      );

            if (!result) return;

            if (result.boxes) {
                result.boxes
                    .filter(x => x !== result.box)
                    .forEach(box => {
                        Quagga.ImageDebug.drawPath(box, { x: 0, y: 1 }, ctx, { color: 'green', lineWidth: 2 });
                    });
            }

            if (result.box) {
                Quagga.ImageDebug.drawPath(result.box, { x: 0, y: 1 }, ctx, { color: 'blue', lineWidth: 2 })
            }

            if (result.codeResult && result.codeResult.code) {
                Quagga.ImageDebug.drawPath(result.line, { x: 'x', y: 'y' }, ctx, { color: 'red', lineWidth: 3 })
            }
        });
        barcode.onDetected((() => {
            let currentCode;
            return result => {
                const code = result.codeResult.code;
                if (currentCode !== code) {
                    Quagga.stop();
                    app.ports.getCode.send(parseInt(code));
                    currentCode = code;
                }
            }
        })());
    });

    app.ports.stopReadCode.subscribe(_ => {
        if (isQuaggaStart) {
            Quagga.stop();
            isQuaggaStart = false;
        }
    });
}
