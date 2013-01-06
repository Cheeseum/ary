Crafty.c('Health',
    health: (max) ->
        @maxHealth = @health = max

    heal: (value) ->
        @health = Math.min(@maxHealth, @health + value)

    hurt: (value) ->
        @health = Math.max(0, @health - value)
)

Crafty.c('PlatformCollision',
    init: () ->
        @_up = false
        @_bouncing = false
        @_falling = false
        @_detachNextFrame = false

        @requires('Collision, 2D')

    platformCollision: () ->

        @collision().
        onHit('BouncyPlatform', hitBouncyPlatform).
        onHit('Platform', hitPlatform).
        bind('Move', () ->
            if @_detachNextFrame and @_falling
                @_detachNextFrame = false
                @_parent?.detach(@)

            @_detachNextFrame = not @_falling
        )

        return this
)

hitBouncyPlatform = (hitArr) ->
    for hit in hitArr
        # top
        if hit.normal.y == -1
            # trigger a jump here ...
            pass?

hitPlatform = (hitArr) ->
    for hit in hitArr
        # top or bottom
        if hit.normal.y != 0
            @_up = false

        # top
        if hit.normal.y == -1
            @color(hit.obj.color()) # change color

            if not @_bouncing
                @_falling = false
                @y = hit.obj.y - @h
                hit.obj.attach(@)
        # right
        if hit.normal.x == 1
            @x = hit.obj.x + hit.obj.w

        # left
        if hit.normal.x == -1
            @x = hit.obj.x - @w
