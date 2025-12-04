/// Model class representing a contact group with name and phone numbers
class ContactGroup {
  final String name;
  final List<String> phoneNumbers;

  const ContactGroup({
    required this.name,
    required this.phoneNumbers,
  });

  /// Factory constructor to create ContactGroup from JSON
  factory ContactGroup.fromJson(Map<String, dynamic> json) {
    return ContactGroup(
      name: json['name'] as String,
      phoneNumbers: List<String>.from(json['phoneNumbers'] as List),
    );
  }

  /// Convert ContactGroup to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumbers': phoneNumbers,
    };
  }

  @override
  String toString() {
    return 'ContactGroup{name: $name, phoneNumbers: $phoneNumbers}';
  }
}

/// Predefined contact groups for the application
class ContactGroups {
  static const List<ContactGroup> groups = [
    ContactGroup(
      name: 'Group A',
      phoneNumbers: ['+27123456798'],
    ),
    ContactGroup(
      name: 'Group B',
      phoneNumbers: ['+27823334444'],
    ),
    ContactGroup(
      name: 'Group C',
      phoneNumbers: ['+27820001111'],
    ),
  ];

  /// Get all available contact groups
  static List<ContactGroup> getAllGroups() => groups;

  /// Get a specific group by name
  static ContactGroup? getGroupByName(String name) {
    try {
      return groups.firstWhere((group) => group.name == name);
    } catch (e) {
      return null;
    }
  }
}
