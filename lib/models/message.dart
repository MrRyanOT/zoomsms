/// Message model with category label and full text content
class Message {
  final String label;      // Category: 'IT', 'Maintenance', 'Overdue', etc.
  final String content;    // Full message text
  
  const Message({
    required this.label,
    required this.content,
  });
}
