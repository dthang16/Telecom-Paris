"use strict"

function loadDoc()
{
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "text.txt");
    xhr.onload = function(){
        var textArea = document.getElementById("textarea");
        textArea.innerHTML = xhr.responseText;
        console.log(xhr.responseText);
    }
    xhr.send();
}

function loadDoc2()
{
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "text.txt");
    let textArea2 = document.getElementById("textarea2");
    xhr.onload = function(){
        let textfile = this.responseText;
        let lines = textfile.split("<br/>");
        for(let i in lines)
        {
            let p_tag = document.createElement("p");
            let randomColor = "#" + Math.floor(Math.random()*16777215).toString(16);
            p_tag.textContent = lines[i];
            p_tag.style.color = randomColor;
            textArea2.appendChild(p_tag);
        }
    }
    xhr.send();
}

