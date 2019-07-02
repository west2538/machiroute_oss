App.appearance = App.cable.subscriptions.create({
  channel:'AppearanceChannel'
}, {
  received: function(data) {
    var user = JSON.parse(data)

    if (user.display_name != null){
      if (user.online === true){
        if (document.getElementById("users-list1") != null){
        var element = document.getElementById("users-list1");
          element.insertAdjacentHTML("afterbegin", "<li class='list-unstyled font-weight-bold text-success usershadow'>" + user.display_name + " <span class='oi oi-account-login' title='" + user.online_at + "'></span> <small class='text-secondary'><span data-livestamp='" + user.online_at + "'></span></small></li>");
        var element = document.getElementById("users-list2");
          element.insertAdjacentHTML("afterbegin", "<li class='list-unstyled font-weight-bold text-success usershadow'>" + user.display_name + " <span class='oi oi-account-login' title='" + user.online_at + "'></span> <small class='text-secondary'><span data-livestamp='" + user.online_at + "'></span></small></li>");
        var element = document.getElementById("users-list3");
          element.insertAdjacentHTML("afterbegin", "<li class='list-unstyled font-weight-bold text-success usershadow'>" + user.display_name + " <span class='oi oi-account-login' title='" + user.online_at + "'></span> <small class='text-secondary'><span data-livestamp='" + user.online_at + "'></span></small></li>");
        }
      };
      if (user.online === false){
        if (document.getElementById("users-list1") != null){
        var element = document.getElementById("users-list1");
          element.insertAdjacentHTML("afterbegin", "<li class='list-unstyled font-weight-bold text-danger usershadow'>" + user.display_name + " <span class='oi oi-account-logout' title='" + user.online_at + "'></span> <small class='text-secondary'><span data-livestamp='" + user.online_at + "'></span></small></li>");
        var element = document.getElementById("users-list2");
          element.insertAdjacentHTML("afterbegin", "<li class='list-unstyled font-weight-bold text-danger usershadow'>" + user.display_name + " <span class='oi oi-account-logout' title='" + user.online_at + "'></span> <small class='text-secondary'><span data-livestamp='" + user.online_at + "'></span></small></li>");
        var element = document.getElementById("users-list3");
          element.insertAdjacentHTML("afterbegin", "<li class='list-unstyled font-weight-bold text-danger usershadow'>" + user.display_name + " <span class='oi oi-account-logout' title='" + user.online_at + "'></span> <small class='text-secondary'><span data-livestamp='" + user.online_at + "'></span></small></li>");
        }
      };
    };
  }
});