/**
 * Usage: node format.js > data.json
 */

fetch("https://startcache.schulportal.hessen.de/exporteur.php?a=schoollist").then(data => {
    data.json().then(data => {
        let result = [];

        data.forEach(elem => {
            elem.Schulen.forEach(schule => {
                result.push(`${schule.Name} - ${schule.Ort} (${schule.Id})`);
            })
        });

        console.log(JSON.stringify(result));
    })
})
