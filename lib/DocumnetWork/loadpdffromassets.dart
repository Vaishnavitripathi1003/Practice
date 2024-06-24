import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class PdfViewerScreen extends StatefulWidget {
  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String assetPDFPath = "";
  bool isLoading = true;
  String searchQuery = "";
  List<Map<String, dynamic>> searchResults = [];
  int currentPage = 0;
  int totalResults = 0;
  PDFViewController? pdfViewController;

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  Future<void> loadPDF() async {
    try {
      setState(() {
        isLoading = true;
      });

      final data = await rootBundle.load('assets/file-sample_150kB.pdf');
      final bytes = data.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/file-sample_150kB.pdf");

      await file.writeAsBytes(bytes, flush: true);

      if (await file.exists()) {
        setState(() {
          assetPDFPath = file.path;
          isLoading = false;
        });
        print("PDF loaded successfully: ${file.path}");
      } else {
        print("Failed to write PDF file to temporary directory");
      }
    } catch (e) {
      print("Error loading PDF: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchPDF(String query) {
    // Dummy search results for demonstration purposes
    // Replace this with actual text extraction and search logic if needed
    setState(() {
      searchQuery = query;
      searchResults = [
        {'page': 1, 'coordinates': Rect.fromLTWH(50, 100, 100, 20)},
        {'page': 2, 'coordinates': Rect.fromLTWH(50, 200, 100, 20)},
        {'page': 3, 'coordinates': Rect.fromLTWH(50, 300, 100, 20)},
      ];
      totalResults = searchResults.length;
      currentPage = 0;
    });
  }

  void nextResult() {
    if (currentPage < searchResults.length - 1) {
      setState(() {
        currentPage++;
        pdfViewController!.setPage(searchResults[currentPage]['page'] - 1);
      });
    }
  }

  void previousResult() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        pdfViewController!.setPage(searchResults[currentPage]['page'] - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final query = await showSearch(
                context: context,
                delegate: PDFSearchDelegate(
                  onSearch: searchPDF,
                ),
              );
              if (query != null) {
                searchPDF(query);
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                PDFView(
                  filePath: assetPDFPath,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: false,
                  pageFling: false,
                  onRender: (pages) {
                    setState(() {
                      isLoading = false;
                    });
                    print("PDF rendered with $pages pages");
                  },
                  onError: (error) {
                    print("PDF render error: $error");
                  },
                  onPageError: (page, error) {
                    print("Error on page $page: $error");
                  },
                  onViewCreated: (controller) {
                    pdfViewController = controller;
                  },
                ),
                if (searchResults.isNotEmpty)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: previousResult,
                        ),
                        Text(
                          "${currentPage + 1} of $totalResults",
                          style: TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: nextResult,
                        ),
                      ],
                    ),
                  ),
                if (searchResults.isNotEmpty &&
                    searchResults[currentPage]['page'] - 1 == currentPage)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        color: Colors.transparent,
                        child: CustomPaint(
                          painter: HighlightPainter(
                            highlights: searchResults
                                .where((result) =>
                                    result['page'] - 1 == currentPage)
                                .map((result) => result['coordinates'] as Rect)
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class HighlightPainter extends CustomPainter {
  final List<Rect> highlights;

  HighlightPainter({required this.highlights});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    for (var rect in highlights) {
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PDFSearchDelegate extends SearchDelegate<String> {
  final Function(String) onSearch;

  PDFSearchDelegate({required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  void showResults(BuildContext context) {
    super.showResults(context);
    onSearch(query);
    close(context, query);
  }
}
