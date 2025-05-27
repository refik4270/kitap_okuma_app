class Book {
  final String id;
  final String title;
  final String author;
  final List<String> pages; // Her sayfa metni burada tutulacak (örnek)

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.pages,
  });

  // Firestore'dan gelen Map verisini Book objesine dönüştürür
  factory Book.fromMap(Map<String, dynamic> map, {String? id}) {
    return Book(
      id: id ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      pages: List<String>.from(map['pages'] ?? []),
    );
  }
}
