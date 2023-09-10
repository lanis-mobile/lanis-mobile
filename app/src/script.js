import Fuse from 'fuse.js';
import schoolData from './schools.json';


// Initialize app
var app = new Framework7({
    // App root element
    root: '#app',
    // App Name
    name: 'My App',
    // App id
    id: 'com.myapp.test',
    // Enable swipe panel
    panel: {
        swipe: 'left',
    },
});



function openSettingsScreen() {
    app.loginScreen.open('#settings-screen');
    loadSchoolSelect();
}

function closeSettingsScreen() {
    app.loginScreen.close('#settings-screen');
}


var schoolSelectAlreadyLoaded = false;
function loadSchoolSelect() {
    if (!schoolSelectAlreadyLoaded) {
        schoolSelectAlreadyLoaded = true;

        let schools = [];
        Array.from(schoolData).forEach(landkreis => {
            schools = schools.concat(landkreis.Schulen);
        });

        console.log(schools)

        let fuse = new Fuse(schools, {
            keys: ["Id", "Name", "Ort"]
        })

        app.autocomplete.create({
            inputEl: '#school-dropdown',
            openIn: 'dropdown',
            source: async (query, render) => {
                let items = fuse.search(query, {limit: 10});
                console.log(items)
                items = items.map((item) => `${item.item["Id"]} - ${item.item["Name"]} - ${item.item["Ort"]}`);
                render(items);
            }
        });
    }
}

document.getElementById("openSettingsScreenButton").addEventListener("click", () => {
    openSettingsScreen()
})

app.tab.show('#instanceConfigTab');
// Event-Handling für das Umschalten zwischen Tabs
app.on('tabShow', function (tabEl) {
    var tabId = tabEl.id;
    app.tab.show(tabId);
});

