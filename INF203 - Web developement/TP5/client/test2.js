"use strict"

var display_space = document.getElementById("MAINSHOW");

class storage
{
    constructor(title, color, value){
        this.title = title;
        this.color = color;
        this.value = value;
    }
}

function showText()
{
    let xhr = new XMLHttpRequest();
    xhr.open("GET", '../../Items');
    xhr.onload = function(){
        let file = this.responseText;
        display_space.innerHTML = file;
    }
    xhr.send();
}

// document.getElementById("SHOW_BUTTON").addEventListener("click", showText);
// function showText()
// {
//     window.location.href = '../../Items';
// }

document.getElementById("CLEAR").addEventListener("click", clearStorage);
function clearStorage()
{
    window.location.href = '../../clear';
}

document.getElementById("RESTORE").addEventListener("click", restoreStorage);
function restoreStorage()
{
    window.location.href = '../../restore';
}

document.getElementById("PIEB").addEventListener("click", showPie);
function showPie()
{
    window.location.href = '../../PieChart';
}

function showAddForm()
{
    display_space.innerHTML = '';

    let form_tag = document.createElement('form');
    let div_tag = document.createElement('div');
    let label_tag = document.createElement('label');
    label_tag.setAttribute('for', 'title');
    label_tag.innerHTML = 'Title';
    let input_tag = document.createElement('input');
    input_tag.setAttribute('type', 'text');
    input_tag.setAttribute('name', 'title');
    input_tag.setAttribute('id', 'titleTF');
    input_tag.required = true;
    div_tag.appendChild(label_tag);
    div_tag.appendChild(input_tag);
    form_tag.appendChild(div_tag);

    let div_tag2 = document.createElement('div');
    let label_tag2 = document.createElement('label');
    let input_tag2 = document.createElement('input');
    label_tag2.setAttribute('for', 'color');
    label_tag2.innerHTML = 'Color';
    input_tag2.setAttribute('type', 'text');
    input_tag2.setAttribute('name', 'color');
    input_tag2.setAttribute('id', 'colorTF');
    div_tag2.appendChild(label_tag2);
    div_tag2.appendChild(input_tag2);
    form_tag.appendChild(div_tag2);

    let div_tag3 = document.createElement('div');
    let label_tag3 = document.createElement('label');
    let input_tag3 = document.createElement('input');
    label_tag3.setAttribute('for', 'value');
    label_tag3.innerHTML = 'Value';
    input_tag3.setAttribute('type', 'text');
    input_tag3.setAttribute('name', 'value');
    input_tag3.setAttribute('id', 'valueTF');
    div_tag3.appendChild(label_tag3);
    div_tag3.appendChild(input_tag3);
    form_tag.appendChild(div_tag3);

    let div_tag4 = document.createElement('div');

    let add_button = document.createElement('button');
    add_button.innerHTML = 'add element';
    add_button.id = 'DOADD';
    div_tag4.appendChild(add_button);
    form_tag.appendChild(div_tag4);
    form_tag.setAttribute('action', '../../add');
    form_tag.setAttribute('method', 'GET');
    display_space.appendChild(form_tag);
}

function showRemoveForm()
{
    display_space.innerHTML = '';
    let form_tag = document.createElement('form');
    let div_tag = document.createElement('div');
    let label_tag = document.createElement('label');
    label_tag.setAttribute('for', 'index');
    label_tag.innerHTML = 'Index';
    let input_tag = document.createElement('input');
    input_tag.setAttribute('type', 'text');
    input_tag.setAttribute('name', 'index');
    input_tag.setAttribute('id', 'indexTF');
    input_tag.required = true;
    div_tag.appendChild(label_tag);
    div_tag.appendChild(input_tag);
    form_tag.appendChild(div_tag);   
    
    let div_tag2 = document.createElement('div');
    let remove_button = document.createElement('button');
    remove_button.innerHTML = 'remove element';
    remove_button.id = 'VALIDREM';
    div_tag2.appendChild(remove_button);
    form_tag.appendChild(div_tag2);
    form_tag.setAttribute('action', '../../remove');
    form_tag.setAttribute('method', 'GET');
    display_space.appendChild(form_tag);
}

function showLocalPie()
{
    let xhr = new XMLHttpRequest();
    xhr.open("GET", '../../Items');
    xhr.onload = function(){
        let file = this.responseText;
        let storage_data = JSON.parse(file);
        let sum_value = 0;
        for (let i in storage_data)
        {
            sum_value += storage_data[i].value;
        }
        let start_angle = 0;
        var svgNS = "http://www.w3.org/2000/svg"
        let svg = document.createElementNS(svgNS, "svg");
        svg.setAttribute("height", 1000);
        svg.setAttribute("width", 1000);
        svg.setAttribute("xmlns", "http://www.w3.org/2000/svg");
        for (let i in storage_data)
        {
            storage_data[i].angle = start_angle + storage_data[i].value/sum_value;
            start_angle = storage_data[i].angle;
            console.log(i, storage_data[i].angle, start_angle);
            let path = document.createElementNS(svgNS, "path");
            let start_x = 500*(1-Math.cos(storage_data[i].angle*2*Math.PI));
            let start_y = 500*(1+Math.sin(storage_data[i].angle*2*Math.PI));
            let end_x = 500*(1-Math.cos((storage_data[i].angle+storage_data[i].value/sum_value)*2*Math.PI));
            let end_y = 500*(1+Math.sin((storage_data[i].angle+storage_data[i].value/sum_value)*2*Math.PI));
        
            path.setAttribute('d', 'M 500 500 L' + start_x + start_y + 'A 500 500 0 0 1' + end_x + end_y + ' Z');
            path.setAttribute('fill', storage_data[i].color);
            svg.appendChild(path);
        
            let text_label = document.createElementNS(svgNS, 'text');
            text_label.setAttribute("x", 500 - 300*Math.cos((storage_data[i].angle + storage_data[i].value/sum_value/2)*2*Math.PI));
            text_label.setAttribute("y", 500 + 300*Math.sin((storage_data[i].angle + storage_data[i].value/sum_value/2)*2*Math.PI));
            text_label.textContent = storage_data[i].title;
            svg.appendChild(text_label);
            console.log(svg);

        }
        display_space.innerHTML = svg;
    }
    xhr.send();
}
