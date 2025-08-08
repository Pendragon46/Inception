
SSL create an **encrypted connection** between client and server .

### SSL STEP

| Step          | Description                                                                             |
| ------------- | --------------------------------------------------------------------------------------- |
| Client Hello  | - TLS version<br>- Send a list of possible cipher suite (protocol used during exchange) |
| Server Hello  | - Confirmation of TLS version<br>- Selected cipher suite                                |
| SSL Handshake |    described below                                                                      |
### SSL Handshake : 

1. **Browser** connects to a web server (website) secured with SSL (https). Browser requests that the server identify itself.
2. **Server** sends a copy of its SSL Certificate, including the server’s public key.
3. **Browser** checks the certificate root against a list of trusted CAs and that the certificate is unexpired, unrevoked, and that its common name is valid for the website that it is connecting to. If the browser trusts the certificate, it creates, encrypts, and sends back a symmetric session key using the server’s public key.
4. **Server** decrypts the symmetric session key using its private key and sends back an acknowledgement encrypted with the session key to start the encrypted session.
5. **Server** and Browser now encrypt all transmitted data with the session key.