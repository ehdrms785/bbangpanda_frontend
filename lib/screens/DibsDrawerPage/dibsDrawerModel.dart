class DibsDrawerInfo {
  final int id;
  String name;
  final List<DibsItem>? items;
  final int itemCount;

  DibsDrawerInfo.fromJson(Map<String, dynamic> dibsDrawerJson)
      : id = dibsDrawerJson['id'],
        name = dibsDrawerJson['name'],
        items = dibsDrawerJson['item']
            ?.map<DibsItem>((dibsItem) => DibsItem.fromJson(dibsItem))
            .toList(),
        itemCount = dibsDrawerJson['itemCount'];
}

class DibsItem {
  final int id;
  final String name;
  final String? thumbnail;
  final int price;
  final int discount;
  final String? description;

  DibsItem.fromJson(Map<String, dynamic> dibsItemJson)
      : id = dibsItemJson['id'],
        name = dibsItemJson['name'],
        price = dibsItemJson['price'],
        discount = dibsItemJson['discount'],
        thumbnail = dibsItemJson['thumbnail'] ?? 'assets/breadImage.jpg',
        description = dibsItemJson['description'];
}
