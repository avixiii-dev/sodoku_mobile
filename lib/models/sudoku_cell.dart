class SudokuCell {
  int? value;
  bool isInitial;
  bool isValid;
  List<int> notes;

  SudokuCell({
    this.value,
    this.isInitial = false,
    this.isValid = true,
    List<int>? notes,
  }) : notes = notes ?? [];

  SudokuCell copyWith({
    int? value,
    bool? isInitial,
    bool? isValid,
    List<int>? notes,
  }) {
    return SudokuCell(
      value: value ?? this.value,
      isInitial: isInitial ?? this.isInitial,
      isValid: isValid ?? this.isValid,
      notes: notes ?? List.from(this.notes),
    );
  }
}
