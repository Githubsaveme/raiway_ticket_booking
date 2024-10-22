import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const TicketBookingApp());
}

class TicketBookingApp extends StatelessWidget {
  const TicketBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TicketBookingHome(),
    );
  }
}

class TicketBookingHome extends StatefulWidget {
  const TicketBookingHome({super.key});

  @override
  _TicketBookingHomeState createState() => _TicketBookingHomeState();
}

class _TicketBookingHomeState extends State<TicketBookingHome> {
  String? _selectedSource;
  String? _selectedDestination;
  DateTime _selectedDate = DateTime.now();

  List<String> stations = [
    'Delhi',
    'Mumbai',
    'Chennai',
    'Kolkata',
    'Hyderabad'
  ];

  // Method to pick a date
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Generate PDF Method
  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: pw.PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Indian Railways",
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: pw.PdfColors.blue900,
                      ),
                    ),
                    pw.Text(
                      "Ticket Confirmation",
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: pw.PdfColors.red800,
                      ),
                    ),
                  ],
                ),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text(
                  "Ticket Details",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: pw.PdfColors.blue800,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border:
                        pw.Border.all(color: pw.PdfColors.blueGrey, width: 2),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("From: $_selectedSource",
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.Text("To: $_selectedDestination",
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.Text(
                        "Date of Journey: ${DateFormat.yMMMd().format(_selectedDate)}",
                        style: const pw.TextStyle(fontSize: 16),
                      ),
                      pw.Text("Train: Rajdhani Express",
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.Text("Seat: A12, Class: 1A",
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.Text("PNR: 1234567890",
                          style: const pw.TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "Passenger Information",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: pw.PdfColors.blue800,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border:
                        pw.Border.all(color: pw.PdfColors.blueGrey, width: 2),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Passenger Name: John Doe",
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.Text("Age: 28",
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.Text("Gender: Male",
                          style: const pw.TextStyle(fontSize: 16)),
                      pw.Text("Contact: +91 9876543210",
                          style: const pw.TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "Thank you for choosing Indian Railways!",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: pw.PdfColors.green800,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "We wish you a pleasant journey.",
                  style: const pw.TextStyle(
                    fontSize: 14,
                    color: pw.PdfColors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (pw.PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Railway Ticket Booking",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Define responsive layout behavior
            double width = constraints.maxWidth;
            bool isLargeScreen =
                width > 600; // Define breakpoint for large screens

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Book Your Ticket",
                  style: TextStyle(
                    fontSize: isLargeScreen ? 30 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Source Dropdown
                Flexible(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedSource,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSource = newValue;
                      });
                    },
                    items: stations.map((station) {
                      return DropdownMenuItem(
                        child: Text(station),
                        value: station,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Destination Dropdown
                Flexible(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedDestination,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDestination = newValue;
                      });
                    },
                    items: stations.map((station) {
                      return DropdownMenuItem(
                        child: Text(station),
                        value: station,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Date Picker
                GestureDetector(
                  onTap: () => _pickDate(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Date of Journey: ${DateFormat.yMMMd().format(_selectedDate)}",
                      style: TextStyle(fontSize: isLargeScreen ? 18 : 16),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Generate PDF Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      textStyle: TextStyle(
                        fontSize: isLargeScreen ? 18 : 16,
                      ),
                    ),
                    onPressed: () {
                      if (_selectedSource != null &&
                          _selectedDestination != null) {
                        _generatePDF();
                      } else {
                        print(
                            "Please select both source and destination stations.");
                      }
                    },
                    child: const Text(
                      "Generate PDF & Print",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
