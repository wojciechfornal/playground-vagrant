BINNJAMPPAW niah niah :)
A Box with Node, nginx, JBOSS, Apache, MySQL, Perl, PHP and whatnot

Main software:

Whatnots:

- http-server
  A simple zero-configuration command-line http server.
  https://www.npmjs.com/package/http-server

MySQL:
default root password: Temp123$

Useful commands to be used in some box management utility:

netstat -aenpt
Print information about networking subsystem. Show extended info about the following: both listening and non-listening sockets, numerical addresses instead of trying to determine symbolic host,
PID and name of the program, for TCP only.

@todo
- printf instead of echo
- better conditional provisioning
- CLI output colors should be put into variables
- global provisioning switch
- prettier after-login checks output
- motd
- whatnot: CouchDB
- whatnot: PHPMyAdmin under alias
- whatnot: PostgreSQL
- whatnot: PEAR
- whatnot: PEAR PHP_CodeSniffer
- whatnot: PHP Coding Standards Fixer

Info:

- Node
  
  - http-server
  
    Started manually.
    By default starts with address [0.0.0.0] which is good to make the server accessible from the host machine by the use of
    static IP configured in Vagrantfile (eg. http://192.168.1.200:8080).

References:

https://github.com/PressLabs/sauce-base/blob/master/provision/vagrant.sh
http://nginx.com/