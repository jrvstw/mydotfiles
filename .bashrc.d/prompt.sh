getStatus()
{
    errVal=$?
    retVal=""
    if [[ $[errVal] -ne 0 ]]; then
        retVal=", ERROR:${errVal}"
    fi
    jobStat=""
    jobCount=$[$(jobs | grep -c "\[")]
    if [[ $[jobCount] -gt 0 ]]; then
        jobStat=" ${jobCount} job"
        if [[ $[jobCount] -gt 1 ]]; then
            jobStat="${jobStat}s"
        fi
        jobStat=", ${jobStat}"
    fi
    myPath=${PWD/~/\~}
    if $(git rev-parse --is-inside-work-tree 2>/dev/null); then
        gitBranch="($(git rev-parse --abbrev-ref HEAD 2>/dev/null))"
    else
        gitBranch=""
    fi

   #width=80
    width=${COLUMNS}
    hostStr=" $(test $SSH_TTY && printf 'SSH:')${HOSTNAME%%.*}"
    pathStr=" ${shLevel} ${myPath}${gitBranch}"
    signalStr="${retVal}${jobStat}"
    timeStr="$(date +%T)"

    diff="$(expr ${width} - length "${hostStr}${pathStr}${signalStr}  ${timeStr} ")"
    if [[ $diff -gt 0 ]]; then
        padding=$(printf %${diff}s)
    else
        padding=""
        myPath=$(printf "%s" "${myPath}" | tail -c +$(expr 1 - ${diff}))
    fi

    tput dim
    tput smul
    printf "\n%s" "${hostStr}${pathStr}${signalStr}${padding}  ${timeStr} "
    tput sgr0
    printf "\n"
}
shLevel+=">"
export shLevel
PROMPT_COMMAND="getStatus"
PS1=' \u > '
