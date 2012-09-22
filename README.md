Minesweeper
==========

The game
--------

Long version: see [Wikipedia][1]

[1]: https://secure.wikimedia.org/wikipedia/en/wiki/Minesweeper_(video_game)

Each turn, you can either reveal a location or flag it:

Reveal a location.
* This will show the number of mines adjacent to that square (including diagonals).
* If that number is zero, it will also reveal the full extent of the `safe` zone.
* If the location contains a mine, you lose.

Flag a location.
* This will mark a location as containing a mine (or suspected of containing a mine). It has no game effect other than as an aid to the player.

You win if you can successfully locate all of the mines - that is, reveal every location that doesn't contain one.

### Additional rules

* The official interpreter is Ruby 1.9.2.
* The player will not have access to the game objects.
* The player may `require` Ruby source files from within a `lib` directory in the same place as the player file (i.e. `players/player.rb` can use `players/lib/foo/bar.rb` via `require "foo/bar"`.)
* A file should not implement more than one player class.

Implementation
--------------

This implementation is based on the ruby implementation for the game Battleships, as found [here](https://github.com/threedaymonk/battleship)

Play takes place on a square grid (defaulting to 10x10), with a certain number of squares containing mines (default is 10). Co-ordinates are given in the order _(x,y)_
and are zero-indexed relative to the top left, i.e. _(0,0)_ is the top left,
_(9,0)_ is the top right, and _(9,9)_ is the bottom right.

A player is implemented as a Ruby class. The name of the class must be unique
and end with `Player`. It must implement the following instance methods:

### name

This must return an ASCII string containing the name of the team or player.

### take_turn(state)

`state` is a representation of the known state of the board, as
modified by the player’s shots. It is given as an array of arrays; the inner
arrays represent horizontal rows. Each cell may be in one of the following states:
`:unknown`, `:flag`, `:mine` or the number of adjacent mines. As flags are markers that you set yourself, and revealing a mine will end the game, a typical board will contain only `:unknown` and numbers. E.g. 

    [[1,    2,    :unknown, ...],   [2,    :unknown, :unknown, ...], ...]
    # 0,0   1,0    2,0              0,1       1,1       2,1


`take_turn` must return an array of co-ordinates for the next shot, with an optional third element containing true of false, with false depicting a `flag` notation rather than revealing the square. In the
example above, we can see that the player has already played `[0,0]`, `[1,0]` and `[0,1]`. They can now be certain that `[2,2]` is a mine, so they return `[2,2,true]` for their next shot.

The console runner
------------------

A console runner is provided. It can be started using:

    ruby bin/play.rb path/to/player.rb

Players are isolated using DRb.

A couple of very basic players are supplied: `StupidPlayer` guesses at random.
`Human Player` asks for input via the console.
