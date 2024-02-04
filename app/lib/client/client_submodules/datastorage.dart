import 'package:dio/dio.dart';
import 'package:html/parser.dart';

import '../../shared/types/dateispeicher_node.dart';
import '../client.dart';

class DataStorageParser {
  late Dio dio;
  late SPHclient client;

  DataStorageParser(Dio dioClient, this.client) {
    dio = dioClient;
  }

  Future<dynamic> getNode(int nodeID) async {
    final response = await dio.get("https://start.schulportal.hessen.de/dateispeicher.php?a=view&folder=$nodeID");
    var document = parse(response.data);
    List<FileNode> files = [];
    List<String> headers = document.querySelectorAll("table#files thead th").map((e) => e.text).toList();
    for (var file in document.querySelectorAll("table#files tbody tr")) {
      final fields = file.querySelectorAll("td");
      var name = fields[headers.indexOf("Name")].text.trim();
      var aenderung = fields[headers.indexOf("Änderung")].text.trim();
      var groesse = fields[headers.indexOf("Größe")].text.trim();
      var id = int.parse(file.attributes["data-id"]!.trim());
      files.add(FileNode(name, id, "https://start.schulportal.hessen.de/dateispeicher.php?a=download&f=$id", aenderung, groesse));
    }
    List<FolderNode> folders = [];
    for (var folder in document.querySelectorAll(".folder")) {
      var name = folder.querySelector(".caption")!.text.trim();
      var desc = folder.querySelector(".desc")!.text.trim();
      var subfolders = int.tryParse(RegExp(r"\d+").firstMatch(folder.querySelector("[title=\"Anzahl Ordner\"]")?.text.trim() ?? "")?.group(0) ?? "") ?? 0;
      var id = int.parse(folder.attributes["data-id"]!);
      folders.add(FolderNode(name, id, subfolders, desc));
    }
    return (files, folders);
  }

  Future<dynamic> getRoot() async {
    return await getNode(0);
  }

}