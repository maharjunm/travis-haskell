# EventUmbrellaServer
Event Umbrella Server. Written in [Servant](http://haskell-servant.readthedocs.io/)

## Setup

``` sh
# Install Haskell
brew install haskell-stack

# Clone the repository
git clone git@github.com:twhyderabad/EventUmbrellaServer.git eu-server
cd eu-server

# Install PostgreSQL & Create database (Till we include migrations)
brew install postgresql
createuser -s eu
createdb eu
cat schema.sql | psql -d eu -U eu
cat seed.sql | psql -d eu -U eu

# Build & launch
stack build
stack exec eu-server-exe
```

After this [http://localhost:8080/events](http://localhost:8080/events) should give you a list of events!
