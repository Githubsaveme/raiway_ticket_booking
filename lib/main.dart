import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

void main() {
  runApp(MaterialApp(
    home: BookingScreen(),
  ));
}

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _age = '';
  String _destination = '';
  String _date = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Railways Ticket Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                onSaved: (value) => _age = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Destination'),
                onSaved: (value) => _destination = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date of Travel'),
                onSaved: (value) => _date = value ?? '',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    _generatePdfTicket(_name, _age, _destination, _date);
                  }
                },
                child: Text('Book Ticket & Generate PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generatePdfTicket(
      String name, String age, String destination, String date) async {
    final pdf = pw.Document();

    // Define custom styles
    final boldTextStyle =
        pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold);
    final regularTextStyle = pw.TextStyle(fontSize: 14);
    final headerTextStyle = pw.TextStyle(
        fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue);
    final footerTextStyle =
        pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic);

    // Add a page with enhanced layout
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header section with Indian Railways title
                pw.Center(
                  child: pw.Text(
                    'Indian Railways Ticket',
                    style: headerTextStyle,
                  ),
                ),
                pw.SizedBox(height: 10),

                // Passenger details in a table format
                pw.Table(
                  border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                  children: [
                    _buildTableRow('Passenger Name', name, boldTextStyle,
                        regularTextStyle),
                    _buildTableRow('Age', age, boldTextStyle, regularTextStyle),
                    _buildTableRow('Destination', destination, boldTextStyle,
                        regularTextStyle),
                    _buildTableRow('Date of Travel', date, boldTextStyle,
                        regularTextStyle),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Ticket terms and conditions or any additional information
                pw.Text(
                  'Thank you for booking with Indian Railways! Please make sure to arrive at least 30 minutes before the departure time.',
                  style: regularTextStyle,
                  textAlign: pw.TextAlign.justify,
                ),
                pw.SizedBox(height: 20),

                // Footer
                pw.Divider(),
                pw.Center(
                  child: pw.Text(
                    'Safe travels with Indian Railways!',
                    style: footerTextStyle,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Save PDF to a file
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/railways_ticket.pdf");

    await file.writeAsBytes(await pdf.save());

    // Open the generated PDF
    await OpenFile.open(file.path);
  }

  pw.TableRow _buildTableRow(
    String title,
    String value,
    pw.TextStyle titleStyle,
    pw.TextStyle valueStyle,
  ) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.all(8),
          child: pw.Text(title, style: titleStyle),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(8),
          child: pw.Text(value, style: valueStyle),
        ),
      ],
    );
  }
}
