"use strict"

export function wordc(input){
    let count = [];
    input = input.toLowerCase();
    let len = input.length;
    let i = 0;
    let k = -1;
    while(i<len)
    {
        if(input[i]==' ')
        {
            if(k!=i-1)
            {
                let word = input.substr(k + 1, i - k - 1);
                if(count[word] == undefined)
                {
                    count[word] = 1;
                }
                else{
                    count[word] += 1;
                }
            }
            k = i;
        }
        i++;
    }
    if(k!=i-1)
    {
        let word = input.substr(k + 1, i - k - 1);
        if(count[word] == undefined)
        {
            count[word] = 1;
        }
        else{
            count[word] += 1;
        }
    }    
    return count;
}

export class WordL{
    constructor(string){
        this.string = string;
        this.count = wordc(string);
    }
    getWords()
    {
        return Object.keys(this.count).sort();
    }

    maxCountWord()
    {
        let max_word = undefined;
        let max_count = undefined;
        for (let key in this.count)
        {
            let update = false;
            if(max_word==undefined)
            {
                update = true;
            }
            else if(max_count<this.count[key])
            {
                update = true;
            }
            else if((max_count==this.count[key])&&(max_word.localeCompare(key)==1))
            {
                update = true;
            }

            if(update)
            {
                max_word = key;
                max_count = this.count[key];
            }
        }
        return max_word;
    }

    minCountWord()
    {
        let min_word = undefined;
        let min_count = undefined;
        for (let key in this.count)
        {
            let update = false;
            if(min_word==undefined)
            {
                update = true;
            }
            else if(min_count>this.count[key])
            {
                update = true;
            }
            else if((min_count==this.count[key])&&(min_word.localeCompare(key)==1))
            {
                update = true;
            }
            
            if(update)
            {
                min_word = key;
                min_count = this.count[key];
            }
        }
        // if(min_count==undefined) min_count = 0;
        return min_word;
    }
    
    getCount(word)
    {
        if(this.count[word]==undefined)
        {
            return 0;
        }
        else return this.count[word];
    }
    applyWordFunc(f)
    {
        // console.log(Object.keys(this.count).sort());
        // let result = []
        // for (let key in Object.keys(this.count).sort())
        // {
        //     result[key] = f(key);
        // }
        let result = Object.keys(this.count).sort().map(f);
        return result;
    }
}