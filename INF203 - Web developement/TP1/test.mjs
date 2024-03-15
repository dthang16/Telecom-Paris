"use strict";

import {Stud, ForStudent } from "./exercise3.mjs";
import {Prmtn} from "./exercise4.mjs";

let prtm = new Prmtn();
prtm.readFromFile("jsonFile.json");
console.log(prtm.get(0));
console.log(prtm.get(1));