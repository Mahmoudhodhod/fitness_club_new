import 'dart:io';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:the_coach/Modules/Payment/Widgets/vip_visible.dart';
import 'package:the_coach/Modules/Payment/payment.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Chat/chat_module.dart';
import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

enum ChatAction { normal, uploading, recording }

class ChatScreen extends StatefulWidget {
  final Room? room;
  const ChatScreen({
    Key? key,
    this.room,
  }) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  late final TextEditingController _messagesTextController;
  late final Stream<QuerySnapshot<Object?>> _msgStream;

  ChatAction _action = ChatAction.normal;

  Room? get room => widget.room;

  @override
  void initState() {
    _messagesTextController = TextEditingController();
    _msgStream = context.read<ChatCubit>().watchChat(room?.id.toString());
    super.initState();
  }

  @override
  void dispose() {
    _messagesTextController.dispose();
    AudioDriver.instance().dispose();
    super.dispose();
  }

  void _changeAction(ChatAction action) {
    if (action == _action) return;
    if (mounted) setState(() => _action = action);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) async {
        final isText = state.messageType == MessageType.text;
        if (state.isSending) {
          if (!isText) {
            _changeAction(ChatAction.uploading);
          }
        } else if (state.isSent) {
          if (!isText) _changeAction(ChatAction.normal);
        } else if (state.isFailed) {
          CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr())
              .show(context);
          _changeAction(ChatAction.normal);
        }
      },
      child: KeyboardDismissed(
        child: Scaffold(
          appBar: CAppBar(
            elevation: 5,
            headerWidget: _buildHeaderText(),
            actions: [
              VIPBuilder(builder: (context, isVIP) {
                if (isVIP) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: VIPIcon(),
                );
              }),
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: StreamBuilder<QuerySnapshot<Object?>>(
                    stream: _msgStream,
                    builder: (context, snapshot) {
                      final querySnapshot = snapshot.data;
                      if (querySnapshot == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final messages = querySnapshot.docs
                          .map((doc) => ChatCubit.fromDoc(doc))
                          .toList();
                      if (messages.isEmpty) {
                        return Center(
                            child: Text(LocaleKeys
                                .general_titles_chat_send_message
                                .tr()));
                      }
                      return _buildChatMessages(messages);
                    },
                  ),
                ),
                Positioned.fill(
                  top: null,
                  child: VIPBuilder(
                    builder: (context, isVip) {
                      if (isVip) return _buildSendSection();
                      return Stack(
                        clipBehavior: ui.Clip.none,
                        children: [
                          _buildSendSection(),
                          PositionedDirectional(
                            start: 8,
                            top: -10,
                            child: VIPIcon(
                              size: 35,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    if (room != null) {
      return Row(
        children: [
          if (room!.user.image != null) CCircleAvatar(url: room!.user.image!),
          Space.h10(),
          Text(room!.user.name!),
        ],
      );
    } else {
      return Text(LocaleKeys.drawer_chat_with_coach.tr());
    }
  }

  Widget _buildSendSection() {
    if (_action == ChatAction.recording) {
      return Recorder(
        onSend: (file) async {
          _changeAction(ChatAction.normal);
          final isVip = await isCurrentUserVIP(context);

          if (isVip) return _attachAudio(file);

          // .. show dialog
          VIPDialog().show(context);
        },
        onCancel: () => _changeAction(ChatAction.normal),
      );
    } else if (_action == ChatAction.uploading) {
      return Container(
        color: appTheme.scaffoldBackgroundColor,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return Container(
      color: appTheme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: Row(
          children: [
            Space.h10(),
            Expanded(child: _buildInputTextField()),
            _buildSendIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessages(List<Message> messages) {
    return ListView.separated(
      reverse: true,
      itemCount: messages.length,
      padding: EdgeInsets.fromLTRB(20, 0, 20, screenSize.height * 0.1),
      separatorBuilder: (context, index) => const SizedBox(height: 5),
      itemBuilder: (context, index) {
        final message = messages[index];
        final type = context.read<ChatCubit>().getBubbleType(message);
        final createdAt =
            DateTime.fromMillisecondsSinceEpoch(message.timeStamp);
        switch (message.type) {
          case MessageType.text:
            return TextBubble(
              text: message.content,
              type: type,
              createdAt: createdAt,
            );
          case MessageType.image:
            return ImageBubble(
              imagePath: message.content,
              type: type,
              createdAt: createdAt,
            );
          case MessageType.audio:
            return AudioBubble(
              audioPath: message.content,
              type: type,
              createdAt: createdAt,
            );
        }
      },
    );
  }

  Widget _buildInputTextField() {
    return TextField(
      controller: _messagesTextController,
      textCapitalization: TextCapitalization.sentences,
      maxLines: 3,
      minLines: 1,
      autofocus: true,
      textDirection: ui.TextDirection.rtl,
      decoration: InputDecoration(
        suffixIcon: _buildCameraIcon(),
        filled: true,
        fillColor: CColors.switchable(context,
            dark: CColors.lightBlack, light: Colors.grey.shade300),
        isDense: true,
        hintText: "Aa",
        border: OutlineInputBorder(
          borderRadius: KBorders.bc20,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCameraIcon() {
    return VIPVisible(
      child: Visible<TextEditingValue>(
        valueListenable: _messagesTextController,
        predicate: (_, value) => value.text.isEmpty,
        child: IconButton(
          onPressed: _pickImage,
          color: CColors.switchable(
            context,
            dark: Colors.white60,
            light: CColors.primary(context),
          ),
          icon: Icon(Icons.camera_alt_rounded),
        ),
        replacement: const SizedBox.shrink(),
      ),
      replacement: const SizedBox.shrink(),
    );
  }

  Widget _buildSendIcon() {
    return Visible<TextEditingValue>(
      // enable: false,
      valueListenable: _messagesTextController,
      predicate: (_, value) => value.text.isNotEmpty,
      child: IconButton(
        onPressed: () async {
          final isVip = await isCurrentUserVIP(context);
          if (isVip) return _sendTextMessage();

          // .. show dialog
          VIPDialog().show(context);
        },
        color: CColors.secondary(context),
        icon: const Icon(Icons.send),
      ),
      replacement: Padding(
        padding: const EdgeInsetsDirectional.only(start: 10),
        child: _buildMicrophone(),
      ),
    );
  }

  Widget _buildMicrophone() {
    return CircleAvatar(
      backgroundColor: CColors.switchableFancyBlack,
      child: IconButton(
        onPressed: _startAudioRecording,
        color: CColors.secondary(context),
        icon: const Icon(Icons.mic),
      ),
    );
  }

  //######## Start Of Text ########

  void _sendTextMessage() {
    final text = _messagesTextController.text.trim();
    if (text.isEmpty) return;
    final message =
        ChatMessage(type: MessageType.text, content: text, roomID: room?.id);
    context.read<ChatCubit>().sendMessage(message);
    _messagesTextController.clear();
  }

  //######## End Of Text ########

  //######## Start Of Image ########
  void _pickImage() async {
    try {
      final pickedImages =
          await MediaController.instance.openSheetAndPickImage(context);
      if (pickedImages == null) return;
      final imageFile = pickedImages.first;
      appLogger.d(imageFile.path);
      final message = ChatMessage(type: MessageType.image, roomID: room?.id);
      context.read<ChatCubit>().sendMessage(message, file: imageFile);
    } on Exception catch (e, stacktrace) {
      appLogger.e(e, e, stacktrace);
      CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr())
          .showWithoutContext();
    }
  }
  //######## End Of Image ########

  //######## Start Of Audio ########
  void _startAudioRecording() => _changeAction(ChatAction.recording);

  void _attachAudio(File? audioFile) async {
    try {
      if (audioFile == null) throw AppException('Audio file is null');
      final message = ChatMessage(type: MessageType.audio, roomID: room?.id);
      await AudioDriver.instance().resetAllRegisteredPlayers();
      appLogger.d("Audio players were stopped");
      context.read<ChatCubit>().sendMessage(message, file: audioFile);
    } on Exception catch (e, stacktrace) {
      appLogger.e(e, e, stacktrace);
      CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr())
          .showWithoutContext();
    }
  }
  //######## End Of Audio ########
}
