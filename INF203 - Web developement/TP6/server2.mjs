"use strict";

import express from "express"; 
import logger from "morgan";
import { argv } from "process";
import { readFileSync } from "fs";

const app = express();
const port_number = parseInt(argv[2]);
app.use(logger('combined'));
app.use(express.json());

var db = JSON.parse(readFileSync('db.json', 'utf-8'));

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

app.get('/restore', (req, res) => {
    try{
        db = JSON.parse(readFileSync('db.json', 'utf-8'));
        res.setHeader("Content-Type", "text/plain");  
        res.write('db.json reloaded');
        res.end(); 
    }
    catch(e)
    {
        console.error(e);
    }

})

app.get('/papers', (req, res) => {
    try{
        res.setHeader("Content-Type", "text/plain");  
        res.write(db.length.toString());
        res.end(); 
    }
    catch(e)
    {
        console.error(e);
    }
})
app.get('/byauthor/:author', (req, res) => {
    try{
        let count = 0;
        let author_param = req.params.author.toLowerCase();
        for(let i in db)
        {
            for(let j in db[i].authors)
            {
                let author_name = (db[i].authors)[j].toLowerCase();
                if (author_name.includes(author_param))
                {
                    count += 1;
                    break;
                }
            }
        }
        res.setHeader("Content-Type", "text/plain");  
        res.write(count.toString());
        res.end(); 
    }
    catch(e)
    {
        console.error(e);
    }
})

app.get('/papersdesc/:author', (req, res) => {
    try{
        let papers_desc = [];
        let author_param = req.params.author.toLowerCase();
        for(let i in db)
        {
            for(let j in db[i].authors)
            {
                let author_name = (db[i].authors)[j].toLowerCase();
                if (author_name.includes(author_param))
                {
                    papers_desc.push(db[i]);
                    break;
                }
            }
        }
        res.setHeader("Content-Type", "application/json; charset=utf-8");  
        res.write(JSON.stringify(papers_desc));
        res.end();
    }
    catch(e)
    {
        console.error(e);
    }
})

app.get('/ttlist/:author', (req, res) => {
    try{
        let papers_title = [];
        let author_param = req.params.author.toLowerCase();
        for(let i in db)
        {
            for(let j in db[i].authors)
            {
                let author_name = (db[i].authors)[j].toLowerCase();
                if (author_name.includes(author_param))
                {
                    papers_title.push(db[i].title);
                    break;
                }
            }
        }
        res.setHeader("Content-Type", "application/json; charset=utf-8");  
        res.write(JSON.stringify(papers_title));
        res.end();
    }
    catch(e)
    {
        console.error(e);
    }
})

app.get('/ref/:key', (req, res) => {
    try{
        let papers_desc;
        let key_param = req.params.key;
        for(let i in db)
        {
            if(db[i].key == key_param)
            {
                papers_desc = db[i];
                break;
            } 
        }
        res.setHeader("Content-Type", "application/json; charset=utf-8");  
        res.write(JSON.stringify(papers_desc));
        res.end();
    }
    catch(e)
    {
        console.error(e);
    }
})

app.delete('/ref/:key', (req, res) =>{
    try{
        let key_param = req.params.key;
        db = db.filter(paper => paper.key != key_param);
        res.setHeader("Content-Type", "text/plain");  
        res.write('DELETE request sent to server');
        res.end();
    }
    catch(e)
    {
        console.error(e);
    }
})

app.post('/ref', (req, res) => {
    try{
        let add_paper = req.body;
        add_paper.key = 'imaginary';
        db.push(add_paper);
        res.send('Paper has been added');
    }
    catch(e)
    {
        console.error(e);
    }
})

app.put('/ref/:xxx', (req, res) => {
    try{
        let key_param = req.params.xxx;
        let modified_paper = req.body;
        for(let i in db)
        {
            if(db[i].key == key_param)
            {
                for(let j in Object.keys(modified_paper))
                {
                    let field = Object.keys(modified_paper)[j];
                    db[i][field] = modified_paper[field];
                }
            }
        }
        res.send('PUT request was sent to server');
    }
    catch(e)
    {
        console.error(e);
    }
})
// start server
const server = app.listen(port_number, () => console.log('Example app listening on port '+ port_number + '!'));