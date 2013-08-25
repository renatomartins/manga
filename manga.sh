#!/usr/bin/env bash

# manga -d ~/Ebooks/manga/berserk berserk
# cbz2pdf Ebooks/manga/berserk/berserk.\[mr\].berserk.013.cbz

#TODO: use manga_downloader to download zip file into /tmp directory
#TODO: setup an XML configuration file
#TODO: extract zip to /tmp/somethingsomething and `convert` images into pdf (see cbz2pdf)

#TODO: remove xml option

# default working directory
CWD=`pwd`
# initialize array of titles
TITLES=( )


usage() {
  cat <<-EOF

  Usage: manga [options] <manga name> [<manga name> ...]

  Options:

    -h, --help                  Display this help and exit
    -d, --directory <dest dir>  Destination directory, if not set uses cwd
    -x, --xml <config path>     Path of the XML configuration file
                                (see manga_downloader example)
    -c, --chapters <chapters>   Chapter numbers separated by commas or by a
                                dash to indicate an interval
                                Ex: 1,2,8-10 (chapters 1, 2, and 8 through 10)

EOF
}


download_manga() {
  echo $CWD
  echo $CHAPTERS
  echo "${TITLES[@]}"
}


while [[ $# -ne 0 ]]
do
  option=$1
  shift
  case $option in
    -h|--help) usage; exit ;;
    -d|--directory) CWD=$1; shift ;;
    -c|--chapters) CHAPTERS=$1; shift ;;
    # add current option to titles array
    *) TITLES=( "${TITLES[@]}" $option )
  esac
done

# show usage and exit if no titles are set
if [[ ! $TITLES ]]; then
  usage
  exit
fi

download_manga
