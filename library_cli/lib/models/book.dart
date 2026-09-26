class Book {
  final int? id;
  final String title;
  final String author;
  final String isbn;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.isbn,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int?,
      title: json['title'] as String,
      author: json['author'] as String,
      isbn: json['isbn'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
    };
  }
}