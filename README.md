# Model Docker Symfony

## Start

### *Create a new project:*

Edit the `.env` file to define the container settings, network name, and ports.

You can also change the name of the application directory (where Symfony will be installed) and the different versions.

Then run this command to create a web application Symfony container and project:

```sh
make create-full
```

For a minimal Symfony run this command:

```sh
make create-skeleton
```

### *Initialize an existing project:*

To Initialize an existing project, run this command:

```sh
make init
```

After the initialization, go to your project directory, update the .env (in particular to indicate the connection informations to the database) then run this command to initialize the database.

```sh
make db-init
```

or this command if fixtures existing:

```sh
make db-init-fixtures
```

### *Troubleshoot permission issues:*

If there are permission problems on the files, use this command:

```sh
make chown
```

### *Help:*

*Show all the available commands:*

```sh
make help
```
