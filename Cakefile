{exec, spawn} = require 'child_process'

task 'build', 'Build coffeescript source files to javascript.', ->
    exec 'coffee --compile --output js/ src/', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        console.log 'Build successful! Javascript outputted into `js/`.'

task 'watch', 'Automatically build coffeescript source to javascript as files change.', ->
    coffee_proc = spawn 'coffee', ['--watch', '--output', 'js/', 'src/']

    coffee_proc.stdout.on 'data', (data) ->
        process.stdout.write data.toString()
