import {server as WebSocketServer} from 'websocket';
import express from "express"; 
import { argv } from "process";
import { readFileSync } from "fs";



const app = express();
const port_number = parseInt(argv[2]);
const server = app.listen(port_number, () => console.log('Example app listening on port '+ port_number + '!'));

app.get('/', (req, res) => res.send('Hello World!'));
app.get('/end', (req, res) => {
    try{
        res.send('The server will stop now');
        server.close();
    }
    catch(e)
    {
        console.error(e);
    }
});

const wsServer = new WebSocketServer({httpServer: server});
wsServer.on('request', processRequest);

function processRequest(request) {
    const connection = request.accept(null, request.origin);
    connection.on('message', (o) => connectionOnMessage.call(connection, o));
    connection.on('close', () => connectionOnClose.call(connection));
    connection.on('error', (o) => connectionOnError.call(connection, o));
}