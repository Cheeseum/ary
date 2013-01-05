class Game
    run: () =>
        Crafty.init(640, 480)

        @player = Crafty.e("Player, 2D, DOM, Color, Twoway, Gravity")
        .color('rgb(255, 255, 255)')
        .attr(
            w: 16
            h: 16
            x: 0
            y: 0
        )
        .twoway(2, 4)
        .gravity("Platform")

        @startTimer()

    makeEnemy: (x, y) =>
        Crafty.e("Enemy, 2D, DOM, Color, Collision")
        .color('rgb(255, 255, 255)')
        .attr({w: 32, h: 32, x: 300, y: 150, dx: -4})
        .bind('EnterFrame', () ->
            @x += @dx

            # reverse position when it reaches end of platofrm
            # this.dx = -this.dx
        )
        .onHit("Player", () ->
            console.log('dicks')
        )

    makePlatform: (x, y, width, height=32, speed=3) =>
        Crafty.e("Platform, 2D, DOM, Color")
        .color('rgb(0,0,0)')
        .attr({w: width, h: height, x: x, y: y, dx: speed})
        .bind('EnterFrame', () ->
            @x += @dx
        )
        
    startTimer: () =>
        Crafty.e("GameTimer, DOM, 2D, Text")
        .attr(
            x: 20,
            y: 20,
            w: 100,
            h: 20,
            time: 0
        )

        setInterval( () =>
            Crafty("GameTimer").each( () ->
                @time += 1
                @text(@time)
            )
        , 1000)

window.Game = Game
