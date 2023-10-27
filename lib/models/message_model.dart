class Chats_Model {
  final chatId,
      messageId,
      senderId,
      receiverId,
      timeSent,
      message,
      hasAttachment,
      attachmentUrl,
      deletedBy,
      deletedForAll,
      chatDeletedBy;

  Chats_Model({
    this.chatId,
    this.messageId,
    this.senderId,
    this.receiverId,
    this.timeSent,
    this.message,
    this.hasAttachment,
    this.attachmentUrl,
    this.deletedBy,
    this.deletedForAll,
    this.chatDeletedBy,
  });

  factory Chats_Model.fromJson(Map<String, dynamic> json){
    return Chats_Model(
        chatId: json["chatId"],
        messageId: json["messageId"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        timeSent: json["timeSent"],
        message: json["message"],
        hasAttachment: json["hasAttachment"],
        attachmentUrl: json["attachmentUrl"],
        deletedBy: json["deletedBy"],
        deletedForAll: json["deletedForAll"],
        chatDeletedBy: json["chatDeletedBy"],
    );
  }
}
