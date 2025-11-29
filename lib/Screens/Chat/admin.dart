import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Chat/chat_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'chat.dart';

class AdminChatScreen extends StatefulWidget {
  const AdminChatScreen({Key? key}) : super(key: key);

  @override
  _AdminChatScreenState createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  late final Stream<QuerySnapshot<Object?>> _roomsStream;

  @override
  void initState() {
    _roomsStream = context.read<ChatCubit>().watchRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: !Platform.isIOS,
        child: CustomScrollView(
          slivers: [
            CAppBar(
              sliverStyle: const SliverStyle(),
              header: LocaleKeys.drawer_chat_with_users.tr(),
            ),
            StreamBuilder<QuerySnapshot<Object?>>(
              stream: _roomsStream,
              builder: (context, snapshot) {
                final querySnapshot = snapshot.data;
                if (querySnapshot == null) {
                  return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()));
                }
                final rooms = querySnapshot.docs
                    .map((doc) => ChatCubit.roomFromDoc(doc))
                    .toList();
                if (rooms.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                          LocaleKeys.general_titles_chat_no_active_chats.tr()),
                    ),
                  );
                }
                return _buildBody(rooms);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody(List<Room> rooms) {
    return SliverPadding(
      padding: EdgeInsets.zero,
      sliver: SliverList(
        delegate: separatorSliverChildDelegate(
          separatorBuilder: (context, index) =>
              const Divider(height: 0, indent: 20),
          itemBuilder: (context, index) {
            final room = rooms[index];
            final latestMessage = room.latestMessage;
            final user = room.user;
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChatScreen(room: room)),
                );
              },
              leading: CCircleAvatar(radius: 30, url: user.image!),
              title: Text(
                user.name ?? "-",
                style: TextStyle(
                  color: CColors.switchableBlackAndWhite,
                ),
              ),
              subtitle: _buildChatRoomSubtitle(latestMessage),
              trailing: IconDirectional(Icons.arrow_back),
            );
          },
          childCount: rooms.length,
        ),
      ),
    );
  }

  Widget _buildChatRoomSubtitle(Message? message) {
    final theme = Theme.of(context).textTheme;
    if (message == null) return const SizedBox.shrink();
    if (message.type == MessageType.audio) {
      return Text(
        LocaleKeys.general_titles_chat_sent_voice_note,
        style: TextStyle(
          color: CColors.switchableBlackAndWhite,
        ),
      ).tr();
    } else if (message.type == MessageType.image) {
      return Text(
        LocaleKeys.general_titles_chat_sent_image,
        style: TextStyle(
          color: CColors.switchableBlackAndWhite,
        ),
      ).tr();
    } else {
      return Text(
        message.content,
        style: theme.bodySmall?.copyWith(
          color: CColors.switchableBlackAndWhite,
        ),
      ).subText(50);
    }
  }
}
