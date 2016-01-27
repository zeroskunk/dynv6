# dynv6
This is an Dynv6 DNS utility Script for dynv6.net with IPv4
		The IPv6 implementation is not ready jet

## CRONTAB
Don't forget to put a Crontab line to your System

ADD A CRONJOB (crontab -e)

*/20 * * * * /usr/sbin/dynv6 <public_dns> <token> > /var/log/dynv6 2>&1
