extension ListExtension on List {
  void addUniqueItems(List newList) {
    final existingSet = toSet();

    final filteredList =
        newList.where((item) => !existingSet.contains(item)).toList();

    addAll(filteredList);
  }
}
