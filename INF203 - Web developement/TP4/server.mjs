"use strict";

import {createServer} from "http";
import { argv } from 'node:process';
import {readFile} from 'fs';
import { unescape } from "querystring";

let port_number = parseInt(argv[2]);
let user_list = [];

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

    else if(request.url=='/kill')
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
    else if(request.url.substr(0,6)=='/root/')
    {
        try{
            let filename = request.url.slice(6);
            let filename_type = filename.split(".");
            let type = filename_type[filename_type.length - 1].toLowerCase();
            let content_type;
            switch(type)
            {
                case 'html':
                    content_type = 'text/html'; break;
                case 'css':
                    content_type = 'text/css'; break;
                case 'js':
                    content_type = 'application/javascript'; break;
                case 'mjs':
                    content_type = 'application/javascript'; break;
                case 'json':
                    content_type = 'application/json'; break;
                case 'png':
                    content_type = 'image/png'; break;
                case 'jpeg':
                    content_type = 'image/jpeg'; break;
                case 'jpg':
                    content_type = 'image/jpeg';
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
    else if(request.url.substr(0, 16)=='/hello?visiteur=')
    {
        try{
            let visitor = unescape(request.url.substr(16));
            response.writeHeader(200, {'Content-Type': "text/html; charset=utf-8"});    
            response.write('<html><body><p>hello ' + visitor +'.</p></body></html>');
            response.end();  
        }
        catch(e)
        {
            console.error(e);
        }
    }
    else if(request.url.substr(0, 14)=='/bonsoir?user=')
    {
        try{
            let user = unescape(request.url.substr(14));
            user = user.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;').replaceAll("'", '&#x27;');
            response.writeHeader(200, {'Content-Type': "text/html; charset=utf-8"});
            let html_content = 'bonsoir ' + user + ', the following users have already visited this page: ';
            for (let i in user_list)
            {
                if(i==0)
                {
                    html_content += user_list[i];
                }
                else
                {
                    html_content += ', ' + user_list[i];
                }
            }
            user_list.push(user);
            console.log('User list: ', user_list);
            response.write('<html><body><p>' + html_content + '</p></body></html>');
            response.end();  
        }
        catch(e)
        {
            console.error(e);
        }
    }
    else if(request.url=='/clear')
    {
        try{
            user_list = [];
            response.writeHeader(200, {'Content-Type': "text/html; charset=utf-8"});    
            response.write('<html><body><p>Clear username.</p></body></html>');
            response.end();  
        }
        catch(e)
        {
            console.error(e);
        }
    }

}

// server object creation
const server = createServer(webserver);

// server listens
server.listen(port_number, (err) => {});

