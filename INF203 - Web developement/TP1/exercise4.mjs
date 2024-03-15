"use strict"

import {Stud, ForStudent} from "./exercise3.mjs";

import {readFileSync, writeFileSync} from 'node:fs';

export class Prmtn
{
    constructor()
    {
        this.promotion_list = [];
    }
    add(student)
    {
        this.promotion_list.push(student);
    }
    size()
    {
        return this.promotion_list.length;
    }
    get(i)
    {
        return this.promotion_list[i];
    }
    print()
    {
        let print_string = "";
        for (let student in this.promotion_list)
        {
            print_string = print_string + student.toString() + "\n";
        }
        // print_string.slice(0, -1);
        console.log(print_string);
        return print_string;
    }
    write()
    {
        return JSON.stringify(this.promotion_list);
    }
    read(str)
    {
        let list = JSON.parse(str);
        this.promotion_list = [];
        for (let i in list)
        {
            let student = list[i];
            if(student.nationality==undefined)
            {
                this.add(new Stud(student.lastName, student.firstName, student.id));
            }
            else
            {
                this.add(new ForStudent(student.lastName, student.firstName, student.id, student.nationality));
            }
        }
    }

    saveToFile(fileName)
    {
        try{
            writeFileSync(fileName, this.write());
        }
        catch(err)
        {
            console.log(err);
        }

    }
    readFromFile(fileName)
    {
        try{
            var data = readFileSync(fileName, 'utf8')
            this.read(data);
        }
        catch(err)
        {
            console.log(err);
        }
    }
}