# UI Test App — CampusEats Prototype

A multi-screen Flutter app demonstrating navigation and layout widgets.
Built for ICT4153 Practical 07 in-class project.

## Screens
1. **Home Screen** — GridView of food items with AppBar cart icon
2. **Food Detail Screen** — Stack layout with discount badge overlay
3. **Cart Screen** — ListView.builder with remove + total calculation

## Layout Concepts
- GridView.builder for food grid
- Stack + Positioned for badge overlay
- ListView.builder for cart items
- Navigator.push() for screen navigation
- setState() for cart count updates
- Expanded + Flexible for responsive layout
- Card + ListTile for styled list rows

## Run
```bash
flutter pub get
flutter run -d chrome  # Works on web (no sqflite)
```
