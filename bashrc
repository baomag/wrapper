abspath=$(dirname "$(readlink -f -e "${BASH_SOURCE[0]}")")
export PATH=$abspath/bin:$PATH
