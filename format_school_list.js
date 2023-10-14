/**
 * Usage: node format.js > data.json
 */

//https://startcache.schulportal.hessen.de/exporteur.php?a=schoollist
const data = require("./exporteur.json");

let result = {};

data.forEach(elem => {
    elem.Schulen.forEach(schule => {
        result[schule.Id] = `${schule.Name} - ${schule.Ort}`;
    })
});

console.log(JSON.stringify(result));