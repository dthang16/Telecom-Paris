"use strict"


var pause_flag = true;
var slides;
var slide_position;

function play()
{
    if(pause_flag) pause_flag = false;
    for (let i in slides.timer)
    {
        clearTimeout(slides.timer[i]);
    }
    slides.timer = [];

    for(let i in slides.slides)
    {
        slides.timer.push(setTimeout(display, slides.slides[i].time*1000, slides.slides[i].url, i));
    }
    console.log(slides.timer);
}


function display(url, i)
{
    slide_position = i;
    var iframe = document.createElement("iframe");
    var main_div = document.getElementById("MAIN");
    main_div.innerHTML="";
    iframe.src = url;
    iframe.width = "100%";
    iframe.height = "100%";
    main_div.appendChild(iframe);
}

function load(){
    let xhr = new XMLHttpRequest();
    xhr.open("GET", "slides.json");
    xhr.onload = function(){
        slides = JSON.parse(this.responseText);
        slides.timer = [];
    }
    xhr.send();
}

load();

function pause()
{
    if(pause_flag==false)
    {
        console.log('Set pause to false');
        for (let i in slides.timer)
        {
            clearTimeout(slides.timer[i]);
            console.log(slides.timer);
        }
        slides.timer = [];
        pause_flag = true;
    }
    else
    {
        if(slide_position==undefined)
        {
            play();
        }
        else{
            for(let i in slides.slides)
            {
                if(i>slide_position)
                {
                    slides.timer.push(setTimeout(display, (slides.slides[i].time - slides.slides[slide_position].time)*1000, slides.slides[i].url, i));
                }
            }
            pause_flag = false; 
        }

    }
}

function nextSlide()
{
    if(pause_flag==false)
    {
        for (let i in slides.timer)
        {
            clearTimeout(slides.timer[i]);
        }
        slides.timer = [];
        pause_flag = true;
    }
    if(slide_position==undefined)
    {
        display(slides.slides[0].url, 0);
    }
    else{
        let next_position = slide_position + 1;
        if(slides.slides[next_position]==undefined)
        {
            return;
        }
        else
        {
            display(slides.slides[next_position].url, next_position);
        }
    }
}

function prevSlide()
{
    if(pause_flag==false)
    {
        for (let i in slides.timer)
        {
            clearTimeout(slides.timer[i]);
        }
        slides.timer = [];
        pause_flag = true;
    }
    if(slide_position==undefined || slide_position == 0)
    {
        return;
    }
    else
    {
        let next_position = slide_position - 1;
        display(slides.slides[next_position].url, next_position);
    }
}