import 'book.dart';

class BookCopy {
  final int? id;
  final Book? book;
  final String status;

  BookCopy({
    this.id,
    this.book,
    required this.status,
  });

  factory BookCopy.fromJson(Map<String, dynamic> json) {
    return BookCopy(
      id: json['id'] as int?,
      book: json['book'] != null ? Book.fromJson(json['book']) : null,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (book != null) 'book': book!.toJson(),
      'status': status,
    };
  }
}