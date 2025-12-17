#### This project is for the Devops bootcamp exercise for 
#### "Containers - Docker" 

Exercises for Module "Containers with Docker"

Use repository: https://gitlab.com/twn-devops-bootcamp/latest/07-docker/docker-exercises

Your team member has improved your previous static java application and added mysql database connection, to let users edit information and save the edited data.

They ask you to configure and run the application with Mysql database on a server using docker-compose.

🔸 [EXERCISE 0: Clone Git repository and create your own]
You can check out the code changes and notice that we are using environment variables for the database and its credentials inside the application.

This is very important for 2 reasons:

You don't want to expose the password to your database by hardcoding it into the app and checking it into the repository!
These values may change based on the environment, so you want to be able to set them dynamically when deploying the application, instead of hardcoding them.

    git clone https://gitlab.com/twn-devops-bootcamp/latest/07-docker/docker-exercises.git
    cd docker-exercises
    rm -rf .git
    git config --global user.name "Julia Davydova"
    git config --global user.email "juliada888@gmail.com"
    git init
    git add .
    git commit -m "Initial commit based on  docker-exercises"
    git remote add origin git@github.com:jdavydova/docker-exercises.git
    git push -u origin main

🔸 [EXERCISE 1: Start Mysql container]
EXERCISE 1: Start Mysql container
First you want to test the application locally with a mysql database. But you don't want to install Mysql, you want to get started fast, so you start it as a docker container:

Start mysql container locally using the official Docker image. Set all needed environment variables.
Export all needed environment variables for your application for connecting with the database (check variable names inside the code)
Build a jar file and start the application. Test access from browser. Make some changes.

    docker run -d \
    --name my-mysql \
    -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=rootsecret \
    -e MYSQL_DATABASE=myapp \
    -e MYSQL_USER=myuser \
    -e MYSQL_PASSWORD=mysecret \
    mysql:8.0

    gradle build

    grep -R "DB_" -n src || grep -R "MYSQL" -n src

<img width="1235" height="104" alt="Screenshot 2025-12-03 at 10 40 16 AM" src="https://github.com/user-attachments/assets/105b0c9b-75c2-4fc5-b971-d447fc40c1aa" />

    export DB_USER=myuser
    export DB_PWD=mysecret
    export DB_SERVER=localhost
    export DB_NAME=myapp

    java -jar  build/libs/docker-exercises-project-1.0-SNAPSHOT.jar

🔸 [EXERCISE 2: Start Mysql GUI container]

Now you have a database, you want to be able to see the database data using a UI tool, so you decide to deploy phpmyadmin. Again, you don't want to install it locally, so you want to start it also as a docker container.

Start phpmyadmin container using the official image.
Access phpmyadmin from your browser and test logging in to your Mysql database
    
    
     docker run -d \        
    > --name my-phpadmin \
    > -e PMA_HOST=host.docker.internal \
    > -e PMA_PORT=3306 \
    > -p 8082:80 \
    > phpmyadmin/phpmyadmin

     docker-exercises git:(main) ✗ docker ps      
    CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS          PORTS                         NAMES
    e1f33b13059e   phpmyadmin/phpmyadmin   "/docker-entrypoint.…"   58 seconds ago   Up 57 seconds   0.0.0.0:8082->80/tcp          my-phpadmin

phpMyAdmin:

    👉 http://localhost:8082 

Credentials of MySQL:

    MYSQL_DATABASE=myapp
    MYSQL_USER=myuser
    MYSQL_PASSWORD=mysecret
    MYSQL_ROOT_PASSWORD=rootsecret

Then log in with:
Regular user:

    Username: myuser
    Password: mysecret

Or, to log in as root:

    Username: root
    Password: rootsecret
    
<img width="1099" height="559" alt="Screenshot 2025-12-04 at 8 51 59 AM" src="https://github.com/user-attachments/assets/034b8fb2-5612-4c54-b36d-646f79c49bf7" />

🔸 [EXERCISE 3: Use docker-compose for Mysql and Phpmyadmin]
You have 2 containers your app needs and you don't want to start them separately all the time. So you configure a docker-compose file for both:

