class ShortcutItem {
  const ShortcutItem({
    required this.id,
    required this.category,
    required this.shortcut,
    required this.function,
    this.description,
  });

  final String id;
  final String category;
  final String shortcut;
  final String function;
  final String? description;

  List<String> get keys => shortcut
      .split('+')
      .map((key) => key.trim())
      .where((key) => key.isNotEmpty)
      .toList();

  factory ShortcutItem.fromJson(Map<String, dynamic> json) {
    return ShortcutItem(
      id: json['id'] as String,
      category: json['category'] as String,
      shortcut: json['shortcut'] as String,
      function: json['function'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'shortcut': shortcut,
    'function': function,
    if (description != null) 'description': description,
  };
}
