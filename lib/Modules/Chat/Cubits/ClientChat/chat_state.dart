part of 'chat_cubit.dart';

enum ChatS {
  initial,
  sent,
  sending,
  failed,
}

class ChatState extends Equatable {
  final ChatS state;
  final MessageType messageType;
  final Object? companion;

  const ChatState({
    this.state = ChatS.initial,
    this.messageType = MessageType.text,
    this.companion,
  });

  @override
  List<Object?> get props => [state, messageType, companion];

  ChatState copyWith({
    ChatS? state,
    MessageType? messageType,
    Object? companion,
  }) {
    return ChatState(
      state: state ?? this.state,
      messageType: messageType ?? this.messageType,
      companion: companion ?? this.companion,
    );
  }

  @override
  bool? get stringify => true;
}

extension CheckClientChatS on ChatState {
  bool get isInitial => this.state == ChatS.initial;
  bool get isSending => this.state == ChatS.sending;
  bool get isSent => this.state == ChatS.sent;
  bool get isFailed => this.state == ChatS.failed;
}
