// List<String> SoftBreadCategory = ['식빵', '치아바타', '크림빵'];
// List<String> HardBreadCategory = ['깜빠뉴'];
// List<String> DessertBreadCategory = ['파운드,크럼블', '브라우니', '스콘', '쿠키', '케이크'];
final SimpleBreadFetchMinimum = 2;
enum BreadLargeCategory {
  all,
  softBread,
  hardBread,
  dessert,
}

class BreadCategory {
  final String id;
  final String category;
  BreadCategory({required this.id, required this.category});
}

final BreadCategories = [
  BreadCategory(id: '0', category: '전체'),
  BreadCategory(id: '1', category: '소프트브레드'),
  BreadCategory(id: '2', category: '하드브레드'),
  BreadCategory(id: '3', category: '디저트'),
];
enum BreadOptionFilterType { gf, rice, sf }

class BreadSortFilter {
  final String id;
  final String filter;
  BreadSortFilter({required this.id, required this.filter});
}

final List<BreadSortFilter> BreadSortFilters = [
  BreadSortFilter(id: '1', filter: '최신순'),
  BreadSortFilter(id: '2', filter: '인기순'),
  BreadSortFilter(id: '3', filter: '저가순'),
  BreadSortFilter(id: '4', filter: '리뷰많은순'),
];

class BreadOptionFilter {
  final String id;
  final String filter;
  BreadOptionFilter({required this.id, required this.filter});
}

final List<BreadOptionFilter> BreadOptionFilters = [
  BreadOptionFilter(id: '1', filter: '최신순'),
  BreadOptionFilter(id: '2', filter: '인기순'),
  BreadOptionFilter(id: '3', filter: '리뷰많은순'),
  BreadOptionFilter(id: '3', filter: '저가순'),
];

class BreadSimpleInfo {
  final String thumbnail;
  final String name;
  final String bakeryName;
  final int price;
  final String? description;
  final int discount;
  final bool isSigniture;
  final List<dynamic> breadFeatures;
  BreadSimpleInfo({
    required this.thumbnail,
    required this.name,
    required this.bakeryName,
    required this.breadFeatures,
    this.description,
    this.price: 0,
    this.discount: 0,
    this.isSigniture: false,
  });
  BreadSimpleInfo.fromJson(Map<String, dynamic> json)
      :
        // thumbnail: json['thumbnail'],
        thumbnail = 'assets/breadImage.jpg',
        name = json['name'],
        bakeryName = json['bakeryName'],
        description = json['description'],
        price = json['price'],
        discount = json['discount'],
        breadFeatures = json['breadFeatures']
            .map((breadFeature) => breadFeature['filter'])
            .toList(),
        isSigniture = json['isSigniture'];

  @override
  String toString() {
    return 'name: $name, bakeryName: $bakeryName, price: $price, description: $description, discount: $discount, isSigniture: $isSigniture breadFeature: $breadFeatures';
  }
}
