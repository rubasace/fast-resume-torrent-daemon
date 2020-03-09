FROM alpine

MAINTAINER rubasace <rubasodin18@gmail.com>

# Necessary for build hooks
ARG BUILD_DATE
ARG VCS_REF

# # Good docker practice, plus we get microbadger badges
LABEL org.label-schema.build-date=$BUILD_DATE \
       org.label-schema.vcs-url="https://github.com/rubasace/fast-resume-torrent-daemon.git" \
       org.label-schema.vcs-ref=$VCS_REF \
       org.label-schema.schema-version="2.2-r1"

RUN apk add --no-cache --update alpine-sdk g++ make perl perl-app-cpanminus perl-dev \
	&& rm -rf /tmp/* /var/cache/apk/* /var/lib/apk/lists/*

ADD http://search.cpan.org/CPAN/authors/id/I/IW/IWADE/Convert-Bencode_XS-0.06.tar.gz /convert-bencode/
ADD https://rt.cpan.org/Ticket/Attachment/1433449/761974/patch-t_001_tests_t /convert-bencode/

RUN cd /convert-bencode \
 && tar zxf Convert-Bencode_XS-0.06.tar.gz \
 && cd Convert-Bencode_XS-0.06 \
 && patch -uNp0 -i ../patch-t_001_tests_t \
 && perl Makefile.PL \
 && make \
 && make test \
 && make install

ADD https://raw.githubusercontent.com/rakshasa/rtorrent/master/doc/rtorrent_fast_resume.pl /app/
COPY scripts/* /app/

RUN chmod a+x /app/*

ENV DELAY 60

VOLUME ["/input","/output", "/data", "/logs"]

####################
# ENTRYPOINT
####################
ENTRYPOINT ["/app/fast-resume-daemon.sh"]
