import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import 'package:hive/hive.dart';

class GraphQLConfiguration {
  static Link? link;
  static HttpLink httpLink = HttpLink('https://4b81eda99e47.ngrok.io/graphql',
      defaultHeaders: {'Authorization': ""});

  static void setToken(String token) {
    // AuthLink alink = AuthLink(getToken: () async => 'Bearer ' + token);
    // GraphQLConfiguration.link = alink.concat(GraphQLConfiguration.httpLink);
    httpLink.defaultHeaders.update('Authorization', (_) => 'Bearer $token');
  }

  Map<String, String> getToken() {
    var token = Hive.box('auth').get('token');
    return {'Authorization': token};
  }

  static void removeToken() {
    GraphQLConfiguration.link = null;
  }

  static Link getLink() {
    if (link == null) {
      return GraphQLConfiguration.httpLink;
    }
    return GraphQLConfiguration.link!;
  }

  // Future<ValueNotifier<GraphQLClient>> getClient() async {
  //   final store = await HiveStore.open(path: 'my/cache/path');
  //   return ValueNotifier(
  //     GraphQLClient(
  //       link: getLink(),
  //       cache: GraphQLCache(store: store),
  //     ),
  //   );
  // }

  ValueNotifier<GraphQLClient> getClient = ValueNotifier(
    GraphQLClient(
      link: getLink(),
      cache: GraphQLCache(
        store: InMemoryStore(),
      ),
    ),
  );

  static GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(
        store: InMemoryStore(),
      ),
      link: getLink(),
    );
  }
}

final GraphQLClient client = GraphQLConfiguration.clientToQuery();
