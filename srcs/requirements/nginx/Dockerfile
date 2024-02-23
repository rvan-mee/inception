FROM debian:bullseye

# install nginx and openssl
RUN apt-get update && \
    apt-get -y install nginx openssl

# copy the config file into the image
COPY tools/nginx.conf /etc/nginx/conf.d/default.conf

COPY tools/boot.sh /
RUN chmod +x /boot.sh

# req -x509 makes it self signed trusted cert, no CA needed https://serverfault.com/questions/838774/how-is-a-self-signed-certificate-different-from-a-certificate-signing-request
# newkey generates a new key using -> rsa:2048 (2048 bit length key) 
# -subj specifies the subject of the cert, info about who uses the cert and where the server is that is using it
# left to right C(Country) L(Location) O(Organization) OU(Organizational Unit) CN(Common Name)
RUN openssl req \
    -x509 \
    -days 420 \
    -nodes \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=NL/L=UrMomsHouse/O=Illuminati/OU=President/CN=Joe"

# run with nginx in the foreground
# only reason for this script is to display "Starting nginx"
CMD [ "./boot.sh" ]
