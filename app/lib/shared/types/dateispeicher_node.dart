class FileNode {
  String name;
  int id;
  String downloadUrl;
  String groesse;
  String aenderung;

  FileNode(this.name, this.id, this.downloadUrl, this.aenderung, this.groesse);
}

class FolderNode {
  String name;
  int id;
  int subfolders;
  String desc;

  FolderNode(this.name, this.id, this.subfolders, this.desc);
}
