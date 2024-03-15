"use strict"

function sendMessage(){
    let xhr = new XMLHttpRequest();
    var textField = document.getElementById("textedit");
    var link = "chat.php?phrase=" + textField.value;
    textField.value="";
    xhr.open("GET", link);
    xhr.send();
}

setInterval(refreshChat, 1000);
function refreshChat(){
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "chatlog.txt");
    let textArea = document.getElementById("textarea");
    xhr.onload = function(){
        textArea.innerHTML = "";
        let textfile = this.responseText;
        let lines = textfile.split("\n");
        for(let i=lines.length - 1; i>=lines.length-11 && i>=0; i--)
        {
            if(lines[i]=="") continue;
            let p_tag = document.createElement("p");
            p_tag.innerHTML = lines[i];
            textArea.appendChild(p_tag);
        }
    }
    xhr.send();
}