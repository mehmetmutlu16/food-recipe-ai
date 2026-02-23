enum RecipeInputType {
  text,
  image,
  mixed,
}

extension RecipeInputTypeX on RecipeInputType {
  String get value {
    switch (this) {
      case RecipeInputType.text:
        return 'text';
      case RecipeInputType.image:
        return 'image';
      case RecipeInputType.mixed:
        return 'mixed';
    }
  }
}
