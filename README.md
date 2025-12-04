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

Run:
    
    docker compose up -d

