#!/usr/bin/env sh

scan_dir() {
    for f in ~/* ; do
        attempt_fast_resume "$(dirname ${f})" "$(basename ${f})"
        sleep 1
    done
}

attempt_fast_resume(){
    path=$1
    file=$2
    target=${path}/${file}
    temp=/tmp/${file}
    output=/output/__fast-resume__${file}

#    printf "\n########## [`date +%F`T`date +%T`] Started Processing \"${target}\" ##########\n"
    /app/rtorrent_fast_resume.pl /data "${target}" "${temp}"
    status=$?

    if test ${status} -eq 0
    then
         mv "${temp}" "${output}"
    else
        rm -f "${temp}"
    fi
    #printf "\n########## [`date +%F`T`date +%T`] Finished Processing \"${target}\" ########\n"
}


while true
do
	scan_dir
	sleep ${DELAY}
done





#inotifywait -m /input -e create -e moved_to |
#    while read path action file; do
#        attempt_fast_resume "${path}" "${file}"
#    done