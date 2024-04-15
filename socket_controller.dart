/*
import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:muvr/core/getX/controllers/screenController/chatController/chatController.dart';
import 'package:muvr/models/chat_models/chat_models.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:muvr/core/core.dart';

class SocketController extends GetxController {
  late IO.Socket socket;
  String? userId;
  String? userImage;
  String? userName;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initSocket();
  }

  initSocket() async {
    var appUrl = Get.find<APICalls>();
    socket = IO.io(appUrl.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      Console.debug('Connection established');
    });

    socket.on('getMessageEvent', (newMessage) {
      Console.debug('Connection Disconnection $newMessage');
    });

    socket.on('send-message', (newMessage) {
      Console.debug('recive Message $newMessage');


      if(newMessage["fromId"] == userId || newMessage["toId"] == userId){
        if(Get.isRegistered<ChatController>()){
          var chatController = Get.find<ChatController>();

          // var msgJson = json.decode(newMessage);

          var dt = DateTime.fromMillisecondsSinceEpoch(newMessage["time"]).toLocal();

          chatController.messageList.value?.message?.insert(0,Message(
            sendBy: newMessage["fromId"] == userId ?  "me" : "you",
            msg: newMessage["message"],
            userName: newMessage["fromUserName"],
            userImage: newMessage["fromUserImage"],
            time: DateFormat('dd/MM/yyyy hh:mma').format(dt),
            sendDate: DateFormat('dd/MM/yyyy hh:mma').format(dt),
            type: newMessage["msgType"],
            isFavorite: false,
          ));

          chatController.messageList.refresh();
        }   else if(Get.isRegistered<DashboardScreenController>() && !Get.isRegistered<InboxPageController>() ) {
          var dashBoardController = Get.find<DashboardScreenController>();
          dashBoardController.chatCount = dashBoardController.chatCount + 1;

        }
      }

    });

    socket.onDisconnect((_) => Console.debug('Connection Disconnection'));
    socket.onConnectError((err) => Console.debug("error $err"));
    socket.onError((err) => Console.debug(err));

    userId = await StorageService.getKey(key: StorageConstants.userID);
  }

*/
/*  sendMessage() {
    String message = textEditingController.text.trim();
    if (message.isEmpty) return;
    Map messageMap = {
      'message': message,
      'senderId': userId,
      'receiverId': receiverId,
      'time': DateTime.now().millisecondsSinceEpoch,
    };
    socket.emit('sendNewMessage', messageMap);
  }*//*


  sendTextMessage({required String toId, String? msg,  String? roomId, int? bookingId}) async {
    userId = await StorageService.getKey(key: StorageConstants.userID);
    Map newMessage = {
      "msgType": "text",
      "message": msg,
      "fromId": userId,
      "fromUserName":"${await StorageService.getKey(key: StorageConstants.firstName)}" "${await StorageService.getKey(key: StorageConstants.lastName)}",
      "fromUserImage":"${await StorageService.getKey(key: StorageConstants.profileImage)}",
      "roomId":roomId,
      "bookingId":bookingId ?? "",
      "toId": toId,
      "time": DateTime.now().toUtc().millisecondsSinceEpoch,
    };
    // socket.emit('sendNewMessage', newMessage);
    socket.emit('send-message', newMessage);
  }

  sendMediaMessage({required String toId, String? msg, String? roomId,int? bookingId}) async {
    userId = await StorageService.getKey(key: StorageConstants.userID);
    Map newMessage = {
      "msgType": "media",
      "message": msg,
      "fromUserName":"${await StorageService.getKey(key: StorageConstants.firstName)}" "${await StorageService.getKey(key: StorageConstants.lastName)}",
      "fromUserImage":"${await StorageService.getKey(key: StorageConstants.profileImage)}",
      "fileName":msg,
      "fromId":userId,
      "roomId":roomId,
      "toId": toId,
      "bookingId":bookingId ?? "",
      "time": DateTime.now().toUtc().millisecondsSinceEpoch,
    };
    Console.debug(newMessage,key: "sendMediaMessage");
    socket.emit('send-message', newMessage);
    // socket.emit('sendNewMessage', newMessage);
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}
*/

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:muvr/core/getX/controllers/screenController/chatController/chatController.dart';
import 'package:muvr/models/chat_models/chat_models.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:muvr/core/core.dart';

