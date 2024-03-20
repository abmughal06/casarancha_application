import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_widget.dart';
import '../search/search_screen.dart';

class ForwardMessageScreen extends StatefulWidget {
  const ForwardMessageScreen({super.key, required this.message});
  final Message message;

  @override
  State<ForwardMessageScreen> createState() => _ForwardMessageScreenState();
}

class _ForwardMessageScreenState extends State<ForwardMessageScreen> {
  late ChatProvider chatProvider;

  @override
  void dispose() {
    chatProvider.restoreReciverList();
    super.dispose();
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context);
    final search = Provider.of<SearchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          text: appText(context).strSharePost,
          fontSize: 18.sp,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: colorWhite,
        elevation: 0,
        leading: const SizedBox(),
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.close,
              size: 20.w,
              color: colorBlack,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10),
            child: searchTextField(
              context: context,
              controller: searchController,
              onChange: (value) {
                search.searchText(value);
              },
            ),
          ),
          StreamProvider.value(
            value: DataProvider().allUsers(),
            initialData: null,
            catchError: (context, error) => null,
            child: Consumer<List<UserModel>?>(
              builder: (context, users, b) {
                if (users == null) {
                  return Container();
                } else {
                  var currentUser = users
                      .where((element) => element.id == currentUserUID)
                      .first;

                  if (searchController.text.isEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 120.h),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return ForwardMessageTile(
                              callAction: () {
                                chatProvider.forwardMessage(
                                  message: widget.message,
                                  currentUser: currentUser,
                                  appUser: users[index],
                                );
                              },
                              appUser: users[index],
                              currentUser: currentUser,
                              isSent: chatProvider.recieverIds
                                  .contains(users[index].id),
                              message: widget.message);
                        },
                      ),
                    );
                  }
                  if (searchController.text.isNotEmpty) {
                    var searchList = users
                        .where((e) =>
                            e.name.toLowerCase().contains(
                                searchController.text.toLowerCase()) ||
                            e.username
                                .toLowerCase()
                                .contains(searchController.text.toLowerCase()))
                        .toList();
                    return Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 120.h),
                        itemCount: searchList.length,
                        itemBuilder: (context, index) {
                          return ForwardMessageTile(
                            appUser: searchList[index],
                            currentUser: currentUser,
                            isSent: chatProvider.recieverIds
                                .contains(searchList[index].id),
                            message: widget.message,
                            callAction: () {
                              chatProvider.forwardMessage(
                                message: widget.message,
                                currentUser: currentUser,
                                appUser: searchList[index],
                              );
                            },
                          );
                        },
                      ),
                    );
                  }

                  if (users.isEmpty) {
                    return Center(
                      child: TextWidget(
                        text: appText(context).noShares,
                      ),
                    );
                  }
                  return heightBox(1);
                }
              },
            ),
          ),
          CommonButton(
            text: appText(context).strDone,
            height: 58.w,
            verticalOutMargin: 20.w,
            horizontalOutMargin: 20.w,
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }
}

class ForwardMessageTile extends StatelessWidget {
  const ForwardMessageTile({
    super.key,
    required this.currentUser,
    required this.appUser,
    required this.isSent,
    required this.message,
    required this.callAction,
  });

  final Message message;
  final UserModel currentUser;
  final UserModel appUser;
  final bool isSent;
  final VoidCallback callAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                appUser.imageStr != ''
                    ? CircleAvatar(
                        radius: 25,
                        backgroundImage: appUser.imageStr.isEmpty
                            ? null
                            : CachedNetworkImageProvider(
                                appUser.imageStr,
                              ),
                        child: appUser.imageStr.isEmpty
                            ? const Icon(
                                Icons.question_mark,
                              )
                            : null,
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 25,
                        backgroundImage: AssetImage(imgUserPlaceHolder),
                      ),
                widthBox(12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: appUser.username,
                      color: color221,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    heightBox(3.h),
                    TextWidget(
                      text: appUser.name,
                      color: colorAA3,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: isSent
                    ? colorPrimaryA05.withOpacity(0.16)
                    : colorPrimaryA05,
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                onTap: callAction,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                  child: TextWidget(
                    text: isSent
                        ? appText(context).sent
                        : appText(context).strSend,
                    letterSpacing: 0.7,
                    color: isSent ? colorPrimaryA05 : colorFF3,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
