App.notification = App.cable.subscriptions.create({
  channel:'NotificationChannel'
}, {
  received: function(data) {

    var current_uid = document.getElementsByName('current_user')[0].content;
    if (data.notified_type === 'クリア' && current_uid === data.uid ){
        var target = document.getElementById("dropdownMenu1");
        target.className = "btn btn-sm btn-default btn-success dropdown-toggle";
        var element = document.getElementById("mstdn_notification");
        element.insertAdjacentHTML("afterbegin", "<a href='/notifications/" + data.id + "/link_through' class='list-group-item pb-0' style='width:210px;'><div class='small clearfix'><p class='mb-0'><br><span class='font-weight-bold'>あなたのサブクエストが<br><span class='font-weight-bold'>" + data.notified_type + "</span>されました！</p><p class='mt-0' style='float:right;'><span data-livestamp='" + data.created_at + "'></span></p></div></a>");
    };

  },

  speak: function(uid,id,user_id,notified_type,created_at) {
    return this.perform('speak', { uid: user.uid, id: notification.id, user_id: notification.user_id, notified_type: notification.notified_type, created_at: notification.created_at });
  }

});