import 'package:gsheets/gsheets.dart'; // Importing the gsheets package to interact with Google Sheets.
import 'package:my_plant/screens/Stats%20screen/credentials.dart'; // Importing credentials from a local file to authenticate access to Google Sheets.

class GoogleSheetsService {
  // This function fetches data from a specified Google Sheets document.
  Future<List<List<String>>> fetchData() async {
    final gsheets = GSheets(credentials); // Creating a GSheets object with the provided credentials.
    final ss = await gsheets.spreadsheet(spreadsheetId); // Accessing the spreadsheet using its ID.
    var sheet = ss.worksheetByTitle("Sheet1"); // Accessing the worksheet named "Sheet1" within the spreadsheet.
    final rows = await sheet!.values.allRows(); // Fetching all rows of data from the worksheet.
    return rows; // Returning the rows as a list of lists of strings.
  }
}
