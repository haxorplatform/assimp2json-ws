localdir="$PWD"
sudo forever start -a -l $localdir/deploy/server/log.log -e $localdir/deploy/server/err.log -o $localdir/deploy/server/out.log --workingDir $localdir/deploy/server $localdir/deploy/server/app.js -vvvv
