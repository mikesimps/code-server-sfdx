# code-server-sfdx

Customized Visual Code Server built from coder/code-server to support Salesforce development using sfdx and other extensions. Image is based off the [official code-server image](https://github.com/cdr/code-server)

## Included Software

- sfdx cli
- Salesforce VS Code Extensions (and dependencies)
- linux packages
  - openjdk 8
  - jq
  - zsh (also installs OhMyZsh)
  - bsdtar
  - fira code font

## Usage

### Available Env Variables

#### code-server parameters

See the [code-server documentation](https://github.com/cdr/code-server/blob/master/doc/self-hosted/index.md/#Usage) for more information on the CS_ variables.

- CS_DATADIR [--user-data-dir]
- CS_EXTDIR [--extensions-dir]
- CS_CERT [--cert]
- CS_CERTKEY [--cert-key]
- CS_HOST [--host]
- CS_PORT [--port]
- CS_NOAUTH [--no-auth]
- CS_ALLOWHTTP [--allow-http]
- CS_PASSWORD [PASSWORD env variable]
- CS_DISABLETELEMETRY [--disable-telemetry]

#### custom parameters

code-server does not have a direct connection to the VS Code marketplace. As a workaround, use the additional extensions parameter to install the extensions you need.

**ADDL_EXTENSIONS_URL** - url to gist (or other text file) with a list of extentions to install

- A single extension names per line
- The name is the unique name that shows up on the VS Code Marketplace
  - Example - Gitlens: eamodio.gitlens
- Url must be in raw format (just append "/raw" to the end of the gist url)

### Fetch the docker image

```shell
docker pull mikesimps/code-server-sfdx:latest
```

### Just Run It

```shell
docker run -it \
    -e "CS_NOAUTH=true" \
    -p 127.0.0.1:8443:8443 \
    --mount type=bind,source="$(pwd)"/coder/,target=/home/coder \
    mikesimps/code-server-sfdx
```

### Recommended Configuration

```shell
# create the directories to persist your data
mkdir coder projects

docker run -it \
    -e "ADDL_EXTENSIONS_URL=<your url here>" \
    -e "CS_PASSWORD=<your password here>" \
    -p 127.0.0.1:8443:8443 \
    --mount type=bind,source="$(pwd)"/coder/,target=/home/coder \
    --mount type=bind,source="$(pwd)"/projects/,target=/home/coder/project \
    mikesimps/code-server-sfdx
```

### Post Install

#### sfdx configuration

Currently when creating a new sfdx connection, the code-server will not open a new web auth window to complete the authentication. You can either setup JWT tokens or utilize a connection from another machine. For the 2nd option do the following:

On the machine with the working connection run

```shell
sfdx force:org:display -u <your hub org> --verbose
```

You should see output similar to this

![image](https://user-images.githubusercontent.com/3085186/60504474-ab515000-9c8f-11e9-8700-691506f93b7e.png)

Copy the Sfdx Auth URL and put it into a text file on *your code-server environment*

Run this command to install the connection

```shell
sfdx force:auth:sfdxurl:store -f <path to your text file> -d -a <your hub alias>
```

### install new extensions

If you need to add more extensions, just update your gist file and either restart the container or execute the install extensions script:

```shell
install_extensions.sh
```
