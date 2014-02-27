"use strict"

@ticTacToe = angular.module 'TicTacToe', []

ticTacToe.constant 'Settings',
  WIN_PATTERNS: [
    [0,1,2]
    [3,4,5]
    [6,7,8]
    [0,3,6]
    [1,4,7]
    [2,5,8]
    [0,4,8]
    [2,4,6]
  ]

class BoardCtrl
  constructor: (@$scope, @Settings) ->
    @$scope.cells = {}
    @$scope.patternsToTest = @getPatterns()
    @$scope.mark = @mark

  getPatterns: =>
    @Settings.WIN_PATTERNS.filter -> true

  getRow: (pattern) =>
    c = @$scope.cells
    c0 = c[pattern[0]] || pattern[0]
    c1 = c[pattern[1]] || pattern[1]
    c2 = c[pattern[2]] || pattern[2]
    "#{c0}#{c1}#{c2}"

  someoneWon: (row) ->
    'xxx' == row || 'ooo' == row

  resetBoard: =>
    @$scope.cells = {}

  numberOfMoves: =>
    Object.keys(@$scope.cells).length

  movesRemaining: (player) =>
    totalMoves = 9 - @numberOfMoves()

    if player == 'x'
      Math.ceil(totalMoves / 2)
    else if player == 'o'
      Math.floor(totalMoves / 2)
    else
      totalMoves

  player: (options) =>
    options ||= whoMovedLast: false
    moves = @numberOfMoves() - (if options.whoMovedLast then 1 else 0)
    if moves % 2 == 0 then 'x' else 'o'

  announceWinner: =>
    winner = @player(whoMovedLast: true)
    alert "#{winner} wins!"

  isMixedRow: (row) ->
    # console.log "isMixedRow? ", !!row.match(/o+x+|x+o+/i)
    !!row.match(/o+x+|x+o+/i)

  hasOneX: (row) ->
    # console.log "hasOneX?", !!row.match(/x\d\d|\dx\d|\d\dx/i)
    !!row.match(/x\d\d|\dx\d|\d\dx/i)

  hasTwoXs: (row) ->
    # console.log "hasTwoXs?", !!row.match(/xx\d|x\dx|\dxx/i)
    !!row.match(/xx\d|x\dx|\dxx/i)

  hasOneO: (row) ->
    # console.log "hasOneO?", !!row.match(/o\d\d|\do\d|\d\do/i)
    !!row.match(/o\d\d|\do\d|\d\do/i)

  hasTwoOs: (row) ->
    # console.log "hasTwoOs?", !!row.match(/oo\d|o\do|\doo/i)
    !!row.match(/oo\d|o\do|\doo/i)

  isEmptyRow: (row) ->
    # console.log "isEmptyRow?", !!row.match(/\d\d\d/i)
    !!row.match(/\d\d\d/i)

  fewerMoves: (moves, player) =>
    @movesRemaining(player) < moves

  rowStillWinnable: (row) =>
    if isEmptyRow(row)
      console.log "Empty row!", row
      console.log "moves remaining: ", @movesRemaining()
    @isMixedRow(row) or
    (@hasOneX(row) and @fewerMoves(2, 'x')) or
    (@hasTwoXs(row) and @fewerMoves(1, 'x')) or
    (@hasOneO(row) and @fewerMoves(2, 'o')) or
    (@hasTwoOs(row) and @fewerMoves(1, 'o')) or
    (@isEmptyRow(row) and @movesRemaining() < 5)

  parseBoard: =>
    @$scope.patternsToTest = @$scope.patternsToTest.filter (pattern) =>
      row = @getRow(pattern)
      @announceWinner() if @someoneWon(row)
      not @rowStillWinnable(row)
    console.log @$scope.patternsToTest

  mark: (@$event) =>
    cell = @$event.target.dataset.index
    @$scope.cells[cell] = @player()
    @parseBoard()


BoardCtrl.$inject = ["$scope", "Settings"]
ticTacToe.controller "BoardCtrl", BoardCtrl