class SocketController extends GetxController {
  late IO.Socket socket;
  String? userId;
  String? userImage;
  String? userName;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
      initSocket();
  }

  initSocket() async {

    var appUrl = Get.find<APICalls>();
    socket = IO.io(appUrl.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      Console.debug('Connection established');
    });

    socket.on('getMessageEvent', (newMessage) {
      Console.debug('Connection Disconnection $newMessage');
    });

    messageListener();
    trackingMyBooking();
    orderStatus();
    socket.onDisconnect((_) => Console.debug('Connection Disconnection'));
    socket.onConnectError((err) => Console.debug("error $err"));
    socket.onError((err) => Console.debug(err));

    userId = await StorageService.getKey(key: StorageConstants.userID);
  }


  sendTextMessage({required String toId, String? msg,  String? roomId, int? bookingId}) async {
    userId = await StorageService.getKey(key: StorageConstants.userID);
    Map newMessage = {
      "msgType": "text",
      "message": msg,
      "fromId": userId,
      "fromUserName":"${await StorageService.getKey(key: StorageConstants.firstName)}" "${await StorageService.getKey(key: StorageConstants.lastName)}",
      "fromUserImage":"${await StorageService.getKey(key: StorageConstants.profileImage)}",
      "roomId":roomId,
      "bookingId":bookingId ?? "",
      "toId": toId,
      "time": DateTime.now().toUtc().millisecondsSinceEpoch,
    };
    // socket.emit('sendNewMessage', newMessage);
    socket.emit('send-message', newMessage);
  }

  sendMediaMessage({required String toId, String? msg, String? roomId,int? bookingId}) async {
    userId = await StorageService.getKey(key: StorageConstants.userID);
    Map newMessage = {
      "msgType": "media",
      "message": msg,
      "fromUserName":"${await StorageService.getKey(key: StorageConstants.firstName)}" "${await StorageService.getKey(key: StorageConstants.lastName)}",
      "fromUserImage":"${await StorageService.getKey(key: StorageConstants.profileImage)}",
      "fileName":msg,
      "fromId":userId,
      "roomId":roomId,
      "toId": toId,
      "bookingId":bookingId ?? "",
      "time": DateTime.now().toUtc().millisecondsSinceEpoch,
    };
    Console.debug(newMessage,key: "sendMediaMessage");
    socket.emit('send-message', newMessage);
    // socket.emit('sendNewMessage', newMessage);
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  ///Socket Message Listener
  void messageListener() {
    socket.on('send-message', (newMessage) {
      Console.debug('recive Message $newMessage');


      if(newMessage["fromId"] == userId || newMessage["toId"] == userId){
        if(Get.isRegistered<ChatController>()){
          var chatController = Get.find<ChatController>();

          // var msgJson = json.decode(newMessage);

          var dt = DateTime.fromMillisecondsSinceEpoch(newMessage["time"]).toLocal();

          chatController.messageList.value?.message?.insert(0,Message(
            sendBy: newMessage["fromId"] == userId ?  "me" : "you",
            msg: newMessage["message"],
            userName: newMessage["fromUserName"],
            userImage: newMessage["fromUserImage"],
            time: DateFormat('dd/MM/yyyy hh:mma').format(dt),
            sendDate: DateFormat('dd/MM/yyyy hh:mma').format(dt),
            type: newMessage["msgType"],
            isFavorite: false,
          ));

          chatController.messageList.refresh();
        }   else if(Get.isRegistered<DashboardScreenController>() && !Get.isRegistered<InboxPageController>() ) {
          var dashBoardController = Get.find<DashboardScreenController>();
          dashBoardController.chatCount = dashBoardController.chatCount + 1;

        }
      }

    });
  }

  ///Track My Booking

  void trackingMyBooking(){
    socket.on('track-booking', (trackingDetail) {
    //  Console.debug('trackingDetail Message $trackingDetail');
      if(trackingDetail["customerId"] == userId){
        ///need to check if detail screen controller alive or not then getting data and show to map pointer
        if(Get.isRegistered<DriverTrackingScreenController>()){
          var driverScreenController = Get.find<DriverTrackingScreenController>();
          // Console.debug('track-booking $trackingDetail');
          // Console.debug(driverScreenController.trackLng.value, key: 'langitudexkx');
          // Console.debug(driverScreenController.trackLat.value, key: 'lantitudexkx');
          driverScreenController.trackLat.value = trackingDetail["lat"];
          driverScreenController.trackLng.value = trackingDetail["long"];
          driverScreenController.lat.value = CommonFunctions.safeParseDouble(trackingDetail["lat"]);
          driverScreenController.long.value = CommonFunctions.safeParseDouble(trackingDetail["long"]);

          driverScreenController.updateEstimateTimeBasedOnSocket(CommonFunctions.safeParseDouble(trackingDetail["lat"]),CommonFunctions.safeParseDouble(trackingDetail["long"]));

        }
      }

    });
  }



  void orderStatus(){
    socket.on('order-status', (orderStatus) {
     // Console.debug('order-status $orderStatus');
     /*  List<dynamic> localUserId = orderStatus['muvrId'] as List<dynamic>;
      Console.debug(localUserId, key: 'OrderDelivery');*/
      Console.debug(userId, key: 'OrderDelivery');
      if(orderStatus["userId"] == CommonFunctions.safeParseInt(userId)){
      /*  var driverScreenController = Get.find<DriverTrackingScreenController>();
        driverScreenController.deliveryStatus.value = orderStatus['deliveryStatus'];
        Console.debug(orderStatus['deliveryStatus'], key: 'OrderDelivery');
        driverScreenController.getStepForTrack();
        Console.debug( driverScreenController.step.value, key: 'driverScreenControllerdeliveryStatus');
        driverScreenController.deliveryStatus.refresh();*/
        
        ///need to check if detail screen controller alive or not then getting data and show to map pointer
        if(Get.isRegistered<DriverTrackingScreenController>()){
          var driverScreenController = Get.find<DriverTrackingScreenController>();
          driverScreenController.deliveryStatus.value = orderStatus['deliveryStatus'];
          if(driverScreenController.deliveryTimingStatus.value.isEmpty){
            print("zdcvsgdvc order-status ${driverScreenController.deliveryTimingStatus.value}");
            driverScreenController.deliveryTimingStatus.value = orderStatus['currentTime'];
          }
          driverScreenController.getTrackDeliveryBooking.value?.deliveryStatus = "";
          Console.debug(orderStatus['deliveryStatus'], key: 'OrderDelivery');
          driverScreenController.getStepForTrack();
          Console.debug( driverScreenController.step.value, key: 'driverScreenControllerdeliveryStatus');
          driverScreenController.deliveryStatus.refresh();
          print("zdcvsgdvc order-status 1 ${driverScreenController.deliveryTimingStatus.value}");
          //currentTime {deliveryStatus: PICK_UP_ARRIVED, bookingId: 1199, muvrId: [121, 122], userId: 5, currentTime: 2023-10-10T06:52:46.312Z}
        }
      }

    });
  }

}
