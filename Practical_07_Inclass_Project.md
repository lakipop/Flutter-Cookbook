# Practical 07 – Project
## In-Class Project: "CampusEats – Mini Food Ordering App"

**Dept of ICT, Faculty of Technology, University of Ruhuna**
**2026**

---

## Objective

Design and implement a simple multi-screen Flutter application using:

- Column & Row
- Stack
- ListView.builder
- GridView
- Card & ListTile
- Navigator.push()
- setState() for cart count
- Expanded & Flexible for responsiveness

---

## Scenario

University students often struggle to order food quickly during short breaks.
You are required to build a simple prototype mobile app called **"CampusEats"** for ordering food inside the university premises.

The app must contain three screens only (simplified version for class):

1. Home Screen
2. Food Details Screen
3. Cart Screen

---

## Functional Requirements

### 1. Home Screen

**Must Include:**
- AppBar with title CampusEats
- A GridView showing at least 6 food items
- Each food item displayed using:
  - Card
  - Image
  - Food name
  - Price
- A cart icon in AppBar showing number of selected items
- Clicking an item → navigate to Food Details screen

**Layout Concepts Tested:**
- GridView
- Column
- Card
- Expanded
- Navigator

---

### 2. Food Details Screen

**Must Include:**
- Large food image (use Stack to overlay discount badge)
- Food name
- Description
- Price
- "Add to Cart" button

**Functional:**
- When button is pressed:
  - Increase cart counter using setState
  - Show SnackBar confirmation

**Layout Concepts Tested:**
- Stack + Positioned
- Column
- ElevatedButton
- setState

---

### 3. Cart Screen

**Must Include:**
- ListView.builder showing selected items
- Each row:
  - Food name
  - Price
  - Remove button
- Total price at bottom
- Checkout button (no functionality required)

**Layout Concepts Tested:**
- ListView.builder
- Row
- Expanded
- setState for removal
- Basic calculation logic

---

## Minimum Data Structure (Students Must Create)

```dart
class FoodItem {
  final String name;
  final double price;
  final String image;

  FoodItem({required this.name, required this.price, required this.image});
}
```

Students must create a `List<FoodItem>` with 6 items.

---

## UI Constraints

Students must:

- Use at least one Stack
- Use Expanded or Flexible somewhere
- Use ListView.builder (not static ListView)
- Use Navigator.push()
- Use setState()
