cd deploy/server/
localdir="$PWD"
forever stop assimp
forever start -a -l $localdir/log.log -e $localdir/err.log -o $localdir/out.log --workingDir $localdir --uid "assimp" $localdir/app.js -vvvv
