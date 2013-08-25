#!/usr/bin/env bash

#TODO: setup an XML configuration file
#TODO: remove xml option

# default target directory
TARGET=`pwd`
# download none, by default
ALL=''
# initialize array of titles
TITLES=( )


function usage {
  cat <<-EOF

  Usage: manga [options] <manga title> [<manga title> ...]

  The titles don't need to be accurate, and if it has more than one word,
  enclose it with quotes (eg: "liar game").
  You can insert the chapters interactively, or use the option --all to
  download them all.

  Options:

    -h, --help                    Display this help and exit
    -a, --all                     Download all chapters for given titles
    -d, --directory <target dir>  Target directory, if not set uses pwd
    -x, --xml <config path>       Path of the XML configuration file
                                  (please see manga_downloader example)

  This script uses:
  - manga_downloader (git://github.com/jiaweihli/manga_downloader)

EOF
}


function download_manga {
  # get the dirname of this script, so we know manga_downloader's path
  local this_dir=`dirname $0`
  local tmp_dir='/tmp/manga'

  mkdir $tmp_dir
  # clean temporary directory in case it already existed
  rf -r "$tmp_dir/*"

  # download zip file to temporary directory
  python "$this_dir/manga_downloader/src/manga.py" --zip $ALL \
    -d $tmp_dir "${TITLES[@]}"

  # unzip files
  # list 1 file per line
  for zip in `ls -1 $tmp_dir/*.zip`; do
    local filename=`basename "$zip"`
    # get the filename without the extension
    local dirname="${filename%.*}"
    unzip -d "$tmp_dir/$dirname" "$zip"
  done

  #TODO: use "convert" to generate pdf files in the target directory

}


while [[ $# -ne 0 ]]; do
  option=$1
  shift
  case $option in
    # display help message
    -h|--help) usage; exit ;;
    # set option to download all chapters
    -a|--all) ALL='--all' ;;
    # expand the path of the target directory
    -d|--directory) TARGET=`readlink -f $1`; shift ;;
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
