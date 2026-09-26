import 'user.dart';
import 'book_copy.dart';

class Loan {
  final int? id;
  final User? user;
  final BookCopy? bookCopy;
  final String? borrowDate;
  final String? dueDate;
  final String? returnDate;
  final double? fineAmount;

  Loan({
    this.id,
    this.user,
    this.bookCopy,
    this.borrowDate,
    this.dueDate,
    this.returnDate,
    this.fineAmount,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'] as int?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      bookCopy: json['bookCopy'] != null ? BookCopy.fromJson(json['bookCopy']) : null,
      borrowDate: json['borrowDate'] as String?,
      dueDate: json['dueDate'] as String?,
      returnDate: json['returnDate'] as String?,
      fineAmount: (json['fineAmount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (user != null) 'user': user!.toJson(),
      if (bookCopy != null) 'bookCopy': bookCopy!.toJson(),
      if (borrowDate != null) 'borrowDate': borrowDate,
      if (dueDate != null) 'dueDate': dueDate,
      if (returnDate != null) 'returnDate': returnDate,
      if (fineAmount != null) 'fineAmount': fineAmount,
    };
  }
}