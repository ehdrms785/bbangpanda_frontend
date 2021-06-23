class FindBakeryQuery {
  static String getSimpleBakeriesInfoQuery = """
      query getSimpleBakeriesInfo(\$sortFilterId: String!, \$filterIdList: [String!]!, \$cursorId: Int) {
    getSimpleBakeriesInfo(sortFilterId: \$sortFilterId, filterIdList: \$filterIdList, cursorId: \$cursorId) {
      id
      name
      description
      bakeryFeatures {
        id
        filter
      }
      signitureBreads {
        id
        name
      }
    }
  }

  """;
  static String getSimpleBreadsInfoQuery = """
      query getSimpleBreadsInfo(\$largeCategoryId: String, \$smallCategoryId: String, \$sortFilterId:String!, \$filterIdList: [String], \$cursorId: Int) {
    getSimpleBreadsInfo(largeCategoryId: \$largeCategoryId,smallCategoryId: \$smallCategoryId, sortFilterId: \$sortFilterId, filterIdList: \$filterIdList, cursorId: \$cursorId) {
      id
      name
      bakeryName
      price
      discount
      description
      isSigniture
      breadFeatures {
        id
        filter
      }
    }
  }

  
  """;
  static String getBakeryFilterQuery = """
    query getBakeryFilter() {
      getBakeryFilter() {
        id
        filter
      }
  }
  """;
  static String getBreadFilterQuery = """
    query getBreadFilter() {
      getBreadFilter() {
        id
        filter
      }
  }
  """;

  static String getBreadSmallCategoriesQuery = """
    query getBreadSmallCategories(\$largeCategoryId: String) {
      getBreadSmallCategories(largeCategoryId: \$largeCategoryId) {
        id
        category
      }
  }
  """;
}
