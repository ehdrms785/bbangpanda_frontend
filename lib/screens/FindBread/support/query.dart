class FindBakeryQuery {
  static String getFilteredBakeryListQuery = """
      query getFilteredBakeryList(\$filterIdList: [String!]!, \$cursorId: Int) {
    getFilteredBakeryList(filterIdList: \$filterIdList, cursorId: \$cursorId) {
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
  static String getBakeryFilterQuery = """
    query getBakeryFilter() {
      getBakeryFilter() {
        id
        filter
      }
  }
  """;
}
