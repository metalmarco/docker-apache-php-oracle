# docker-apache-php-oracle-ldap

#Description
TBD

##First setup
TBD


#BUILD

	
Build

	docker build \
 	--build-arg GIT_SOURCE_REPO='https://username:password@bitbucket.org/author/repo.git' \
 	-t "metalmarco/lcpmanager:1.0" .


#RUN LCPMANAGER

Cleanup

	docker stop lcpmanager && docker rm lcpmanager

Run

	docker run -dit --privileged \
 	--name lcpmanager \
	 -p 8081:80 \
	 --restart unless-stopped \
	 metalmarco/lcpmanager:1.0