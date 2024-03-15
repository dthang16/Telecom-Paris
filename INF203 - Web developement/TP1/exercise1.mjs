"use strict";

// no recursion
export function fibo_it(n) {
    if(n==0) return 0;
    if(n==1) return 1;

    let a = 0;
    let b = 1;

    for(let i = 2; i <= n; i++)
    {
        if(i%2==0)
        {
            a = a + b;
        }
        else{
            b = a + b;
        }
    }
    return Math.max(a, b);
}

// recursive function
export function fibonaRec(n) {
    if(n==0) return 0;
    if(n==1) return 1;

    return fibonaRec(n-1) + fibonaRec(n-2);
}

// no map function
export function fibo_arr(t) {
    let array = [];
    for (let i = 0; i< t.length; i++)
    {
        array.push(fibo_it(t[i]));
    }
    return array;
}

// use of map
export function fibMap(t) {
    return t.map(x => fibo_it(x));
}