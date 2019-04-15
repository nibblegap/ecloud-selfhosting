Ports
=====

* `25/tcp` - SMTP - used for incoming mail and sending mail by clients. Plaintext but Postfix requires `STARTTLS`
* `80/tcp` and `443/tcp` - HTTP and HTTPS
* `587/tcp` - the same as SMTP but used to send mail by clients whose `25/tcp` is blocked by their ISP
* `993/tcp` - IMAPS - IMAP over TLS used to fetch email by clients
* `110/tcp` - plaintext POP3 - clients should be using IMAPS instead
* `143/tcp` - plaintext IMAP - clients should be using IMAPS instead
* `465/tcp` - SMTP over TLS - nobody is using it as `STARTTLS` on `25/tcp` does it better
* `995/tcp` - POP3 over TLS - clients should be using IMAPS instead
* `4190/tcp` - Dovecot mail rule modiication service - requires client-side support, we need to decide on this one
* `5222/tcp` - XMPP requires client-side support, we need to decide on this one

