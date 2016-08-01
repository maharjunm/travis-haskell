# EventUmbrellaServer
Event Umbrella Server. Written in [Servant](http://haskell-servant.readthedocs.io/)

## Setup

``` sh
# Install Haskell
brew install haskell-stack

# Clone the repository
git clone git@github.com:twhyderabad/EventUmbrellaServer.git eu-server
cd eu-server

# Build & launch
stack build
stack exec eu-server-exe
```

After this [http://localhost:8080](http://localhost:8080) should be running!
