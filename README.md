# BizHub

### Overview

BizHub provides a free suite of easy to use business tools over the web. The initial product offering allows the user to backup up to ten gigabytes of files.

**Use Case:**

An IT employee wants to reduce the impact of ransomware attacks. Specifically, they would like to backup several Excel files that are collectively used to perform financial forecasting.  The employee logs into BizHub and uploads the critical files, which are compressed and stored.

Some time after, a hacker encrypts these sensitive files and demands payment to unencrypt them. The IT team diagnoses and remediates the vulnerability that the hacker exploited to launch the ransomware, but the encrypted files remain on the system.

After removing the encrypted files from the system, the employee downloads the Excel files from BizHub and uploads them to the system. A hero is born.

### Set Up

- Generate SSH keys and connect to a GitHub account

  - Generate the keys

    ```
    cd ~/demo/bizhub-api
    
    mkdir .ssh && cd .ssh
    
    ssh-keygen
    ```

  - Register the private key

    ```
    eval $(ssh-agent)
    
    ssh-add ~/demo/bizhub-api/.ssh/id_rsa
    ```

  - Print the public key, copy the value and register with a GitHub account

    ```
    cat ~/demo/bizhub-api/.ssh/id_rsa.pub
    ```
    
  - Create copies of the public and private keys under the UI project, *demo/bizhub-ui/.ssh* 

- Generate self-signed certificates for the BizHub Server and the Authorization Server

  - Generate the self-signed certificate for BizHub

    ```
    keytool -genkeypair -alias bizhub-api -keyalg RSA -keysize 4096 -storetype PKCS12 -keystore bizhub-api.p12 -validity 3650 -storepass changeit
    ```

  - Export the key to a public certificate for BizHub

    ```
    keytool -export -keystore bizhub-api.p12 -alias bizhub-api -file bizhub-api.crt
    ```

  - Copy the public BizHub certificate into the directory *~/demo/authorization-server/certs*

  - Generate the self-signed certificate for the Authorization Server

    ```
    keytool -genkeypair -alias keycloak-server -keyalg RSA -keysize 4096 -storetype PKCS12 -keystore server.p12 -validity 3650 -storepass changeit
    ```

  - Export the key to a public certificate for the Authorization Server

    ```
    keytool -export -keystore server.p12 -alias keycloak-server -file server.crt
    ```

  - Copy the public Authorization Server certificate into the directory *~/demo/bizhub-api/certs*

- Publish the Authorization Server's configuration files

  - Add a file named *keycloak.conf* within the directory *~/demo/authorization-server/conf* with the following contents:

    ```
    # Database
    db=postgres
    db-username=postgres
    db-password=changeitdb
    db-url=jdbc:postgresql://auth-db:5432/authorization-db
    
    # Health
    health-enabled=true
    
    # HTTPS
    https-port=9880
    https-key-store-file=/opt/keycloak/conf/server.p12
    https-key-store-password=changeit
    hostname-url=https://keycloak-server:9880
    hostname=keycloak-server
    hostname-strict=false
    
    mail.from=noreply@bizhub.com
    mail.smtp.host=smtp.host
    mail.smtp.port=587
    mail.smtp.username=update-username
    mail.smtp.password=update-password
    mail.smtp.ssl=false
    mail.smtp.tls=true
    
    import-realm-file=/opt/keycloak/data/import/realm.json
    ```

    - Update *mail* properties for use with an actual SMTP server

  - Rename the file *~/demo/authorization-server/conf/sample-bizhub-realm.json* to be *bizhub-realm.json*, and configure it to use an actual SMTP server. Relative properties include:

    ```json
    "smtpServer" : {
        "from": "noreply@bizhub.com",
        "host": "UPDATE_HERE",
        "port": "587",
        "user": "UPDATE_HERE",
        "password": "UPDATE_HERE",
        "ssl": "false",
        "starttls": "true",
        "auth": "true"
    }
    ```

- Build and run with Docker

  ```
  docker-compose up
  ```

  

### API

#### Accounts

- **Register for an Account**
  - URL: https://localhost:8080/v1/register
  - Method: POST
  - Request Parameters: (x-www-form-urlencoded)
    - email-address: string
    - password: string
      - Must be at least eight characters, must include at least one letter and one number
    - confirmed-password: string
      - Must match password
  - Response: (201 CREATED)



- **Log into an Account**

  - URL: https://localhost:8080/v1/login

  - Method: POST

  - Request Parameters: (x-www-form-urlencoded)

    - email-address: string
    - password: string

  - Response: (200 OK)

    ```
    {
    	"accessToken": string,
    	"millisecondsUntilTokenExpiration": int,
    	"jwtUri": string
    }
    ```



- **Reset Password for an Account**
  - URL: https://localhost:8080/v1/reset-password
  - Method: POST
  - Request Parameters: (x-www-form-urlencoded)
    - email-address: string
  - Response: (200 OK)



#### File Backup

- **Upload Files**

  - URL: https://localhost:8080/v1/backups

  - Method: POST

  - Request Headers:

    - Authorization: {access-token}

  - Request Parameters: (x-www-form-urlencoded)

    - files: MulipartFile[]
    
  - Response: (201 CREATED)

    ```
  {
    	"occupiedUserStorageInBytes": "3 MB"
    }
    ```
    
    - Total storage occupied by user backup files, including this one



- **Download Files**
  - URL: https://localhost:8080/v1/backups
    - Method: GET
  - Request Headers:
    
    - Authorization: {access-token}
    - Request Parameters:

      - file-names: string
        - Delimited by comas
  - Response: (200 OK)
    - *application/octet-stream*
      - A ZIP file containing the specified files