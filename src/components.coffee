Crafty.c('Health', {
    health: (max) ->
        @maxHealth = @health = max

    heal: (value) ->
        @health = Math.min(@maxHealth, @health + value)

    hurt: (value) ->
        @health = Math.max(0, @health - value)
})

Crafty.c('Player', {
    init: () ->
})
