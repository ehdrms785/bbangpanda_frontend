final SimpleBakeryFetchMinimum = 2;

class BakerySortFilter {
  final String id;
  final String filter;
  BakerySortFilter({required this.id, required this.filter});
}

final List<BakerySortFilter> BakerySortFilters = [
  BakerySortFilter(id: '1', filter: '최신순'),
  BakerySortFilter(id: '2', filter: '인기순'),
  BakerySortFilter(id: '3', filter: '리뷰많은순'),
];

class BakerySimpleInfo {
  final String thumbnail;
  final String name;
  final String? description;
  final List<dynamic> bakeryFeature;
  final List<dynamic>? signitureBreads;
  BakerySimpleInfo({
    required this.thumbnail,
    required this.name,
    required this.bakeryFeature,
    this.signitureBreads,
    this.description,
  });
  BakerySimpleInfo.fromJson(Map<String, dynamic> json)
      :
        // thumbnail: json['thumbnail'],
        thumbnail = 'assets/breadImage.jpg',
        name = json['name'],
        description = json['description'],
        bakeryFeature = json['bakeryFeatures']
            .map((bakeryFeature) => bakeryFeature)
            .toList(),
        signitureBreads =
            json['signitureBreads']?.map((bread) => bread['name']).toList();

  @override
  String toString() {
    return 'name: $name,  description: $description, bakeryFeature: $bakeryFeature,  signitureBreads: $signitureBreads';
  }
}
