"use strict";

import {createServer} from "http";
import {parse} from "url";
import { argv } from 'node:process';
import {readFileSync, writeFileSync, readFile} from 'fs';
import { unescape } from "querystring";

let port_number = parseInt(argv[2]);
let user_list = [];

class storage
{
    constructor(title, color, value){
        this.title = title;
        this.color = color;
        this.value = value;
    }
}

// request processing
function webserver( request, response ) {
    console.log(request);
    if(request.url=='/')
    {
        try{
            response.setHeader("Content-Type", "text/html; charset=utf-8");  
            response.end("<!doctype html><html><body>Server works!</body></html>");
        }
        catch(e)
        {
            console.error(e);
        }
    }

    else if(request.url=='/exit')
    {        
        try{
            response.setHeader("Content-Type", "text/html; charset=utf-8");  
            response.write('<html><body><p>The server will stop now.</p></body></html>');
            response.end();
            process.exit(0);
        }
        catch(e)
        {
            console.error(e);
        }
    }
    else if(request.url.substr(0,6)=='/Root/')
    {
        try{
            let filename = request.url.slice(6);
            let filename_type = filename.split(".");
            let type = filename_type[filename_type.length - 1].toLowerCase();
            let content_type;
            switch(type)
            {
                case 'html':
                    content_type = 'text/html; charset=utf-8'; break;
                case 'css':
                    content_type = 'text/css; charset=utf-8'; break;
                case 'js':
                    content_type = 'text/javascript; charset=utf-8'; break;
                case 'mjs':
                    content_type = 'text/javascript; charset=utf-8'; break;
                case 'json':
                    content_type = 'application/json; charset=utf-8'; break;
                case 'png':
                    content_type = 'image/png'; break;
                case 'jpeg':
                    content_type = 'image/jpeg'; break;
                case 'jpg':
                    content_type = 'image/jpeg'; break;
                case 'svg':
                    content_type = 'image/svg+xml';
            }
    
    
            readFile(filename, "binary", function(err, file) {
                if(err) {    
                    response.writeHeader(404, {"Content-Type": "text/plain"});    
                    response.write(err + "\n");    
                    response.end();    
                }
                else if(type==undefined)
                {
                    response.writeHeader(404, {"Content-Type": "text/plain"});    
                    response.write("File type not specified\n");    
                    response.end();               
                }
                else{
                    response.writeHeader(200, {'Content-Type': content_type});    
                    response.write(file, "binary");    
                    response.end();  
                }
           });
        }
        catch(e)
        {
            console.error(e);
        }
    }

    else if(request.url.substr(0,6)=='/Items')
    {
        try{
            readFile('storage.json', "binary", function(err, file) {
                if(err) {    
                    response.writeHeader(404, {"Content-Type": "text/plain"});    
                    response.write(err + "\n");    
                    response.end();    
                }
                else{
                    response.writeHeader(200, {'Content-Type': 'application/json'});    
                    response.write(file, "binary");    
                    response.end();  
                }
           });
        }
        catch(e)
        {
            console.error(e);
        }
    }

    else if(request.url.substr(0,4)=='/add')
    {
        try{
            // let input_string = request.url.replace('/add?','');
            // let title = input_string.substring(input_string.indexOf('title=')+6,input_string.indexOf('&',input_string.indexOf('title=')));
            // let color = input_string.substring(input_string.indexOf('color=')+6,input_string.indexOf('&',input_string.indexOf('color=')));
            // let value = input_string.substring(input_string.indexOf('value=')+6,input_string.length);

            let parameters = parse(request.url, true).query;
            let title = parameters.title;
            let color = parameters.color;
            let value = parseInt(parameters.value);

            let storage_data = JSON.parse(readFileSync('storage.json', 'utf-8'));
            storage_data.push(new storage(title, color, value));
            writeFileSync('storage.json', JSON.stringify(storage_data));
            response.end();
        }
        catch(e)
        {
            console.error(e);
        }
    }
    else if(request.url.substr(0,7)=='/remove')
    {
        try{
            let index = request.url.slice(14);
            console.log(index);
            let storage_data = JSON.parse(readFileSync('storage.json', 'utf-8'));
            storage_data.splice(index, 1);
            writeFileSync('storage.json', JSON.stringify(storage_data));
            response.end();
        }
        catch(e)
        {
            console.error(e);
        }
    }
    else if(request.url.substr(0,6)=='/clear')
    {
        try{
            let new_data = '[{"title": "empty", "color": "red", "value": 1}]';
            writeFileSync('storage.json', new_data);
            response.end();
        }
        catch(e)
        {
            console.error(e);
        }
    }
    else if(request.url.substr(0,8)=='/restore')
    {
        try{
            let new_data = '[{"title": "foo", "color": "red", "value": 20}, {"title": "bar", "color": "ivory", "value": 100}, {"title": "bart", "color": "blue", "value": 60}]';
            writeFileSync('storage.json', new_data);
            response.end();
        }
        catch(e)
        {
            console.error(e);
        }
    }
    else if(request.url.substr(0,9)=='/PieChart')
    {
        try{
            let svg = drawPie();
            response.writeHeader(200, {'Content-Type': 'image/svg+xml'});
            response.write(svg, 'binary');
            response.end();
        }
        catch(e)
        {
            console.error(e);
        }
    }
}

function drawPie()
{
    let storage_data = JSON.parse(readFileSync('storage.json', 'utf-8'));
    let sum_value = 0;
    for (let i in storage_data)
    {
        sum_value += storage_data[i].value;
    }
    let start_angle = 0;
    var svgNS = "http://www.w3.org/2000/svg"
    let svg = document.createElementNS(svgNS, "svg");
    svg.setAttribute("height", 1000);
    svg.setAttribute("width", 1000);
    for (let i in storage_data)
    {
        storage_data[i].angle = start_angle + storage_data[i].value/sum_value;
        start_angle = storage_data[i].angle;
        let path = document.createElementNS(svgNS, "path");
        let start_x = 500*(1-Math.cos(storage_data[i].angle*2*Math.PI));
        let start_y = 500*(1+Math.sin(storage_data[i].angle*2*Math.PI));
        let end_x = 500*(1-Math.cos((storage_data[i].angle+storage_data[i].value/sum_value)*2*Math.PI));
        let end_y = 500*(1+Math.sin((storage_data[i].angle+storage_data[i].value/sum_value)*2*Math.PI));
    
        path.setAttribute('d', 'M 500 500 L' + start_x + start_y + 'A 500 500 0 0 1' + end_x + end_y + 'Z');
        path.setAttribute('fill', storage_data[i].color);
        svg.appendChild(path);
    
        let text_label = document.createElementNS(svgNS, 'text');
        text_label.setAttribute("x", 500 - 300*Math.cos((storage_data[i].angle + storage_data[i].value/sum_value/2)*2*Math.PI));
        text_label.setAttribute("y", 500 + 300*Math.sin((storage_data[i].angle + storage_data[i].value/sum_value/2)*2*Math.PI));
        text_label.textContent = storage_data[i].title;
        svg.appendChild(text_label);
    }
    return svg;
}

// server object creation
const server = createServer(webserver);

// server listens
server.listen(port_number, (err) => {});
