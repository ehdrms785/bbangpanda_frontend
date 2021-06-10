import 'package:bbangnarae_frontend/graphqlConfig.dart';
import 'package:bbangnarae_frontend/screens/MyPage/editProfileScreen/editProfileController.dart';
import 'package:bbangnarae_frontend/screens/MyPage/myPageController.dart';
import 'package:bbangnarae_frontend/screens/MyPage/support/query.dart';
import 'package:bbangnarae_frontend/shared/dialog/snackBar.dart';
import 'package:bbangnarae_frontend/shared/sharedValidator.dart';
import 'package:bbangnarae_frontend/shared/sharedWidget.dart';
import 'package:bbangnarae_frontend/theme/textFieldTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditProfileScreen extends StatelessWidget {
  late final EditProfileController editProfCtr = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            MySliverAppBar(
              title: "회원정보 수정",
              leading: backArrowButtton(onPressed: () {
                editProfCtr.isSomeFieldChanged(false);
                Get.back();
              }),
              actions: [
                Obx(
                  () => SizedBox(
                    child: TextButton(
                      child: Text("수정"),
                      onPressed: editProfCtr.isSomeFieldChanged.value &&
                              !editProfCtr.isLoading.value
                          ? () async {
                              try {
                                editProfCtr.isLoading(true);
                                final result = await client.mutate(
                                  MutationOptions(
                                      document: gql(
                                        (MyPageQuery.editProfilelMutation),
                                      ),
                                      variables: {
                                        'username':
                                            editProfCtr.nameTextController.text,
                                        'phonenumber':
                                            editProfCtr.phoneTextController.text
                                      }),
                                );
                                Get.find<MypageController>()
                                        .userResult['username'] =
                                    editProfCtr.nameTextController.text;
                                print(result);
                                if (!result.hasException) {
                                  if (result.data!['editProfile']['ok']) {
                                    editProfCtr.originalEmail =
                                        editProfCtr.emailTextController.text;
                                    editProfCtr.originalName =
                                        editProfCtr.nameTextController.text;
                                    editProfCtr.originalPhone =
                                        editProfCtr.phoneTextController.text;
                                    editProfCtr.setSomeFieldChange();
                                  }
                                }
                              } catch (err) {
                                print(err);
                              } finally {
                                editProfCtr.isLoading(false);
                              }
                            }
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 3.0.h),
                  child: Container(
                    child: Obx(() {
                      if (editProfCtr.isLoading.value) {
                        return Center(child: CupertinoActivityIndicator());
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          commonTextField(
                              label: "이메일",
                              controller: editProfCtr.emailTextController,
                              originValue: editProfCtr.originalEmail,
                              readOnly: true,
                              enabled: false),
                          commonTextField(
                            label: "이름",
                            controller: editProfCtr.nameTextController,
                            originValue: editProfCtr.originalName,
                            onChanged: (val) {
                              if (val != editProfCtr.originalName) {
                                editProfCtr.isSomeFieldChanged(true);
                              } else {
                                editProfCtr.setSomeFieldChange();
                              }
                            },
                          ),
                          commonTextField(
                              label: "휴대폰 번호",
                              controller: editProfCtr.phoneTextController,
                              originValue: editProfCtr.originalPhone,
                              readOnly: true,
                              onTap: () async {
                                final chnagedPhonenumber =
                                    await Get.toNamed('/smsAuth');
                                if (chnagedPhonenumber != null) {
                                  if (chnagedPhonenumber != '') {
                                    editProfCtr.phoneTextController.text =
                                        chnagedPhonenumber;
                                    editProfCtr.isSomeFieldChanged(true);
                                  }
                                }
                              }),
                        ],
                      );
                    }),
                  ),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
