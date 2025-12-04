import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for interacting with the ZoomConnect Interactive API
/// Documentation: https://zoomconnect.com/interactive-api/
class ZoomConnectService {
  // TODO: Replace these with your actual ZoomConnect credentials
  // Get them from: https://zoomconnect.com (Account Settings > Developer Settings)
  
  // Option 1: REST API Token (Recommended)
  static const String _restApiToken = '';
  static const String _emailAddress = ''; // Your ZoomConnect account email
  
  // Option 2: URL Sending (Alternative - no authentication needed)
  static const String _sendUrl = 'https://www.zoomconnect.com/app/api/rest/v1/sms/send-url/';
  
  // ZoomConnect REST API base URL
  static const String _baseUrl = 'https://www.zoomconnect.com/app/api/rest/v1';
  
  /// Send SMS message to multiple recipients
  /// 
  /// [message] - The SMS text content to send
  /// [recipients] - List of phone numbers in international format (e.g., +27821234567)
  /// 
  /// Returns true if successful, throws exception on failure
  Future<bool> sendMessage({
    required String message,
    required List<String> recipients,
  }) async {
    if (recipients.isEmpty) {
      throw Exception('Recipients list cannot be empty');
    }

    if (message.trim().isEmpty) {
      throw Exception('Message cannot be empty');
    }

    try {
      // Prepare the API endpoint for REST API v1
      final url = Uri.parse('$_baseUrl/sms/send.json');
      
      // Prepare request body for REST API
      final requestBody = {
        'message': message,
        'recipientNumber': recipients.join(','), // Multiple recipients separated by comma
      };

      print('Sending SMS to ${recipients.length} recipient(s)...');
      print('Message: $message');

      // Make HTTP POST request with email and token headers
      final response = await http.post(
        url,
        headers: {
          'email': _emailAddress,
          'token': _restApiToken,
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        
        // Check if the API returned a success response
        // ZoomConnect returns messageId on success, error field is null
        if (responseData['messageId'] != null && responseData['error'] == null) {
          print('✓ Message sent successfully! MessageId: ${responseData['messageId']}');
          return true;
        } else if (responseData['error'] != null) {
          // API returned an error
          final errorMessage = responseData['error'].toString();
          throw Exception('API Error: $errorMessage');
        } else {
          throw Exception('Unknown error from ZoomConnect API');
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Authentication failed. Please check your email and REST API token.');
      } else if (response.statusCode == 400) {
        final responseData = json.decode(response.body);
        final errorMessage = responseData['message'] ?? 
                            responseData['error'] ?? 
                            'Bad request';
        throw Exception('Invalid request: $errorMessage');
      } else {
        throw Exception('Failed to send message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log and rethrow the exception
      print('✗ Error sending message: $e');
      rethrow;
    }
  }

  /// Check account balance (optional feature)
  /// Returns the remaining credits in your ZoomConnect account
  Future<double?> checkBalance() async {
    try {
      final url = Uri.parse('https://www.zoomconnect.com/app/api/rest/v1/account/balance');
      
      final response = await http.get(
        url,
        headers: {
          'email': _emailAddress,
          'token': _restApiToken,
          'Accept': 'application/json',
        },
      );

      print('Balance response status: ${response.statusCode}');
      print('Balance response headers: ${response.headers}');
      print('Balance response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body;
        
        // Try JSON first since we know the response is JSON
        try {
          final responseData = json.decode(body);
          print('Decoded JSON: $responseData');
          print('creditBalance value: ${responseData['creditBalance']}');
          print('creditBalance type: ${responseData['creditBalance'].runtimeType}');
          
          // creditBalance is already a number, not a string
          if (responseData['creditBalance'] != null) {
            final balance = (responseData['creditBalance'] as num).toDouble();
            print('Parsed balance from JSON: $balance');
            return balance;
          }
          // Fallback to other possible field names
          final balance = double.tryParse(responseData['balance']?.toString() ?? '0') ??
                 double.tryParse(responseData['credit']?.toString() ?? '0');
          print('Parsed balance from fallback: $balance');
          return balance;
        } catch (e) {
          print('Failed to parse as JSON: $e');
          
          // Try XML as fallback
          final balanceMatch = RegExp(r'<balance>([\d.]+)</balance>').firstMatch(body);
          if (balanceMatch != null) {
            final balance = double.tryParse(balanceMatch.group(1) ?? '0');
            print('Parsed balance from XML: $balance');
            return balance;
          }
        }
      }
      return null;
    } catch (e) {
      print('Error checking balance: $e');
      return null;
    }
  }

  /// Validate phone number format
  /// ZoomConnect requires international format (e.g., +27821234567)
  bool isValidPhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^\+\d{10,15}$');
    return regex.hasMatch(phoneNumber);
  }

  /// Validate all recipients in a list
  bool validateRecipients(List<String> recipients) {
    return recipients.every((number) => isValidPhoneNumber(number));
  }
}
