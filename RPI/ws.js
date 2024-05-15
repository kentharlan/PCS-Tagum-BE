const WebSocket = require('ws');

class Ws {
    static rpi1 = null;
    static rpi2 = null;

    static async init1() {
        try {
            if (!Ws.rpi1 || Ws.rpi1.readyState !== WebSocket.OPEN) {
                Ws.rpi1 = new WebSocket(`ws://${process.env.RPI1_IP}:${process.env.RPI1_PORT}`);

                Ws.rpi1.on('open', function () {
                    console.log('Connected to RPI 1 server');
                });

                Ws.rpi1.on('close', function () {
                    console.log(`RPI 1 disconnected.`);
                    Ws.rpi1 = null;   
                });

                Ws.rpi1.on('error', function () {
                    console.log(`Failed connecting to RPI 1.`);
                    Ws.rpi1 = null; 
                });
            }

            return Ws.rpi1
        } catch (error) {
            console.log(`Failed connecting to RPI 1`);
        }
    }

    static async init2() {
        try {
            if (!Ws.rpi2 || Ws.rpi2.readyState !== WebSocket.OPEN) {
                Ws.rpi2 = new WebSocket(`ws://${process.env.RPI2_IP}:${process.env.RPI2_PORT}`);

                Ws.rpi2.on('open', function () {
                    console.log('Connected to RPI 2 server');
                });

                Ws.rpi2.on('close', function () {
                    console.log(`RPI 2 disconnected.`);
                    Ws.rpi2 = null;   
                });

                Ws.rpi2.on('error', function () {
                    console.log(`Failed connecting to RPI 2.`);
                    Ws.rpi2 = null; 
                });
            }

            return Ws.rpi2
        } catch (error) {
            console.log(`Failed connecting to RPI 2`);
        }
    }

    static async sendCommand(RPI, commands) {
        let rpi
        switch(RPI) {
            case 1: rpi = await this.init1(); break;
            case 2: rpi = await this.init2(); break;
        }

        if (rpi && rpi.readyState === WebSocket.OPEN) {
            rpi.send(commands);
        } else {
            console.log('WebSocket not open');
        }
    }

    static async generateRPICommand(room, status) {
        let GPIO, RPI
        const rpi = room / 24;

        if (rpi <= 1) {
            RPI = 1
            switch(room_no) {
                case 1: GPIO = 4; break;
                case 2: GPIO = 15; break;
                case 3: GPIO = 18; break;
                case 4: GPIO = 22; break;
                case 5: GPIO = 24; break;
                case 6: GPIO = 9; break;
                case 7: GPIO = 11; break;
                case 8: GPIO = 7; break;
                case 9: GPIO = 5; break;
                case 10: GPIO = 8; break;
                case 11: GPIO = 25; break;
                case 12: GPIO = 10; break;
                case 13: GPIO = 23; break;
                case 14: GPIO = 27; break;
                case 15: GPIO = 17; break;
                case 16: GPIO = 14; break;
                case 17: GPIO = 6; break;
                case 18: GPIO = 13; break;
                case 19: GPIO = 16; break;
                case 20: GPIO = 20; break;
                case 21: GPIO = 21; break;
                case 22: GPIO = 26; break;
                case 23: GPIO = 19; break;
                case 24: GPIO = 12; break;
            }
          } else if (rpi <= 2) {
            RPI = 2
            switch(room_no) {
                case 25: GPIO = 6; break;
                case 26: GPIO = 13; break;
                case 27: GPIO = 16; break;
                case 28: GPIO = 20; break;
                case 29: GPIO = 21; break;
                case 30: GPIO = 26; break;
                case 31: GPIO = 19; break;
                case 32: GPIO = 12; break;
                case 33: GPIO = 4; break;
                case 34: GPIO = 15; break;
                case 35: GPIO = 18; break;
                case 36: GPIO = 22; break;
                case 37: GPIO = 24; break;
                case 38: GPIO = 9; break;
                case 39: GPIO = 11; break;
                case 40: GPIO = 7; break;
                case 41: GPIO = 5; break;
                case 42: GPIO = 8; break;
                case 43: GPIO = 25; break;
                case 44: GPIO = 10; break;
                case 45: GPIO = 23; break;
                case 46: GPIO = 27; break;
                case 47: GPIO = 17; break;
                case 48: GPIO = 14; break;
            }
          }

        const state = status === 2 ? "dl" : "dh";
        const command = `raspi-gpio set ${GPIO} op ${state}`
        return { RPI, command }
    }
}

module.exports = {
    Ws
}
