import Quagga from 'quagga'

export default {
    init: () => {
        const display = document.getElementById('quagga-display');

        Quagga.init({
            inputStream: {
                type: 'LiveStream',
                constraints: {
                    width: { min: 640 },
                    height: { min: 480 },
                    facingMode: "environment",
                    aspectRatio: { min: 1, max: 100 }
                },
                target: display,
                numOfWorker: navigator.hardwareConcurrency,
                locator: {
                    patchSize: "medium",
                    halfSample: true
                }
            },
            decoder: {
                readers: ['ean_reader']
            }
        }, err => {
            if (err) {
                console.error(err);
                return;
            }

            console.log("Quagga init");
            Quagga.start();
        });
    },
    onProcessed: callback => {
        Quagga.onProcessed(callback);
    },
    onDetected: callback => {
        Quagga.onDetected(callback);
    }
}
