# starter-snake-haskell

This repository contains the source code for a 'snake' (webserver) compatible with the ## 2018 ## version of the battlesnake server. The web server is written in ## Haskell ##, and users write their snake AI in Haskell also.

The contents of this README will guide the reader through the process of getting their snake live on Heroku, ready to connect to a battlesnake server.

---

## Installing and running the snake

### 1: Forking the repository

The first step is to fork the repository. This will create a clone of this repository where the reader is allowed to commit changes (their snake AI).

![image broken](https://github.com/Rewbert/starter-snake-haskell/blob/master/image/fork.png "Forking the repository")

### 2: Installing requirements

The only requirement is a __1.7.1__ version or newer of the Haskell build tool 
[Stack](https://docs.haskellstack.org/en/stable/README/).
Stack will download the required components as necessary (GHC, Cabal, packages)

Note that the version of Stack in the Ubuntu repositories is outdated (1.5)
and therefore needs to be upgraded with `stack upgrade`  if it was installed 
through `sudo apt install haskell-stack`.

Another option is to use the generic Linux installer described in the
[official documentation](https://docs.haskellstack.org/en/stable/install_and_upgrade/#linux):

```bash
curl -sSL https://get.haskellstack.org/ | sh

# or

wget -qO- https://get.haskellstack.org/ | sh
```

Verify that Stack was installed correctly by running:

```
stack --version
```

### 3: Building and running the snake

The code can be compiled by running:

```
stack build
```

Running `stack install` will then copy an executable into `~/.local/bin` which 
can be run to start your snake. `stack exec starter-snake-haskell` 
accomplishes the same thing. You should get an output similar to:

```
Setting phasers to stun... (port 8080) (ctrl-c to quit)
```

From here, your snake will be listening for POST requests on 
`http://localhost:<port>`, `<port>` being 8080 in this case. 

After installing, and while developing, you can recompile and run the snake by 
running the following:

```
stack build && stack exec starter-snake-haskell-exe
```

## Configuring and programming the snake

The name, looks, and other properties of the snake can be configured in 
`src/Snake.hs`. The logic controlling the movement of the snake resides 
in `src/Move.hs`, along with some helper functions for extracting data 
from the received JSON objects.

## Uploading the snake to Heroku

These steps assume the reader already has an account on Heroku.

### 1: Create new application on Heroku

Next the reader should create a new application on Heroku. This is done in two simple steps. The first one is to click the 'New' button on the Heroku landing page (assuming the reader is logged in).

![image broken](https://github.com/Rewbert/starter-snake-haskell/blob/master/image/new-heroku-app.png "Create a new Heroku app")

Next, a unique name for the new application needs to be chosen, and the reader needs to specify their location.

![image broken](https://github.com/Rewbert/starter-snake-haskell/blob/master/image/create-new-app.png "Create a new Heroku app")

### 2: Connect the app to the snake repository

Now the new app needs to be configured such that it knows how to build the reader snake and how to deploy it (expose the snake API).

First the correct GitHub repository needs to be tracked. This is done by connecting the Heroku account to the readers GitHub account.

![image broken](https://github.com/Rewbert/starter-snake-haskell/blob/master/image/connect-to-github.png "Connect to GitHub")

After the GitHub account is connected it is possible to search through the users repositories and select the one containing the snake AI. Search for the name of the repository.

![image broken](https://github.com/Rewbert/starter-snake-haskell/blob/master/image/search-for-repo.png "Search for the repository")

### 3: Configure the app

In order to tell Heroku how to build and deploy the project, two components are needed. The `Procfile` in the repository tells Heroku the name of the file to deploy. This should be the same filename as described in the .cabal-file of the project.
The second component is a _Buildpack_, which contains instructions of how to build the project. We reach this configuration by first selecting the settings bar at the top of the page.

![image broken](https://github.com/Rewbert/starter-snake-haskell/blob/master/image/select-settings.png "Select the settings tab)

Once at the settings page, scroll down to the Buildpack part. Click the `Add Buildpack` button.

![image broken](https://github.com/Rewbert/starter-snake-haskell/blob/master/image/add-buildpack.png "Add a Buildpack")

Adding the proper Buildpack for a stack project is as simple as putting this link in the field that emerges: ## https://github.com/mfine/heroku-buildpack-stack ## (credits for the buildpack goes to [Joe Nelson et al](https://github.com/begriffs)). Click ok and the reader should see something like this.

![image broken](https://github.com/Rewbert/starter-snake-haskell/blob/master/image/added-buildpack.png "Added a Buildpack")

### 4: Deploying

The app should now be ready for deployment. Commit and push your snake AI code to the repository, and on the deployment page simply click deploy at the bottom.

![image broken](https://github.com/Rewbert/starter-snake-haskell/blob/master/image/manually-deploy.png "Deploy manually")

The first time the reader deploys his or her snake, stack will download all required dependencies. This can take up to 10 minutes (but only the first time). When all is done, it should look like this.

![image broken](https://github.com/Rewbert/starter-snake-haskell/blob/master/image/deploy-done.png "Deploying the snake")

Now, your Heroku app is located at https://yourappname.herokuapp.com, which in this example is https://haskell-nope-rope.herokuapp.com.















