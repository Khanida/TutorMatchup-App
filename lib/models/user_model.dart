class User {
  final int id;
  final String name;
  final String imageUrl;

  const User({
    required this.id,
    required this.name,
    this.imageUrl = '',
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    return parts.length == 1
        ? parts.first.substring(0, 1).toUpperCase()
        : '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

const User currentUser = User(id: 0, name: 'You');
const User sampleTutor = User(id: 1, name: 'Engr. Sarfaraz');
const User sampleStudent = User(id: 2, name: 'Sana Ali');
const User sampleTutorTwo = User(id: 3, name: 'Mamtaz Pawnar');
const User sampleTutorThree = User(id: 4, name: 'Ahmed Raza');
