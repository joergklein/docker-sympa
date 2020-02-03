FROM centos:latest as builder

LABEL maintainer="Joerg Klein <kwp.klein@gmail.com>" \
      description="Docker base image for Sympa, a mailing list server"

RUN dnf update -y  \
    && dnf group install -y "Development Tools" \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# Download the source file
ENV SYMPA_VERSION 6.2.52
ENV SYMPA_BINARY ${SYMPA_VERSION}.tar.gz

RUN curl -LJO https://github.com/sympa-community/sympa/archive/${SYMPA_BINARY} \
    && tar xzf sympa-${SYMPA_BINARY} -C /usr/src/ \
    && rm sympa-${SYMPA_BINARY}

RUN groupadd sympa && useradd -g sympa -c 'Sympa' -s /sbin/nologin sympa

WORKDIR /usr/src/sympa-${SYMPA_VERSION}

# Build and install Sympa
RUN autoreconf -i && automake --add-missing
RUN ./configure && make && make install && make clean

# Install Perl modules
RUN dnf install -y epel-release && dnf install -y cpanminus
RUN cpanm -L /home/sympa --notest --configure-args='PREFIX=/home/sympa LIB=/home/sympa/lib/perl5' MHonArc::UTF8
RUN cpanm -L /home/sympa --installdeps --notest .

# Add directory for mail aliase
RUN mkdir /etc/mail && touch /etc/mail/sympa_aliases && chown sympa:sympa /etc/mail/sympa_aliases

# Copy helper scripts for creating Sympa configuration and startup
COPY start-sympa write-sympa-conf sympa.conf.tt2 /home/sympa/

RUN chown sympa:sympa /home/sympa

FROM centos:latest

RUN dnf update -y  \
    && dnf install -y sendmail perl perl-DBD-Pg \
    && dnf clean all \
    && rm -rf /var/cache/dnf

COPY --from=builder /etc/mail/ /etc/mail
COPY --from=builder /etc/sympa/ /etc/sympa
COPY --from=builder /home/sympa/ /home/sympa/

# Create sympa user
RUN useradd -M sympa --comment "Sympa"

# Set user sympa
USER sympa

# Set work dir to /home/sympa
WORKDIR /home/sympa

CMD ["/home/sympa/start-sympa"]
