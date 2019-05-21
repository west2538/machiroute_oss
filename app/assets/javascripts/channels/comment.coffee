App.comment = App.cable.subscriptions.create "CommentChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel

    $('#socialparam1').replaceWith('<tr id="socialparam1" class="text-center"><td class="py-0"><span class="status_number">' + data['bokenshanum'] + '</span> <span class="font-weight-bold">名</span></td><td class="py-0"><span class="status_number">' + data['clearnum'] + '</span> <span class="font-weight-bold">件</span></td><td class="py-0"><span class="font-weight-bold">平均Lv.</span><span class="status_number">' + data['levelavrg'] + '</span></td></tr>')
    $('#socialparam2').replaceWith('<tr id="socialparam2" class="text-center"><td class="py-0"><span class="status_number">' + data['bokenshanum'] + '</span> <span class="font-weight-bold">名</span></td><td class="py-0"><span class="status_number">' + data['clearnum'] + '</span> <span class="font-weight-bold">件</span></td><td class="py-0"><span class="font-weight-bold">平均Lv.</span><span class="status_number">' + data['levelavrg'] + '</span></td></tr>')
    $('#socialparam3').replaceWith('<tr id="socialparam3" class="text-center"><td class="pt-0 pb-1"><span class="status_number">' + data['bokenshanum'] + '</span> <span class="font-weight-bold">名</span></td><td class="pt-0 pb-1"><span class="status_number">' + data['clearnum'] + '</span> <span class="font-weight-bold">件</span></td><td class="pt-0 pb-1"><span class="font-weight-bold">平均Lv.</span><span class="status_number">' + data['levelavrg'] + '</span></td></tr>')

  speak: (bokenshanum, clearnum, levelavrg) ->
    @perform 'speak', {bokenshanum: bokenshanum, clearnum: clearnum, levelavrg: levelavrg}
