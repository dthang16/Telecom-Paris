"use strict"

function play()
{
    let xhr = new XMLHttpRequest();
    xhr.open("GET", "slides.json");
    xhr.onload = function(){
        let slides = JSON.parse(this.responseText);
        for(let i in slides.slides)
        {
            setTimeout(display, slides.slides[i].time*1000, slides.slides[i].url)
        }
    }
    xhr.send();
}

function display(url)
{
    var iframe = document.createElement("iframe");
    var main_div = document.getElementById("MAIN");
    main_div.innerHTML="";
    iframe.src = url;
    iframe.width = "100%";
    iframe.height = "100%";
    main_div.appendChild(iframe);
}

