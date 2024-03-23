class FileNode {
  String name;
  int id;
  int? folderID;
  String downloadUrl;
  String groesse;
  String aenderung;
  String? hinweis;

  FileNode(
      {required this.name,
      required this.id,
      required this.downloadUrl,
      this.aenderung = "",
      this.groesse = "",
      this.hinweis,
      this.folderID});
}

class FolderNode {
  String name;
  int id;
  int subfolders;
  String desc;

  FolderNode(this.name, this.id, this.subfolders, this.desc);
}
