### WHAT IS THIS ?

  Just a guide... to start deploying Meteor Apps with Docker. Its not a complete script or CLI. You are free to add wherever you want... OK ? :)

### RUNNING MULTIPLE APPS ?

  No problem, you can do it... just change the port in the setup of you deploy.sh for each project.


  `APP_1` ->  8001

  `APP2_` ->  8002


### WHAT YOU NEED TO INSTALL:

  - nginx

  - meteor

  - docker

### WHAT WILL DO ?

  It will build your app, set a docker with it an run inside it with forever + logs

  It will take the name of your project folder for example `AWESOME_APP/deploy/deploy.sh` the name of the docker will be `AWESOME_APP`.

### HOW TO DEPLOY YOUR APP ?

  - add the deploy folder in this repo to your project root (*remember to 777 deploy.sh*). Add the port you want to use.

  - push your changes.

  - clone your app on your server or wherever you are using.

  - run ./deploy.sh

### PROBLEMS SETTING UP NGINX FOR MULTIPLE APPS ?

[This guy did a great post](https://www.bersling.com/2016/05/17/deploying-multiple-meteor-apps-on-one-digitalocean-server/)