Create a docker-compose file with both containers
Configure a volume for your DB
Test that everything works again

Stop and remove the old containers:

    docker rm -f my-mysql my-phpadmin

Create docker-compose.yml:

    vim docker-compose.yml


        version: "3.8"

    services:
      db:
        image: mysql:8.0
        container_name: my-mysql
        environment:
          MYSQL_ROOT_PASSWORD: rootsecret
          MYSQL_DATABASE: myapp
          MYSQL_USER: myuser
          MYSQL_PASSWORD: mysecret
        ports:
          - "3306:3306"
        volumes:
          - db-data:/var/lib/mysql

      phpmyadmin:
        image: phpmyadmin/phpmyadmin
        container_name: my-phpadmin
        environment:
          PMA_HOST: db
          PMA_PORT: 3306
        ports:
          - "8082:80"
        depends_on:
          - db

    volumes:
      db-data:
        driver: local

Run:
    
    docker compose up -d

🔸 [EXERCISE 4: Dockerize your Java Application]
Now you are done with testing the application locally with Mysql database and want to deploy it on the server to make it accessible for others in the team, so they can edit information.

And since your DB and DB UI are running as docker containers, you want to make your app also run as a docker container. So you can all start them using 1 docker-compose file on the server. So you do the following:

Create a Dockerfile for your java application

Build the JAR locally:

    gradle build
    ls build/libs

