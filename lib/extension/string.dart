extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }

  String capitalizeWord() {
    if (this.isEmpty) return this;
    return this
        .split(' ')
        .map((word) {
          if (word.isEmpty) return this;
          return '${word[0].toUpperCase()}${word.substring(1)}';
        })
        .join(' ');
  }
}
