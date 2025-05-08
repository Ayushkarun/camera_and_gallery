import 'dart:io';
import 'package:flutter/material.dart';
import 'gallery_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart'; // For formatting file info
import 'package:flutter/services.dart'; // make sure this is also imported

class FullimageScreen extends StatelessWidget {
  final File imageFile; // this will come from tapped image
  const FullimageScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Images'), backgroundColor: Colors.black),
      body: Column(
        children: [
          Expanded(child:InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          
          ),


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    bool confirm = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Delete image'),
                          content: Text("Are you sure want to delete ?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                return Navigator.pop(context, false);
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                return Navigator.pop(context, true);
                              },
                              child: Text("delete"),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirm) {
                      if (await imageFile.exists()) {
                        await imageFile.delete();
                        Navigator.pop(
                          context,
                          true,
                        ); // Return true to indicate deletion
                      }
                    }
                  },

                  icon: Icon(Icons.delete),
                  label: Text("Delete"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),

                ///share
                ElevatedButton.icon(
                  onPressed: () {
                    Share.shareXFiles([
                      XFile(imageFile.path),
                    ], text: "Check out this image!");
                  },
                  icon: Icon(Icons.share),
                  label: Text("Share"),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    var stat = await imageFile.stat();
                    String size = "${(stat.size / 104).toStringAsFixed(2)} KB";
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Image info"),
                          content: Text("Path :${imageFile.path}\nSize:$size"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.info),
                  label: Text("info"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
