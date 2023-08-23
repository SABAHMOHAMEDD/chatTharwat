import 'package:chat_tharwat/core/cache_helper.dart';
import 'package:chat_tharwat/features/layout/my_chats/cubit/private_chats_cubit.dart';
import 'package:chat_tharwat/features/layout/my_chats/cubit/private_chats_states.dart';
import 'package:chat_tharwat/features/register/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constance/constants.dart';
import '../../../../core/widgets/chat_bubble.dart';

class PrivateChatScreen extends StatefulWidget {
  static const routeName = "PrivateChatScreen";

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var userModel = ModalRoute.of(context)!.settings.arguments as UserModel;

    return Builder(
      builder: (context) {
        PrivateChatsCubit.get(context).GetMessages(receiverId: userModel.uId);
        return Scaffold(
            backgroundColor: KSecondryColor,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              elevation: 0,
              toolbarHeight: 100,
              leading: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: IconButton(
                  color: KPrimaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ),
              backgroundColor: KSecondryColor,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                userModel.name ?? "",
                style: TextStyle(color: KPrimaryColor),
              ),
            ),
            body: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45))),
              child: Column(
                children: [
                  Expanded(child: Builder(
                    builder: (context) {
                      return BlocConsumer<PrivateChatsCubit,
                          PrivateChatsStates>(
                        listener: (context, stats) {},
                        builder: (context, stats) {
                          var messages =
                              PrivateChatsCubit.get(context).messages;
                          return ListView.builder(
                              controller: scrollController,
                              itemCount: PrivateChatsCubit.get(context)
                                  .messages
                                  .length,
                              shrinkWrap: false,
                              itemBuilder: (context, index) {
                                print('yyyyyyyyyyyyyyyyyyyyyyyyyyyyyy');
                                print(uId);
                                print('yyyyyyyyyyyyyyyyyyyyyyyyyyyyyy');

                                return CacheHelper.getData(key: 'uId') ==
                                        messages[index].senderId
                                    ? ChatBubble(
                                        message: messages[index].message ?? "",
                                      )
                                    : ChatBubbleFriend(
                                        message: messages[index].message ?? "",
                                        userBubbleColor: Colors.grey.shade200,
                                        isPrivateChat: true,
                                      );
                              });
                        },
                      );
                    },
                  )),
                  Container(
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8),
                      child: TextField(
                        onSubmitted: (message) {
                          messageController.clear();
                        },
                        controller: messageController,
                        //   maxLines: null,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        cursorColor: KPrimaryColor,
                        style: const TextStyle(color: KPrimaryColor),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  print(
                                      'meeeeeeeeeeee llllllllllllllllllllllllllllllllllllllllllllllll');
                                  print(CacheHelper.getData(key: 'uId'));
                                  print(
                                      'other oneeeeeee llllllllllllllllllllllllllllllllllllllllllllllll');
                                  print(CacheHelper.getData(key: 'userId'));

                                  PrivateChatsCubit.get(context)
                                      .sendPrivateMessage(
                                          receiverId: CacheHelper.getData(
                                              key: 'userId'),
                                          dateTime: DateTime.now().toString(),
                                          message: messageController.text,
                                          senderId:
                                              CacheHelper.getData(key: 'uId'));

                                  messageController.clear();
                                  scrollController.jumpTo(scrollController
                                      .position.maxScrollExtent);
                                  scrollController.animateTo(
                                    scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeIn,
                                  );
                                },
                                icon: const Icon(Icons.send,
                                    color: KPrimaryColor)),
                            hintText: "Send a message",
                            hintStyle: const TextStyle(color: KPrimaryColor),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: KSecondryColor),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18),
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18),
                                ),
                                borderSide: BorderSide(color: KSecondryColor)),
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18),
                                ),
                                borderSide: BorderSide(color: Colors.white))),
                      ),
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }
}
