$ ->
  cnt = 0

  clearBoard = ->
    $('.board-cell').text('')
    $('.board-cell').removeClass('o')
    $('.board-cell').removeClass('x')
    cnt = 0

  resetBoard = ->
    clearBoard()
    $('#gameboard').hide()
    $('#start-game').fadeIn(500)

  checkForWin = (cell) ->
    console.log "Checking for win for cell " + cell
    board = ($('.board-cell').map (idx, el) ->
      $(el).text()
    ).get()

    win = ''
    wins = [
      [[0,1,2],[0,3,6],[0,4,8]]
      [[0,1,2],[1,4,7]]
      [[0,1,2],[2,5,8],[2,4,6]]
      [[3,4,5],[0,3,6]]
      [[3,4,5],[1,4,7],[0,4,8],[2,4,6]]
      [[3,4,5],[2,5,8]]
      [[6,7,8],[0,3,6],[2,4,6]]
      [[6,7,8],[1,4,7]]
      [[6,7,8],[2,5,8],[0,4,8]]
    ]

    for p in wins[cell]
      console.log "Running pattern " + p
      win = board[p[0]] if '' != board[p[0]] == board[p[1]] == board[p[2]]

    if win != ''
      alert win + ' won!'
      resetBoard()

  $('#start-game').on 'click', (e) ->
    clearBoard()
    $(@).hide()
    $('#gameboard').fadeIn(500)

  $('.board-cell').on 'click', (e) ->
    mark = if cnt % 2 == 0 then 'x' else 'o'
    if ( $(@).text().replace /^\s+|\s+$/g, "" ) == ''
      $(@).text mark
      $(@).addClass mark
      cnt += 1
      cell = $(@).attr('id').replace /^cell\-/, ""
      checkForWin(cell) if cnt > 4