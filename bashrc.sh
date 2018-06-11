# git
# called like `gpr 9262`, this function would checkout
# GitHub pull request #9262 to `pr-9262` branch
function gpr() {
    local pr=$1
    git fetch upstream pull/$pr/head:pr-$pr
    git checkout pr-$pr
}


function gfmt() {
	local gitroot=$(git rev-parse --show-toplevel)
	local lastcommittedgofiles=$(git diff --name-only HEAD~ HEAD)
	local unformatted=$(gofmt -l $lastcommittedgofiles)

	[ -z "$unformatted" ] && exit 0

	for fn in $unformatted; do
		echo  formating $fn
		gofmt -w $gitroot/$fn
	done
}
