import { getMessagePermissions, createNotificationsFromPlanData } from "./notifications";
import { SecureStorage } from "@aparajita/capacitor-secure-storage";
import { SPHClient } from "./client";
import { filter } from "./filterplan";

addEventListener('updateVplanMessages', async (resolve, reject, _args) => {
    try {
        let permissions = await getMessagePermissions();

        let backgroundfetch = await SecureStorage.getItem("useBackgroundFetch");
        let autologin = await SecureStorage.getItem("autologin");
        let password = await SecureStorage.getItem("password");
        let username = await SecureStorage.getItem("username");
        let schoolid = await SecureStorage.getItem("schoolid");
      
        if (autologin && username && password && schoolid && permissions && backgroundfetch) {
            let client = new SPHClient();

            let cookieHeader = await client.login(username, password, schoolid)
            await SecureStorage.setItem("cookieHeader", cookieHeader);

            let data = await client.getAllVplanData(cookieHeader);
            let filteredData = await filter(data);
            createNotificationsFromPlanData(filteredData);
        }

        resolve();
    } catch (err) {
        reject();
    }
});