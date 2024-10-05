import 'dart:io';

import 'package:flutter/material.dart';

import '../client/client.dart';

typedef imageBuilder = Widget Function(BuildContext context, ImageProvider imageProvider);

class CachedNetworkImage extends StatefulWidget{
  final Widget placeholder;
  final Uri imageUrl;
  final imageBuilder builder;


  const CachedNetworkImage({super.key, required this.placeholder, required this.imageUrl, required this.builder});

  @override
  State<CachedNetworkImage> createState() => _CachedNetworkImageState();
}

class _CachedNetworkImageState extends State<CachedNetworkImage> {
  bool loading = true;
  late ImageProvider imageProvider;

  Future<void> loadData() async {
    String imagePath = await client.downloadFile(widget.imageUrl.toString(), widget.imageUrl.pathSegments.last);
    File imageFile = File(imagePath);
    imageProvider = FileImage(imageFile);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState(){
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context){
    if (loading){
      return widget.placeholder;
    } else {
      return widget.builder(context, imageProvider);
    }
  }
}