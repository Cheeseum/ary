class Game
    run: () =>
        Crafty.init(640, 480)
        
        @player = Crafty.e("2Dm DOM, Keyboard, Player")

window.Game = Game
