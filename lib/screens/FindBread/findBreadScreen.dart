import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/shared/publicValues.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FindBread extends StatefulWidget {
  @override
  _FindBreadState createState() => _FindBreadState();
}

class _FindBreadState extends State<FindBread> {
  final seeProfileQuery = r'''
        query seeProfile($username: String!) {
          seeProfile(username: $username) {
            id
            username
            email
            address
          }
        }
      ''';
  late final QueryOptions options = QueryOptions(
    document: gql(seeProfileQuery),
    variables: {'username': '다로'},
    fetchPolicy: FetchPolicy.cacheFirst,
    cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,

    // pollInterval: Duration(seconds: 5),
  );

  final observableQuery = client.watchQuery(
    WatchQueryOptions(
      document: gql(
        r'''
        query seeProfile($username: String!) {
          seeProfile(username: $username) {
            id
            username
            email
            address
          }
        }
      ''',
      ),
      variables: {'username': '다로'},
      // cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
    ),
  );
  @override
  void initState() {
    super.initState();

    print("하이");
    // observableQuery.stream.listen((QueryResult result) {
    //   if (!result.isLoading && result.data != null) {
    //     if (result.hasException) {
    //       print(result.exception);
    //       return;
    //     }
    //     if (result.isLoading) {
    //       print('loading');
    //       return;
    //     }
    //     print("데이터커밍");
    //     print(result);
    //   }
    // });
  }

  @override
  void dispose() {
    print("바이");
    observableQuery.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // GraphQLConfiguration.setToken('token!!!');
    // print('현재 저장된 토큰 체크 홈 :${LocalStorage('newUser').getItem('token')}');

    // print(
    //     '바뀐 토큰 : token : ${GraphQLConfiguration.httpLink.defaultHeaders.values.first}');

    print("hello world");
    return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height / 20),
          child: AppBar(
            actions: [IconButton(icon: Icon(Icons.ac_unit), onPressed: () {})],
            //AppBar Shadow를 사라져보이게 하기 !
            shadowColor: Colors.transparent,
            centerTitle: true,
            // backgroundColor: Colors.red,
            title: ValueListenableBuilder(
              valueListenable: p_appBarTitleValueNotifier,
              builder: (context, String title, _) {
                return Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Center(
                  child: Text("여기는 빵비교 ",
                      style: Theme.of(context).textTheme.headline2)),
              Query(
                options: options,
                builder: (result, {fetchMore, refetch}) {
                  if (result.isLoading) {
                    print("로딩중");
                    return Container();
                  }
                  // if (!result.isConcrete) {
                  //   print("이게뭐지?");
                  //   return Container();
                  // }
                  print(result);
                  return ElevatedButton(
                      onPressed: () async {
                        var result = client.readQuery(
                            Operation(document: gql(seeProfileQuery))
                                .asRequest());
                        print(result);
                        print("클릭됐지?");
                        // await refetch!();
                      },
                      child: Text("버튼클릭"));
                },
              ),
            ],
          ),
          color: Colors.cyan,
        ));
  }
}
