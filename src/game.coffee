class Game
    run: () =>
        Crafty.init(640, 480)
        .background('rgb(25, 25, 25)')

        Crafty.viewport.init(640, 480)

        @player = Crafty.e('Player, 2D, DOM, Color, Twoway, Gravity, PlatformCollision')
        .color('rgb(255, 255, 255)')
        .attr(
            w: 16
            h: 16
            x: 200
            y: 10
        )
        .twoway(4, 6)
        .gravity()
        .platformCollision()

        @makePlatform(0, 400, 640, 1, 1)
        Crafty.bind('EnterFrame', (frame) =>
            Crafty.viewport.y -= 1
            if @player._y + @player.height + Crafty.viewport.y < 0
                console.log('game over :(') #TODO: gameover scene

            @platformGenerator(frame)
        )

        @startTimer()

    # btw enemies crash the game don't make any
    makeEnemy: (x, y) =>
        Crafty.e('Enemy, 2D, DOM, Color, Gravity, PlatformCollision')
        .color('rgb(255, 255, 255)')
        .attr({w: 32, h: 32, x: 300, y: 150, dx: -4})
        .bind('EnterFrame', () ->
            @x += @dx
            
            #if @_parent and (@_x > @_parent.x + @_parent.w or @_x < @_parent.x)
            #    @dx = -@dx
        )
        .onHit('Player', () ->
            console.log('dicks')
        )
        .gravity()
        .platformCollision()

    makePlatform: (x, y, width, height=1, speed=0) =>
        platform = Crafty.e('Platform, 2D, DOM, Color, Collision')
        .color('rgb(255, 255, 255)')
        .attr(
            w: width,
            h: height,
            x: x,
            y: y,
            dx: speed
        )
        .bind('EnterFrame', () ->
            @x += @dx
        )
        .collision()

    platformGenerator: (frame) =>
        @last_platform or= frame.frame
        if frame.frame - @last_platform > 100 / (@player._y / 500)
            @last_platform = frame.frame

            speed = if Crafty.math.randomInt(0, 1) then 1 else -1
            xpos = if speed == 1 then -640 else 640
            ypos = @player._y + Crafty.math.randomInt(300, 480)
            @makePlatform(xpos, ypos, 280, 1, speed * Crafty.math.randomInt(1,5))

    startTimer: () =>
        Crafty.e('GameTimer, DOM, 2D, Text')
        .attr(
            x: 20,
            y: 20,
            w: 100,
            h: 20,
            time: 0
        )

        setInterval( () =>
            Crafty('GameTimer').each( () ->
                @time += 1
                @text(@time)
            )
        , 1000)

window.Game = Game
