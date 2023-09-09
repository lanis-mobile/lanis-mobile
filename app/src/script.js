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
}

function closeSettingsScreen() {
    app.loginScreen.close('#settings-screen');
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