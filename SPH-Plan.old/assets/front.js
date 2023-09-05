//BUTTON CALLS

document.getElementById("loginButton").onclick = () => {
    try {
        front.send("auth", {
            username: document.getElementById("login.username").value,
            pass: document.getElementById("login.pass").value,
            schoolID: document.getElementById("login.schoolid").value
        });
    } catch (err) {
        alert(err);
    }
}


//RECIEVE SIGNALS
front.on("loginSuccessful", data => {
    if (data.data) {
        //login successful
        document.getElementById("connectionInformation").innerText = "Erfolgreich angemeldet!";
        document.getElementById("loginButton").disabled = true;
    } else {
        //login failed
        document.getElementById("connectionInformation").innerText = "Login war nicht möglich!";
        document.getElementById("loginButton").disabled = false;
    }
});

front.on("ping", () => {
    alert("ping!");
})