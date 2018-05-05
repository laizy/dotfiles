# git
# called like `gpr 9262`, this function would checkout
# GitHub pull request #9262 to `pr-9262` branch
function gpr() {
    local pr=$1
    git fetch upstream pull/$pr/head:pr-$pr
    git checkout pr-$pr
}

