HISTSIZE=10000

alias ls="ls --color"
alias ll="ls -l"
alias mydotfiles='/usr/bin/git --git-dir=$HOME/.mydotfiles/ --work-tree=$HOME'
if   type nvim > /dev/null; then export VISUAL="$(which nvim)"
elif type vim  > /dev/null; then export VISUAL="$(which vim)"; fi

move() { mv --backup=t $*; }
copy() { cp --backup=t $*; }
go() {
    if type ranger > /dev/null; then
        tempfile="$(mktemp -t tmp.XXXXXX)"
        ranger --choosedir="$tempfile" "${@:-$(pwd)}" --cmd="chain map <cr> quit; set colorscheme snow"
        test -f "$tempfile" &&
            if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
                cd -- "$(cat "$tempfile")"
            fi
            rm -f -- "$tempfile"
    fi
}
edit() {
    if [[ ! -z "$@" ]]; then
        ${VISUAL} "$@"
    elif type fzf > /dev/null; then
        tempfile="$(mktemp -t tmp.XXXXXX)"
        fzf > "${tempfile}" && ${VISUAL} "$(cat -- ${tempfile})"
    else
        ${VISUAL}
    fi
}
ide() {
    if jobs | grep -q "\${IDE}"; then
        fg $(jobs | grep "\${IDE}" | awk -F'[][]' '{print $2}')
    else
        go
        IDE=${VISUAL}
        if [[ -f "Session.vim" ]]; then
            ${IDE} -S Session.vim
        else
            ${IDE}
        fi
    fi
}


