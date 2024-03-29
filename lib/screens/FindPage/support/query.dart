class FindBakeryQuery {
  static String getSimpleBakeriesInfoQuery = """
      query getSimpleBakeriesInfo(\$sortFilterId: String!, \$filterIdList: [String!]!, \$cursorBakeryId: Int) {
    getSimpleBakeriesInfo(sortFilterId: \$sortFilterId, filterIdList: \$filterIdList, cursorBakeryId: \$cursorBakeryId) {
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
      isGotDibs
    }
  }

  """;
  static String getSimpleMarketOrdersInfoQuery = """
      query getSimpleMarketOrdersInfo(\$sortFilterId: String!, \$filterIdList: [String!]!, \$cursorMarketOrderId: Int) {
    getSimpleMarketOrdersInfo(sortFilterId: \$sortFilterId, filterIdList: \$filterIdList, cursorMarketOrderId: \$cursorMarketOrderId) {
        id
        bakery {
          id
          name
        }
        marketOrderFeatures {
          id
          filter
        }
        orderName
        orderStartDate
        orderEndDate
        lineUpBreads{
          id
          name
        }
        signitureBreads {
          id
          name
          thumbnail
        }
    }
  }

  """;
  static String searchBakeriesQuery = """
      query searchBakeries(\$searchTerm: String!,\$sortFilterId: String!, \$filterIdList: [String!]!, \$cursorBakeryId: Int) {
    searchBakeries(searchTerm:\$searchTerm,sortFilterId: \$sortFilterId, filterIdList: \$filterIdList, cursorBakeryId: \$cursorBakeryId) {
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
  static String searchMarketOrdersQuery = """
      query searchMarketOrders(\$searchTerm: String!,\$sortFilterId: String!, \$filterIdList: [String!]!, \$cursorMarketOrderId: Int) {
    searchMarketOrders(searchTerm:\$searchTerm,sortFilterId: \$sortFilterId, filterIdList: \$filterIdList, cursorMarketOrderId: \$cursorMarketOrderId) {
      id
      bakery {
        id
        name
      }
      marketOrderFeatures {
        id
        filter
      }
      orderName
      orderStartDate
      orderEndDate
      lineUpBreads{
        id
        name
      }
      signitureBreads {
        id
        name
      }
    }
  }

  """;
  static String searchBreadsQuery = """
      query searchBreads(\$searchTerm: String!,\$sortFilterId: String!, \$filterIdList: [String!]!, \$cursorBreadId: Int) {
    searchBreads(searchTerm: \$searchTerm,sortFilterId: \$sortFilterId, filterIdList: \$filterIdList, cursorBreadId: \$cursorBreadId) {
      id
      thumbnail
      bakeryName
      name
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
  static String getSimpleBreadsInfoQuery = """
      query getSimpleBreadsInfo(\$bakeryId: Int,\$largeCategoryId: String, \$smallCategoryId: String, \$sortFilterId:String!, \$filterIdList: [String], \$cursorBreadId: Int) {
    getSimpleBreadsInfo(bakeryId: \$bakeryId,largeCategoryId: \$largeCategoryId,smallCategoryId: \$smallCategoryId, sortFilterId: \$sortFilterId, filterIdList: \$filterIdList, cursorBreadId: \$cursorBreadId) {
      id
      thumbnail
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
      isGotDibs
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
  static String getMarketOrderFilterQuery = """
    query getMarketOrderFilter() {
      getMarketOrderFilter() {
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

  // =========== Bakery Detail Query
  static String getBakeryDetailQuery = """
      query getBakeryDetail(\$bakeryId: Int!) {
    getBakeryDetail(bakeryId: \$bakeryId) {
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
        breadLargeCategories {
          id
          category
        }
        breadSmallCategories {
          id
          category
        }
        isGotDibs
        gotDibsUserCount
      
    }
  }
  """;

  static String toggleDibsBakeryMutation = """
  mutation toggleDibsBakery(\$bakeryId: Int!) {
    toggleDibsBakery(bakeryId: \$bakeryId) {
      ok
      error
    }
  }
  """;

  static String toggleDibsBreadMutation = """
  mutation toggleDibsBread(\$breadId: Int!) {
    toggleDibsBread(breadId: \$breadId) {
      ok
      error
    }
  }
  """;

  //////////////////////
  /// Bread ////
  /// ///////////////////
  static String getBreadDetailQuery = """
      query getBreadDetail(\$breadId: Int!) {
    getBreadDetail(breadId: \$breadId) {
      bread {
        id
        name
        thumbnail
        costPrice
        price
        discount
        description
        detailDescription
        isGotDibs
        gotDibsUserCount
      }
       bakery {
          id
          name
          thumbnail
          bakeryFeatures {
            id
            filter
          }
          gotDibsUserCount
          isGotDibs
        }
    }
  }
  """;
}
