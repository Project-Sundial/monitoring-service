# Sundial Monitoring Service

## Installation:

1. **Ensure Docker is Installed:**
   Make sure Docker is installed on your system, and you are logged in. If not, you can download and install Docker from [https://www.docker.com/get-started](https://www.docker.com/get-started).

2. **Configure PostgreSQL Password:**
   Open the `/docker/database/password.txt` file and save your PostgreSQL password - or the default `postgres`. This way the postgreSQL password is stored as a Docker Compose secret for added security. 

3. **Run Docker Compose:**
   Execute the following command in the terminal to launch the application with Docker Compose:

    ```bash
    docker compose up
    ```

   This command will start the application including the UI, app server, and PostgreSQL database.

## Accessing the Application:

- **Install the Linking Client:**
   After launching the Monitoring Service, install the [Linking Client](https://github.com/Project-Sundial/linking-client-executables).

- **Access the Dashboard:**
   Open your web browser and go to [http://localhost:3000](http://localhost:3000). to access the application dashboard.

- **Documentation:**
   For comprehensive information, configurations, and usage guidelines,  please consult [our docs.](https://sundial-docs.notion.site/Documentation-30c6f3cb1290473687ef55f8e4142e2e?pvs=4)

---

*Note: Ensure that the necessary ports, such as 3000 for the UI, are not occupied by other services on your machine.*
