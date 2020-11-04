# git
# called like `gpr 9262` or `gpr upstreamname 1234`, this function would checkout
# GitHub pull request #9262 to `pr-9262` branch
function gpr() {
	local upstream="upstream"
	local pr=0
	if [ $# -eq 2 ]; then 
		upstream=$1
		pr=$2
	elif [ $# -eq 1 ]; then
		pr=$1
	fi
    git fetch $upstream pull/$pr/head:pr-$pr
    git checkout pr-$pr
}


function gfmt() {
	local gitroot=$(git rev-parse --show-toplevel)
	local lastcommittedgofiles=$(git diff --name-only --diff-filter=ACMR HEAD~4 HEAD | grep .*.go$ )
	local uncommited=$(git diff --name-only --diff-filter=ACMR | grep .*.go$ )
	local allfiles=${lastcommittedgofiles}${uncommited}
	local cwd=$(pwd)
	cd $gitroot

	local unformatted=$(goimports -l $allfiles)

	for fn in $unformatted; do
		echo  formating $fn
		goimports -w $gitroot/$fn
	done

	cd $cwd
}

function gfmth() {
	local gitroot=$(git rev-parse --show-toplevel)
	local lastcommittedgofiles=$(git diff --name-only --diff-filter=ACMR HEAD~4 HEAD | grep .*.go$ )
	local allfiles=${lastcommittedgofiles}
	local cwd=$(pwd)
	cd $gitroot

	#local unformatted=$(goimports -l $allfiles)
	local unformatted=$allfiles

	for fn in $unformatted; do
		echo  formating $fn
		sed -i '/import/,/)/{/^$/d}' $gitroot/$fn # remove empty line in import package
		goimports -w $gitroot/$fn
	done

	cd $cwd
}

function gfmtold() {
	local gitroot=$(git rev-parse --show-toplevel)
	local lastcommittedgofiles=$(git diff --name-only HEAD~10 HEAD | grep .*.go$ )
	local cwd=$(pwd)
	cd $gitroot

	local unformatted=$(gofmt -l $lastcommittedgofiles)

	for fn in $unformatted; do
		echo  formating $fn
		gofmt -w $gitroot/$fn
	done

	cd $cwd
}

# setup direnv
eval "$(direnv hook bash)"

# goto git root dir
function groot() {
	local project_root=`git rev-parse --show-toplevel`
	cd $project_root
}

commacd="/mnt/d/Work/coderepos/dotfiles/commacd.bash"
if [[ -f $commacd ]]; then
  . $commacd
fi

function sshsocks() {
	ssh -i ~/.ssh/ontology-mainnet-test -Nf -D 0.0.0.0:1080 -p 32000 ubuntu@139.219.138.225
}

function dump-neo() {
	dump-neovm-opcode $1 | dot -Tsvg -o$2.svg
}

# ontology node
dappnode="http://dappnode1.ont.io:20334"
testnode="http://polaris1.ont.io:20334"


export WSLPATH=/mnt/d/linux-amd64
export GOROOT=$WSLPATH/go
export GOBIN=$GOROOT/bin
export GOPATH=/mnt/d/Work/coderepos/go
export GOPROXY=https://goproxy.cn
export PATH="$GOBIN:$GOPATH/bin:$PATH"

export CARGO_HOME=$WSLPATH/.cargo
export PATH="$CARGO_HOME/bin:$PATH"

export RUSTUP_HOME=$WSLPATH/.rustup
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

# export SCCACHE_DIR=$WSLPATH/.sccache
# export RUSTC_WRAPPER=$CARGO_HOME/bin/sccache

# add nodejs
export NODEJS_HOME=$WSLPATH/node-v14.11.0-linux-x64/bin
export PATH=$NODEJS_HOME:$PATH

# add protoc path
export PATH="$WSLPATH/protoc-3.5.1/bin:$PATH"

#change prompt style
PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w\n\$'

PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w\[\033[36m\]`__git_ps1`\[\033[0m\]\n\$'

eval $(dircolors -b $HOME/.dircolors)

# https://www.andreafortuna.org/2018/05/09/how-to-automatically-attach-tmux-in-ssh-session/
if [[ "$TMUX" == "" ]]; then
    WHOAMI=$(whoami)
    if tmux has-session -t $WHOAMI 2>/dev/null; then
    tmux -2 attach-session -t $WHOAMI
    else
        tmux -2 new-session -s $WHOAMI
    fi
fi

# ATTACH_ONLY=0
# 
# [[ -z "$TMUX" && -n "$USE_TMUX" ]] && {
#     [[ -n "$ATTACH_ONLY" ]] && {
#         tmux a 2>/dev/null || {
#             exec tmux
#         }
#         exit
#     }
# 
#     tmux new-window -c "$PWD" 2>/dev/null && exec tmux a
#     exec tmux
# }


export ALICE_HOME=/mnt/d/Work/coderepos/cpp/alice-0.0.2
export PATH=$PATH:$ALICE_HOME/bin

export PATH="/mnt/d/linux-amd64/wabt-1.0.13":$PATH

#java
export JAVA_HOME="/mnt/d/linux-amd64/jdk-13.0.2"
export PATH="${JAVA_HOME}/bin":$PATH

# Wasmer
export WASMER_DIR="/home/laizy/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"  # This loads wasmer

# eval "$(starship init bash)"

# [[ -e ~/.config/z.lua ]] && eval "$(lua ~/.config/z.lua --init bash)"

# https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init bash)"

alias wc=:

