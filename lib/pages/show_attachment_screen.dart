import 'package:e_meeting_mobile_application/class/global_class.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfScreen extends StatefulWidget {
  final List attachments;

  const PdfScreen({super.key, required this.attachments});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  String? pdfFile;

  void getAttachment () {
    widget.attachments.map((e) => pdfFile = e['link']).toList();
  }

  @override
  void initState() {
    super.initState();
    getAttachment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(seeMore),
      ),
      body: SafeArea(
        child: SfPdfViewer.network("$pdfFile"),
      ),
    );
  }
}
