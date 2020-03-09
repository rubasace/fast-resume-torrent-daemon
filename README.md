# Fast Resume Torrent

[![docker-data](https://images.microbadger.com/badges/image/rubasace/fast-resume-torrent-daemon.svg)](https://microbadger.com/images/rubasace/fast-resume-torrent-daemon "Get your own
 image badge on microbadger.com")
[![docker-version](https://images.microbadger.com/badges/version/rubasace/fast-resume-torrent-daemon.svg)](https://microbadger.com/images/rubasace/fast-resume-torrent-daemon "Get your own version badge on microbadger.com")


## Description
Fast Resume Torrent offers a docker container with the famous [rtorrent_fast_resume.pl](https://github.com/rakshasa/rtorrent/wiki/Common-Tasks-in-rTorrent#adding-fast-resume-data-to-torrent-files) script already installed. Such script adds fast resume data to torrent files, so they can 
be added to rTorrent without the need for an initial check. This container provides a loop that will process any `.torrent` file dropped in the `/input` directory, every
 `${INTERVAL}` seconds, providing its fast-resume version on the `/output` one.

## Why
Why not. The original script is useful, but its installation is tricky because of the `Convert-Bencode_XS` library and the need to patch it in later versions of Perl.
This container comes with it already installed and ready to use (Check the `Dockerfile`), so once built and published it will work forever. 

## How to Run
```bash
docker run -d --name fast-resume \
        --restart=unless-stopped \
        -v /path/to/drop/original/torrent/files:/input:shared \
        -v /path/to/collect/fast/resume/torrent/files:/output:shared \
        -v /path/to/root/downloaded/files:/data:shared \
        -v /path/to/logs:/logs \
        -e INTERVAL=60 \
        rubasace/fast-resume-torrent-daemon
```
### Volumes

| Volume | Description | 
| ---- | ----------- | 
| /input | Directory where original `.torrent` files will be dropped to be processed. | 
| /output | Directory where the script will allocate the fast-resume `.torrent` files once processed. (They will have the same name as the original one, prefixed with `__fast-resume__`). | 
| /data | This directory is required by the `rtorrent_fast_resume.pl` script to generate the fast-resume data. It should point to the root directory where the downloaded files are stored.| 
| /logs | **Optional**. Directory where logs will be stored. | 


## Requirements
* Docker
* rTorrent (I don't know if it works for other clients, feel free to let me know)

