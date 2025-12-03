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

1. Clone the training repository

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

   
   
