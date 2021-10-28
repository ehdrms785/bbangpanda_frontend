class DibsDrawerPageQuery {
  /// Query
  ///
  static String getDibsDrawerListQuery({int? count}) => """
    query getDibsDrawerList() {
      getDibsDrawerList() {
        id
        name
        item(count: $count) {
          id
          name
          thumbnail
          price
          discount
          description 
        }
        itemCount
      }
    }
  """;
  static String fetchDibsDrawerItemsQuery() => """
    query fetchDibsDrawerItems(\$drawerId: Int!, \$cursorBreadId: Int) {
      fetchDibsDrawerItems(drawerId: \$drawerId, cursorBreadId: \$cursorBreadId) {
        id
        name
        thumbnail
        description
        price
        discount
        bakeryName
      }
    }
  """;

  /// Mutation ///
  ///

  static String createDibsDrawerMutation() => """
    mutation createDibsDrawer(\$name: String!) {
      createDibsDrawer(name: \$name) {
        ok
        error
        dibsDrawer {
          id
          name
          itemCount
        }
      }
    }
  """;

  static String addItemToDibsDrawerMutation() => """
    mutation addItemToDibsDrawer(\$id: Int!, \$itemId: Int!) {
      addItemToDibsDrawer(id: \$id, itemId: \$itemId) {
        ok
        error
      }
    }
  """;

  static String removeItemToDibsDrawerMutation() => """
    mutation removeItemToDibsDrawer(\$itemId: Int!) {
      removeItemToDibsDrawer( itemId: \$itemId) {
        ok
        error
      }
    }
  """;
  static String deleteDibsDrawerMutation() => """
    mutation deleteDibsDrawer(\$id: Int!) {
      deleteDibsDrawer(id: \$id) {
        ok
        error
      }
    }
  """;

  static String changeDibsDrawerNameMutation() => """
    mutation changeDibsDrawerName(\$id: Int!, \$name: String!) {
      changeDibsDrawerName(id: \$id, name: \$name) {
        ok
        error
      }
    }
  """;
}
