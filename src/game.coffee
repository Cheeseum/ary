class Game
    width: 640,
    height: 480,
    last_platform: 0,

    run: () =>
        Crafty.init(@width, @height)
        .background('rgb(25, 25, 25)')

        Crafty.viewport.init(@width, @height)

        @player = Crafty.e('Player, 2D, DOM, Color, Twoway, Gravity, PlatformCollision')
        .color('rgb(255, 255, 255)')
        .attr(
            w: 16
            h: 16
            x: (@width / 2) - 8
            y: 10
        )
        .twoway(5, 5)
        .gravity()
        .gravityConst(0.2)
        .platformCollision()

        @makeBouncyPlatform(@width / 4, @height, @width / 2, 0)
        .color('rgb(255, 255, 255)')

        Crafty.bind('EnterFrame', (frame) =>
            Crafty.viewport.y -= 2 if frame.frame % 3 is 0 # scroll every 3 frames

            if @player._y + @player.h + Crafty.viewport.y < 0 or @player._y + @player.h + Crafty.viewport.y > @height
                console.log('game over :(') #TODO: gameover scene

            @platformGenerator(frame)
        )

        @initStatusText()

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

    makePlatform: (x, y, width, speed=0) =>
        [r, g, b] = (Crafty.math.randomInt(127, 224) for n in [0..2])
        height = 4
        platform = Crafty.e('Platform, 2D, DOM, Color, Collision')
        .color("rgb(#{r}, #{g}, #{b})")
        .attr(
            w: width,
            h: height,
            x: x,
            y: y,
            dx: speed
        )
        .bind('EnterFrame', () ->
            @x += @dx
            if @x > Crafty.viewport.width*3 or @x+width < -Crafty.viewport.height*2
                @destroy() #kill platforms as they move offscreen
        )
        .collision()

        return platform

    makeBouncyPlatform: (x, y, width, speed=0) =>
        platform = @makePlatform(x, y, width, speed)
        platform.addComponent('BouncyPlatform')
        return platform

    platformGenerator: (frame) =>
        increase_intv = Math.floor(@player._y / 500) # every 2000 units increase the frequency
        freq = 100 / (increase_intv + 1) # base freq of (1000 / 25) since intv starts at 0

        if frame.frame - @last_platform > freq and (@player.y + Crafty.viewport.y) < (@height / 2)
            @last_platform = frame.frame

            width = Crafty.math.randomInt(@width / 8, @width / 4)
            speed = Crafty.math.randomInt(1, 4) * (if Crafty.math.randomInt(0, 1) then 1 else -1)

            xpos = if speed > 0 then -width else @width + width # place platform offscreen
            ypos = (@player.h * 2) * Math.floor((@height - Crafty.viewport.y) / (@player.h * 2))

            @makePlatform(xpos, ypos, width, speed)

    initStatusText: () =>
        sufferingCounter = document.createElement('div')
        sufferingCounter.className = "suffering-text"
        document.getElementById('cr-stage').appendChild(sufferingCounter)
        Crafty.bind('EnterFrame', (frame) ->
            sufferingCounter.innerHTML = "suffering: #{-Crafty.viewport.y}"
            if -Crafty.viewport.y > 500
                sufferingCounter.className = "suffering-text danger"
        )


window.Game = Game
