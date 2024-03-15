"use strict"

export class Stud
{
    constructor(lastName, firstName, id)
    {
        this.lastName = lastName;
        this.firstName = firstName;
        this.id = id;
    }
    toString()
    {
        var return_string = "student: " + this.lastName + ", " + this.firstName + ", " + this.id;
        return return_string; 
    }

}

export class ForStudent extends Stud
{
    constructor(lastName, firstName, id, nationality)
    {
        super(lastName, firstName, id);
        this.nationality = nationality;
    }
    toString()
    {
        var return_string = super.toString() + ", " + this.nationality;
        return return_string;
    }
}

