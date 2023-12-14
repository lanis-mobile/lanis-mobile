DROP TABLE IF EXISTS Reports;
CREATE TABLE IF NOT EXISTS Reports (id integer PRIMARY KEY AUTOINCREMENT, username TEXT, report TEXT, time_stamp TEXT, contact_information TEXT, vertretungsplan TEXT, kalender TEXT, mein_unterricht TEXT, nachrichten TEXT, userinfo TEXT);


DROP TABLE IF EXISTS Developers;
CREATE TABLE IF NOT EXISTS Developers (id integer PRIMARY KEY AUTOINCREMENT, github_username TEXT, access_token TEXT);
--INSERT INTO Developers (github_username, access_token) VALUES ('alessioC42', 'example');
--Access tokens are set in cloudflare admin panel