Create Dockerfile (no extension)

    ➜  docker-exercises git:(main) ✗ vim Dockerfile               

    # Use a Java runtime
    FROM openjdk:17.0.2-jdk

    # Create work directory inside the container
    WORKDIR /opt/app

    # Copy the built JAR  into the image
    COPY build/libs/*.jar app.jar

    # The app usually runs on 8080 (Spring Boot / typical Java web app)
    EXPOSE 8080

    # Run the application
    ENTRYPOINT ["java", "-jar", "app.jar"]

Test the Dockerfile locally

    docker build -t my-java-app .

🔸 [EXERCISE 5: Build and push Java Application Docker Image]

Now for you to be able to run your java app as a docker image on a remote server, 
it must be first hosted on a docker repository, so you can fetch it from there on the server. Therefore, you have to do the following:

Create a docker hosted repository on Nexus
Build the image locally and push to this repository

Private Docker Repository 

Create repository:

<img width="971" height="746" alt="Screenshot 2025-12-05 at 10 09 29 AM" src="https://github.com/user-attachments/assets/8dbc4740-45bb-4f3a-854a-dab65ffd6849" />

Create User:

<img width="894" height="708" alt="Screenshot 2025-12-05 at 10 14 32 AM" src="https://github.com/user-attachments/assets/492b9db2-17f5-4fbf-8d8f-f7683342f0fc" />

Create Role:

<img width="752" height="794" alt="Screenshot 2025-12-05 at 10 14 51 AM" src="https://github.com/user-attachments/assets/30174ddb-ea2b-402b-a6ee-90dc5b1df2ad" />

Add HTTP 8083 port for reposytory:

<img width="844" height="660" alt="Screenshot 2025-12-05 at 10 23 35 AM" src="https://github.com/user-attachments/assets/d41f46da-e519-41c8-9b33-26c8704ea665" />

Check port:

<img width="704" height="208" alt="Screenshot 2025-12-05 at 10 19 48 AM" src="https://github.com/user-attachments/assets/9d9f4832-2073-42ca-af9f-b3ae77f53db5" />

Go to DigitalOcean and add to firewall port 8083:

<img width="1051" height="482" alt="Screenshot 2025-12-05 at 10 27 33 AM" src="https://github.com/user-attachments/assets/1f9e8dc9-12f7-419a-a65f-25e6d32c72be" />

On Docker Desktop
Go to Settings → Docker Engine
In the JSON, add your Nexus registry:

    "insecure-registries": ["167.172.125.11:8083"]

<img width="1086" height="473" alt="Screenshot 2025-12-06 at 4 36 30 PM" src="https://github.com/user-attachments/assets/dc44f20f-e568-435b-9029-d96656a8cb04" />

<img width="310" height="131" alt="Screenshot 2025-12-06 at 4 36 16 PM" src="https://github.com/user-attachments/assets/a1fceac9-a563-4626-82ad-005892ec7043" />

Push image to nexus repository docker:

    docker images 
    docker login 167.172.125.11:8083
    
<img width="548" height="199" alt="Screenshot 2025-12-06 at 4 43 05 PM" src="https://github.com/user-attachments/assets/bf2dcd21-79a7-45df-97ca-56cfdc49ff78" />

Tag image :

    docker tag my-java-app:latest 167.172.125.11:8083/my-java-app:1.0.0
    docker push 167.172.125.11:8083/my-java-app:1.0.0
    docker pull 167.172.125.11:8083/my-java-app:1.0.0


### NOTE:
 If i want get the initial admin password:
 Run on the droplet:

     docker exec -it nexus cat /nexus-data/admin.password

That prints the initial admin password.

Then in the browser:

    Username: admin
    Password: (the long value from admin.password)


Security realms:

<img width="997" height="639" alt="Screenshot 2025-12-12 at 9 18 21 AM" src="https://github.com/user-attachments/assets/f3f26418-0dd4-4e0c-be59-c9cc0b7f8f0a" />



🔸 [EXERCISE 6: Add application to docker-compose]

Add your application's docker image to docker-compose. Configure all needed env vars.
TIP: Ensure you configure a health check on your mysql container by including the following in your docker-compose file:

    json
    my-java-app:
      depends_on:
        mysql:
          condition: service_healthy
     mysql:
      healthcheck:
      test: [ "CMD", "mysqladmin", "ping", "-h", "localhost" ]
      interval: 10s
      timeout: 5s
      retries: 5
      
Now your app and Mysql containers in your docker-compose are using environment variables.

Make all these environment variable values configurable, by setting them on the server when deploying.
INFO: Again, since docker-compose is part of your application and checked in to the repo, it shouldn't contain any sensitive data. But also allow configuring these values from outside based on an environment

    docker ps | grep 3306 
    docker rm -f my-mysql
    docker logs my-java-app

Add .env file

    DB_SERVER=mysql
    DB_USER=myuser
    DB_PWD=mysecret
    DB_NAME=myapp

    MYSQL_ROOT_PASSWORD=rootsecret
    MYSQL_DATABASE=myapp
    MYSQL_USER=myuser
    MYSQL_PASSWORD=mysecret

    APP_IMAGE=159.65.101.43:8083/my-java-app:1.0.0

Add docker-compose-app.yml

    services:
      mysql:
        image: mysql:8.0
        container_name: mysql
        environment:
          MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
          MYSQL_DATABASE: ${MYSQL_DATABASE}
          MYSQL_USER: ${MYSQL_USER}
          MYSQL_PASSWORD: ${MYSQL_PASSWORD}
        ports:
          - "3306:3306"
        volumes:
          - db-data:/var/lib/mysql
        healthcheck:
          test: [ "CMD", "mysqladmin", "ping", "-h", "localhost" ]
          interval: 10s
          timeout: 5s
          retries: 5

      phpmyadmin:
        image: phpmyadmin
        container_name: phpmyadmin
        environment:
          PMA_HOST: mysql
          PMA_PORT: 3306
        ports:
          - "8083:80"
        depends_on:
          - mysql

      app:
        image: ${APP_IMAGE}
        container_name: my-java-app
        environment:
          DB_SERVER: ${DB_SERVER}
          DB_NAME: ${DB_NAME}
          DB_USER: ${DB_USER}
          DB_PWD: ${DB_PWD}
        ports:
          - "8080:8080"
        depends_on:
          mysql:
            condition: service_healthy

    volumes:
      db-data:
        driver: local

Run command:

     docker-compose --env-file .env -f docker-compose-app.yml up -d --force-recreate
     
🔸 [EXERCISE 7: Run application on server with docker-compose]    
Finally your docker-compose file is completed and you want to run your application on the server with docker-compose. For that you need to do the following:

Set insecure docker repository on server, because Nexus uses http
Run docker login on the server to be allowed to pull the image
Your application index.html has a hardcoded localhost as a HOST to send requests to the backend. You need to fix that and set the server IP address instead, because the server is going to be the host when you deploy the application on a remote server. (Don't forget to rebuild and push the image and if needed adjust the docker-compose file)
Copy docker-compose.yaml to the server
Set the needed environment variables for all containers in docker-compose
Run docker-compose to start all 3 containers

1) Configure the server to allow an insecure (HTTP) Docker registry

On the server (Ubuntu):

    sudo mkdir -p /etc/docker
    sudo vim /etc/docker/daemon.json

    {
      "insecure-registries": ["159.65.101.43:8083"]
    }


    docker ps | grep nexus

Test registry endpoint locally on the server:

    curl -v http://localhost:8083/v2/

    sudo mkdir -p /var/snap/docker/current/config
    sudo vim /var/snap/docker/current/config/daemon.json
    sudo systemctl daemon-reload
    sudo systemctl restart snap.docker.dockerd
    docker info | grep -i "insecure" -A 5

<img width="298" height="116" alt="Screenshot 2025-12-15 at 10 41 17 AM" src="https://github.com/user-attachments/assets/991998e3-ba9f-4d18-a53a-9b8e7ce03d6b" />

On the server: docker login to Nexus registry

    docker login 159.65.101.43:8083

<img width="896" height="166" alt="Screenshot 2025-12-15 at 10 45 48 AM" src="https://github.com/user-attachments/assets/a7fd8e7a-0695-4aeb-9a39-a7ca5d4a94c6" />

Edit index.html in src/main/resources/static/index.html file:
Best change: use relative URLs:

    const response = await fetch(`/get-data`);
    ...
    const response = await fetch(`/update-roles`, { ... })

   And delete the HOST constant entirely

   Why this is better:

    Works locally (http://localhost:8080) and on server (http://159.65.101.43:8080) with no code changes
    Avoids CORS issues completely
    No need to rebuild if IP/domain changes later

Optional: fix the broken image:
put pups.jpg into src/main/resources/static/pups.jpg
and then:

    <img src="/pups.jpg" alt="user-profile">

After edit the HTML we must rebuild your jar and rebuild/push the docker image again:
From the project root:

    ./gradlew clean build

My server is amd64, so I will build & push Docker image to Nexus (multi-arch)

   docker buildx build \
      --platform linux/amd64 \
      -t 159.65.101.43:8083/my-java-app:1.0.3 \
      --push .

(Increment tag from 1.0.2 → 1.0.3)

Copy compose + env to the server:

     scp docker-compose-app.yml deploy@159.65.101.43:/home/deploy/docker-compose.yml
     scp .env deploy@159.65.101.43:/home/deploy/env

Update env on the server:

    APP_IMAGE=<NEXUS_IP>:8083/my-java-app:1.0.3
    
Redeploy on the droplet:

    docker compose --env-file env down
    docker compose --env-file env up -d

<img width="797" height="158" alt="Screenshot 2025-12-15 at 10 53 56 AM" src="https://github.com/user-attachments/assets/d5021304-0360-4055-8b82-ef429ee1bc7d" />


<img width="965" height="752" alt="Screenshot 2025-12-17 at 10 50 15 AM" src="https://github.com/user-attachments/assets/863b6ae4-7a5e-425c-b975-c01bcff9d42c" />


NOTICE:

How to ad user on server to have permission run and deploy app:

    adduser deploy

<img width="638" height="323" alt="Screenshot 2025-12-16 at 9 28 05 AM" src="https://github.com/user-attachments/assets/fdf32110-583c-4728-b46d-e8197df673e7" />

    usermod -aG sudo deploy
    groupadd docker
    usermod -aG docker deploy

    mkdir /home/deploy/.ssh
    cp .ssh/authorized_keys /home/deploy/.ssh/
    chown -R deploy:deploy /home/deploy/.ssh
    chmod 700 /home/deploy/.ssh
    chmod 600 /home/deploy/.ssh/authorized_keys

    sudo chown -R deploy:docker /var/snap/docker/common/compose-app
    
    exit

    ssh deploy@159.65.101.43

    sudo chown root:docker /var/run/docker.sock
    sudo chmod 660 /var/run/docker.sock
    docker ps

to check:

    docker logs --tail=200 my-java-app
    


