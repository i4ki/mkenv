# This self-contained mkfile builds my
# entire environment.
# It starts using sh(1) shell but soon as
# nash is installed it switch to it.

user=$USER

# plan9port configurations
plan9=/usr/local/plan9
plan9git=git://github.com/madlambda/plan9port.git

# Go configuration
goversion=1.10
gourl=https://dl.google.com/go/go$goversion.linux-amd64.tar.gz
goroot=/usr/local/go
GOPATH=$HOME/go

# Nash configuration
nashproj=github.com/NeowayLabs/nash
nashpath=$HOME/nash
nashroot=$HOME/nashroot
dotnashy=https://github.com/tiago4orion/dotnash.git

# acme configuration
acmetools=git://github.com/madlambda/acme

deps=	$nashpath/init\
		$nashpath/lib/acme

# RULES BELOW USES sh(1)
all:V: $deps
$plan9:
	if [ -d $plan9 ]; then
		cd $plan9 && git pull origin master && ./INSTALL
	else
		tmpdir=/tmp/$(basename $plan9)
		git clone $plan9git $tmpdir
		sudo mv $tmpdir $(dirname $plan9)
		sudo chown -R $user.$user $plan9
		cd $plan9 && ./INSTALL
	fi

$goroot:
	wget -c $gourl -O /tmp/go.tar.gz
	sudo tar xvf /tmp/go.tar.gz -C $(dirname $goroot)

$nashroot: $goroot
	go get $(nashproj)/cmd/nash
	rm -f $GOPATH/bin/nash
	cd $(GOPATH)/src/$(nashproj)
	make

# SWITCH TO NASH SHELL
MKSHELL=$nashroot/bin/nash

$nashpath/init: $nashroot
	var _, status <= test -f $nashpath+"/init"
	if $status != "0" {
		rm -rf $nashpath
		git clone $dotnashy $nashpath
	} else {
		chdir($nashpath)
		git pull origin master
	}

$nashpath/lib/acme: $nashpath/init $plan9
	var libpath = $nashpath+"/lib"
	var _, st <= test -d $libpath
	if $st != "0" { mkdir $libpath }
	chdir($libpath)
	_, st <= test -d acme
	if $st != "0" {
		git clone $acmetools acme
	} else {
		chdir("acme")
		git pull origin master
	}



