# mkenv

Depends on [madlab plan9port's port](https://github.com/madlambda/plan9port) mk program.

## install

Download the mkfile, put in your $HOME and then execute 'mk'.

```sh
cd $HOME
MKENV=https://raw.githubusercontent.com/tiago4orion/mkenv/master/mkfile
wget $MKENV -O mkfile
mk
```

# Other commands

```
mk plan9 	# update & install plan9port
mk go		# install Go
mk nash		# update & install nash
mk dotnash	# update & install nash config
```
