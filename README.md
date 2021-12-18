# starter-snake-haskell

This repository contains the source code for a 'snake' (webserver) compatible with the battlesnake server. The web server is written in ## Haskell ##, and users write their snake AI in Haskell also.

---

## Installing and running the snake

### 1: Forking the repository

The first step is to fork the repository. This will create a clone of this repository where the reader is allowed to commit changes (their snake AI).

Then clone the repo to get the local files:

```
git clone https://github.com/<YOUR GITHUB USERNAME>/starter-snake-haskell.git
```

### 2: Installing requirements

The only requirement is the Haskell build tool [Stack](https://docs.haskellstack.org/en/stable/README/).
Stack will download the required components as necessary (GHC, Cabal, packages)

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

The code can be compiled by running (in the project directory):

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
`src/Info.hs`. The logic controlling the movement of the snake resides 
in `src/Move.hs`, along with some helper functions for extracting data 
from the received JSON objects.
