class FileNode {
  String name;
  int id;
  String downloadUrl;
  String groesse;
  String aenderung;
  String? hinweis;

  FileNode(this.name, this.id, this.downloadUrl, this.aenderung, this.groesse, {this.hinweis});
}

class FolderNode {
  String name;
  int id;
  int subfolders;
  String desc;

  FolderNode(this.name, this.id, this.subfolders, this.desc);
}
