import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import 'package:hive/hive.dart';

class GraphQLConfiguration {
  static String? token = 'Bearer ${Hive.box("auth").get('token') ?? ''}';

  static HttpLink httpLink = HttpLink('https://7a27ee8c225f.ngrok.io/graphql');
  // static Link? link;

  static ValueNotifier<GraphQLClient> graphqlInit() {
    final AuthLink authLink = AuthLink(getToken: () => token);
    final Link link = authLink.concat(httpLink);
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
    return client;
  }

  static void setToken(String? newToken) {
    token = newToken;
  }

  static GraphQLClient clientToQuery() {
    AuthLink authLink = AuthLink(getToken: () => token);
    final Link link = authLink.concat(httpLink);

    return GraphQLClient(
      cache: GraphQLCache(
        store: HiveStore(),
      ),
      link: link,
    );
  }
}

final GraphQLClient client = GraphQLConfiguration.clientToQuery();
