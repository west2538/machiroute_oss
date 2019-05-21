App.delete = App.cable.subscriptions.create "DeleteChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    # 該当投稿の削除
    id = "#" + data['id']
    console.log(id)
    $(id).remove()

  delete: (id)->
    @perform 'delete', id: id

  $(document).on 'click', '.delete-btn', (event) ->
    App.delete.delete event.target.id