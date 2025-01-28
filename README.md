# Checkers Antivirus

### Overview

Checkers provides a free suite of easy to use antivirus software services over the web. The initial product offering allows the user to track up to fifty immutable files.

**Use Case:**

A user decides that the contents of the system's *C:/Windows/Tasks* directory should never change.

The user uploads the artifact details for the *C:/Windows/Tasks* directory by selecting the directory from their browser. These details include hashes for each file, as well as a hash for the directory itself.

The user scans the directory for changes to any of the files by selecting the directory from their browser. The selected directory's hash is compared to the stored directory's hash. If the two are different, each registered file's hash within the selected directory is compared to the stored file's hash. If the two are different, then the modified file's file path is displayed to the user.



### Set Up

- Generate SSH keys and connect to a GitHub account

  - Generate the keys

    ```
    cd ~/demo/checkers-api
    
    mkdir .ssh && cd .ssh
    
    ssh-keygen
    ```

  - Register the private key

    ```
    eval $(ssh-agent)
    
    ssh-add ~/demo/checkers-api/.ssh/id_rsa
    ```

  - Print the public key, copy the value and register with a GitHub account

    ```
    cat ~/demo/checkers-api/.ssh/id_rsa.pub
    ```

- Generate self-signed certificates for the Checkers Server and the Authorization Server

  - Generate the self-signed certificate for Checkers

    ```
    keytool -genkeypair -alias checkers-api -keyalg RSA -keysize 4096 -storetype PKCS12 -keystore checkers-api.p12 -validity 3650 -storepass changeit
    ```

  - Export the key to a public certificate for Checkers

    ```
    keytool -export -keystore checkers-api.p12 -alias checkers-api -file checkers-api.crt
    ```

  - Copy the public Checkers certificate into the directory *~/demo/authorization-server/certs*

  - Generate the self-signed certificate for the Authorization Server

    ```
    keytool -genkeypair -alias keycloak-server -keyalg RSA -keysize 4096 -storetype PKCS12 -keystore server.p12 -validity 3650 -storepass changeit
    ```

  - Export the key to a public certificate for the Authorization Server

    ```
    keytool -export -keystore server.p12 -alias keycloak-server -file server.crt
    ```

  - Copy the public Authorization Server certificate into the directory *~/demo/checkers-api/certs*

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
    
    mail.from=noreply@checkers-antivirus.com
    mail.smtp.host=smtp.host
    mail.smtp.port=587
    mail.smtp.username=update-username
    mail.smtp.password=update-password
    mail.smtp.ssl=false
    mail.smtp.tls=true
    
    import-realm-file=/opt/keycloak/data/import/realm.json
    ```

    - Update *mail* properties for use with an actual SMTP server

  - Rename the file *~/demo/authorization-server/conf/sample-checkers-realm.json* to be *checkers-realm.json*, and configure it to use an actual SMTP server. Relative properties include:

    ```json
    "smtpServer" : {
        "from": "noreply@checkers-antivirus.com",
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



#### File Integrity Monitoring

- **Create an artifact**

  - URL: https://localhost:8080/v1/artifacts

  - Method: POST

  - Request Headers:

    - Authorization: {access-token}

  - Request Parameters: (x-www-form-urlencoded)

    - name: string
    - file-path: string
    - hash: string

  - Response: (201 CREATED)

    ```
    {
    	"id": int,
    	"name": string,
    	"filePath": string
    }
    ```



- **Validate an artifact**

  - URL: https://localhost:8080/v1/artifacts/{id}

  - Method: GET

  - Request Headers:

    - Authorization: {access-token}

  - Request Parameters:

    - id: int

  - Response: (200 OK)

    ```
    {
    	"message": string,
    	"valid": boolean
    }
    ```



- **Validate multiple artifacts**

  - URL: https://localhost:8080/v1/artifacts/{artifact-hashes}

  - Method: GET

  - Request Headers:

    - Authorization: {access-token}

  - Request Parameters:

    - artifact-hashes: string
      - List of artifacts, including their file paths and current hashes
      - File path and hash separated by a colon
      - Artifacts separated by commas

  - Response: (200 OK)

    ```
    {
    	"corruptArtifactFilePaths": string[]
    }
    ```